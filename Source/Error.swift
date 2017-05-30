//
//  Error.swift
//  Edge
//
//  Created by sergio on 11/01/2017.
//  Copyright © 2017 nc43tech. All rights reserved.
//

import Foundation

public typealias Status = Int

/// Custom HTTP `Edge` Error
public struct HTTPError: Error {

    /// HTTP status code response
    public let status: Status?

    /// Localized description from error
    public let message: JSON

    /// Typed status code
    public let code: Code
}

public extension HTTPError {

    /// Typed error cases from HTTP Responses
    enum Code {
        /// failed json parse
        case couldNotDecodeJSON
        /// - status: 404
        case notFound
        /// - status: 403
        case forbidden
        /// - status: 401
        case unauthorized
        /// - status: 400
        case badRequest
        /// - status: 5XX
        case internalError
        /// other internal error
        case other(Error)
    }
}

public extension HTTPError {

    /// Localized description from error
    var localizedDescription: String {
        return message.stringify
    }

    /// Generated an instance from status and `JSON`
    init(status: Int, message: JSON) {
        self.status = status
        self.message = message
        switch status {
        case 400:
            self.code = .badRequest
        case 401:
            self.code = .unauthorized
        case 403:
            self.code = .forbidden
        case 404:
            self.code = .notFound
        default:
            self.code = .internalError
        }
    }

    /// Transform error to HTTPError
    init(error: Error) {
        self.status = nil
        self.message = [
            "description": error.localizedDescription
        ]
        self.code = .other(error)
    }
}
