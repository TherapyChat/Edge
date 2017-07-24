//
//  Method.swift
//  Edge
//
//  Created by sergio on 09/01/2017.
//  Copyright © 2017 nc43tech. All rights reserved.
//

import Foundation

/// HTTP Verbs
public enum HTTPMethod {

    /// - verb: GET
    case get
    /// - verb: HEAD
    case head
    /// - verb: POST
    case post
    /// - verb: PUT
    case put
    /// - verb: DELETE
    case delete
    /// - verb: CONNECT
    case connect
    /// - verb: OPTIONS
    case options
    /// - verb: TRACE
    case trace
    /// - verb: PATCH
    case patch
}

extension HTTPMethod: RawRepresentable {
    public typealias RawValue = String

    /// Transform String to HTTP Method
    public init?(rawValue: RawValue) {
        switch rawValue {
        case HTTPMethod.get.rawValue:
            self = .get
        case HTTPMethod.head.rawValue:
            self = .head
        case HTTPMethod.post.rawValue:
            self = .post
        case HTTPMethod.put.rawValue:
            self = .put
        case HTTPMethod.delete.rawValue:
            self = .delete
        case HTTPMethod.connect.rawValue:
            self = .connect
        case HTTPMethod.options.rawValue:
            self = .options
        case HTTPMethod.trace.rawValue:
            self = .trace
        case HTTPMethod.patch.rawValue:
            self = .patch
        default:
            return nil
        }
    }

    /// Transform to HTTP verb string
    public var rawValue: RawValue {
        switch self {
        case .get: return "GET"
        case .put: return "PUT"
        case .post: return "POST"
        case .head: return "HEAD"
        case .trace: return "TRACE"
        case .patch: return "PATCH"
        case .delete: return "DELETE"
        case .options: return "OPTIONS"
        case .connect: return "CONNECT"
        }
    }
    
}

extension URLRequest {

    var method: HTTPMethod {
        return HTTPMethod(rawValue: httpMethod ?? "GET") ?? .get
    }
}
