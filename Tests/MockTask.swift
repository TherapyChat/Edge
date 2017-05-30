//
//  MockTask.swift
//  Edge
//
//  Created by sergio on 19/01/2017.
//  Copyright © 2017 nc43tech. All rights reserved.
//

import Foundation
import Edge

enum MockTask {
    case get
    case headers
    case parameters
}

extension MockTask: Task {

    static let endpoint: URL = {
        guard
            let url = URL(string: "https://httpbin.org/")
        else { fatalError() }
        return url
    }()

    var path: String {
        switch self {
        case .get, .parameters:
            return "get"
        case .headers:
            return "headers"
        }
    }

    var parameters: Parameters {
        switch self {
        case .get, .headers:
            return [:]
        case .parameters:
            return [
                "show_env": 1
            ]
        }
    }

    var encoding: Encoding {
        switch self {
        case .get, .parameters:
            return URLEncoding.default
        case .headers:
            return JSONEncoding.default
        }
    }
}
