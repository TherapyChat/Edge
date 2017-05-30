//
//  Response.swift
//  Edge
//
//  Created by sergio on 10/01/2017.
//  Copyright © 2017 nc43tech. All rights reserved.
//

import Foundation

typealias HTTPResponse = (data: Data?, response: URLResponse?, error: Error?)

/// Responsible for handle `URLRequest` and `URLSessionDataTask` from `Task`.
public struct Response {
    let status: Status
    let header: Headers
    let data: Data?
    let url: URL?
}

extension Response {

    init?(with response: URLResponse?, data: Data?) {
        guard
            let response = response as? HTTPURLResponse,
            let header = response.allHeaderFields as? Headers
        else {
            return nil
        }
        self.status = response.statusCode
        self.header = header
        self.data = data
        self.url = response.url
    }

    var JSON: JSON {
        return Parser.transformer(data) ?? [:]
    }

    var plain: String {
        return Parser.transformer(data) ?? ""
    }
}
