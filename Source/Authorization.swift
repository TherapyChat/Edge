//
//  Authorization.swift
//  Edge
//
//  Created by sergio on 12/01/2017.
//  Copyright © 2017 nc43tech. All rights reserved.
//

import Foundation

/// Responsible to add Authorization Headers to `URLRequest`.
public struct Authorization {

    let scheme: Scheme
    let token: String

    /**
    Generates an instance with scheme and token
     
     - parameter scheme:    Type of authorization header request.
     - paramter token:      Plain string to sign requests.
     
     - returns:              New `Authorization` instance.
     */
    public init(scheme: Scheme, token: String) {
        self.scheme = scheme
        self.token = token
    }
}

public extension Authorization {

    /// Standard scheme for authorization requests
    enum Scheme: String {

        /// empty authorization header
        case None

        /// - header: `Authorization: Basic (token)`
        case Basic

        /// - header: `Authorization: Bearer (token)`
        case Bearer

        /// - header: `Authorization: JWT (token)`
        case JWT
    }
}

private extension Authorization {

    var serialize: String {
        return scheme.serialize + token
    }
}

private extension Authorization.Scheme {

    var serialize: String {
        switch self {
        case .None:
            return ""
        default:
            return self.rawValue + " "
        }
    }
}

// MARK: - Interceptor
extension Authorization: Interceptor {

    /// Inject Authorization header to `URLRequest`
    public func prepare(request: URLRequest) -> URLRequest {
        var authorizedRequest = request
        authorizedRequest.setValue(serialize, forHTTPHeaderField: "Authorization")
        return authorizedRequest
    }

}
