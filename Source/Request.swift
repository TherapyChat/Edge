//
//  Request.swift
//  Edge
//
//  Created by sergio on 10/01/2017.
//  Copyright © 2017 nc43tech. All rights reserved.
//

import Foundation

public typealias TaskClosure = (ResponseHandler) -> Void

/// Responsible for handle `URLRequest` and `URLSessionDataTask` from `Task`.
public final class Request {

    let id: Identifier
    let request: URLRequest
    var state: State
    var completion: [TaskClosure]
    var response: TaskClosure?

    private weak var session: Session?
    private weak var queue: Queue?

    private var task: URLSessionTask?

    init(id: Identifier, request: URLRequest, session: Session, queue: Queue, response: @escaping (TaskClosure)) {
        self.id = id
        self.request = request
        self.completion = [response]
        self.state = .pending
        self.queue = queue
        self.session = session
    }

    func add(closure: @escaping (TaskClosure)) {
        completion.append(closure)
    }

    func execute() {
        if case .running = state { return }
        task = session?.task(with: request) { response in
            self.state = .finished
            self.queue?.process(request: self, response: response)
        }
        task?.resume()
        state = .running
    }

    func pause() {
        task?.suspend()
        state = .pause
    }

    func stop() {
        task?.cancel()
        state = .finished
    }

}

extension Request {

    /// State machine that describe Request state.
    public enum State {
        /// request is created
        case pending
        /// request is in progress
        case running
        /// request is paused
        case pause
        /// request failed
        case failed
        /// request with successfully response
        case finished
    }
    
}
