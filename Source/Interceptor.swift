//
//  Interceptor.swift
//  Edge
//
//  Created by sergio on 12/01/2017.
//  Copyright © 2017 nc43tech. All rights reserved.
//

import Foundation

/// Protocol to intercept before/after network calls.
public protocol Interceptor {

    /// Transform URLRequest before executing
    func prepare(request: URLRequest) -> URLRequest

    /// Invoked right before execution
    func willExecute(request: Request)

    /// Invoked right after execution
    func didExecute(request: Request)

    /// Called when `Request` was processed
    func process(response: Response)

}

/// Default implementation for Interceptor pattern protocol
public extension Interceptor {

    func prepare(request: URLRequest) -> URLRequest { return request }
    func willExecute(request: Request) { }
    func didExecute(request: Request) { }
    func process(response: Response) { }

}
