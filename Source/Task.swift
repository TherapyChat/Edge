//
//  Task.swift
//  Edge
//
//  Created by sergio on 09/01/2017.
//  Copyright © 2017 nc43tech. All rights reserved.
//

import Foundation

/// `JSON` parameters for `Task`
public typealias Parameters = [String: Any]

/// Headers for `Task`
public typealias Headers = [String: String]

/// Protocol responsible to defining 
public protocol Task {

    /// HTTP verb for request
    var method: HTTPMethod { get }

    /// Relative path for request
    var path: String { get }

    /// Custom headers for request
    var headers: Headers { get }

    /// Optional parameters for request
    var parameters: Parameters { get }

    /// Encoder parameters for url
    var encoding: Encoding { get }
}

extension Task {

    var id: Identifier {
        return method.rawValue + path + parameters.description
    }
}

public extension Task {

    var method: HTTPMethod {
        return .get
    }

    var parameters: Parameters {
        return [:]
    }

    var headers: Headers {
        return [:]
    }

    var encoding: Encoding {
        return JSONEncoding.default
    }

    /// Generate `URLRequest` with base `URL` and specific values
    func request(with baseURL: URL) -> URLRequest {
        let url = baseURL.appendingPathComponent(path)

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        request = encoding.encode(request: request, with: parameters)

        return request
    }
}
