//
//  Queue.swift
//  Edge
//
//  Created by sergio on 10/01/2017.
//  Copyright © 2017 nc43tech. All rights reserved.
//

import Foundation

public typealias Identifier = String

/// Responsible for handle `Request` and eliminate redundant network requests.
public final class Queue {

    private var queue: [Identifier: Request]
    private var interceptors: [Interceptor]

    private(set) var isStopped = true

    init(queue: [Identifier: Request] = [:],
         interceptors: [Interceptor] = []) {
        self.queue = queue
        self.interceptors = interceptors
    }

    func start() {
        isStopped = false
        queue.values.forEach { $0.execute() }
    }

    func stop() {
        isStopped = true
        queue.values.forEach { $0.pause() }
    }

    func flush() {
        queue.values.forEach { $0.stop() }
        queue = [:]
    }

    func add(interceptor: Interceptor) {
        interceptors.append(interceptor)
    }

    func removeInterceptors() {
        interceptors.removeAll()
    }

    func prepare(request: URLRequest) -> URLRequest {
        return interceptors.reduce(request) { $1.prepare(request: $0) }
    }

    func enqueue(request: Request) {
        if let response = request.completion.first,
            let request = queue[request.id] {
            request.add(closure: response)
        } else {
            queue[request.id] = request
            execute(request)
        }
    }

    func remove(id: Identifier) {
        queue[id] = nil
    }

    func process(request: Request, response: HTTPResponse) {
        queue[request.id].flatMap { request in
            request.state = .finished
            self.interceptors.forEach { $0.didExecute(request: request) }
        }
        queue[request.id]?.completion.forEach { closure in
            let result: ResponseHandler

            if let error = response.error {
                result = .failure(HTTPError(error: error))
                request.state = .failed
            } else {
                guard
                    let HTTPResponse = Response(with: response.response, data: response.data)
                else {
                    fatalError("Couldn't get HTTP response")
                }

                if 200 ..< 300 ~= HTTPResponse.status {
                    result = .success(HTTPResponse)
                } else {
                    let error = HTTPError(status: HTTPResponse.status, message: HTTPResponse.JSON)
                    result = .failure(error)
                    request.state = .failed
                }

                self.interceptors.forEach { $0.process(response: HTTPResponse) }
            }
            closure(result)
        }
        remove(id: request.id)
    }

    private func execute(_ request: Request) {
        if isStopped { return }
        interceptors.forEach { $0.willExecute(request: request) }
        switch request.state {
        case .pending, .failed:
            request.execute()
        case .finished:
            remove(id: request.id)
        default: break
        }
    }

}
