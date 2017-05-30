//
//  Edge.swift
//  Edge
//
//  Created by sergio on 02/01/2017.
//  Copyright © 2017 nc43tech. All rights reserved.
//

import Foundation

/// Describes a Plain result response.
public typealias PlainResponse = (Result<String>)

/// Describes a JSON result response.
public typealias JSONResponse = (Result<JSON>)

/// Describes a Data result response.
public typealias DataResponse = (Result<Data?>)

/// Describes a Response result response.
public typealias ResponseHandler = (Result<Response>)

/// Network client responsible for executing `Task`
public final class Edge {

    private let queue: Queue
    private let session: Session

    // MARK: - Lifecycle

    /**
     Creates an instance with specific `Session` and `Queue`

     - parameter session:   The underlying session
     - parameter queue:     The underlying queue

     - returns: The new `Edge` instance.

     */
    public init(with session: Session, queue: Queue) {
        self.session = session
        self.queue = queue

        self.start()
    }

    /**
     Creates an instance with specific `URL`

     - parameter url:   The base URL to build future requests

     - returns:         The new `Edge` instance.
     
     */
    public convenience init(with url: URL) {
        let session = Session(with: url)
        let queue = Queue()
        self.init(with: session, queue: queue)
    }

    /**
     Creates an instance with a valid `URL` from `String`

     - parameter baseURL:   The base URL string to build future requests

     - returns:             The new `Edge` instance.

     */
    public convenience init(with baseURL: String) {
        guard let url = URL(string: baseURL) else { fatalError() }
        self.init(with: url)
    }

    // MARK: - Runtime

    /// Run all requests enqueue
    public func start() {
        if queue.isStopped {
            self.queue.start()
        }
    }

    /// Pause all requests enqueue
    public func stop() {
        queue.stop()
    }

    // MARK: - Interceptors

    /// Add an interceptor to queue
    public func add(interceptor: Interceptor) {
        queue.add(interceptor: interceptor)
    }

    /// Remove all interceptors from queue
    public func removePlugIns() {
        queue.removeInterceptors()
    }

    // MARK: - Execute

    /**
     Execute request `Task` with `JSON` as response

     - parameter task:           `Task` request especification
     - parameter completion:     closure with `JSONResponse` result
     */
    public func request<T: Task>(_ task: T, completion: @escaping ((JSONResponse) -> Void)) {
        execute(task) { result in
            switch result {
            case .success(let response):
                completion(.success(response.JSON))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /**
     Execute request `Task` with `String` as response

     - parameter task:           `Task` request especification
     - parameter completion:     closure with `PlainResponse` result
     */
    public func request<T: Task>(_ task: T, completion: @escaping ((PlainResponse) -> Void)) {
        execute(task) { result in
            switch result {
            case .success(let response):
                completion(.success(response.plain))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /**
     Execute request `Task` with `Data?` as response

     - parameter task:           `Task` request especification
     - parameter completion:     closure with `DataResponse` result
     */
    public func request<T: Task>(_ task: T, completion: @escaping ((DataResponse) -> Void)) {
        execute(task) { result in
            switch result {
            case .success(let response):
                completion(.success(response.data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /**
     Execute request `Task` with `Response` as response

     - parameter task:           `Task` request especification
     - parameter completion:     closure with `ResponseHandler` result
     */
    public func request<T: Task>(_ task: T, completion: @escaping ((ResponseHandler) -> Void)) {
        execute(task) { result in
            switch result {
            case .success(let response):
                completion(.success(response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    /// Executor request `Task` for all types of responses
    private func execute<T: Task>(_ task: T, completion: @escaping (TaskClosure)) {
        let url = self.queue.prepare(request: self.session.request(with: task))
        let request = Request(id: task.id, request: url, session: session, queue: queue, response: completion)
        queue.enqueue(request: request)
    }

}
