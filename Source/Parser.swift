//
//  Parser.swift
//  Edge
//
//  Created by sergio on 10/01/2017.
//  Copyright © 2017 nc43tech. All rights reserved.
//

import Foundation

/// Describes a common JSON response.
public typealias JSON = [String: Any]

/// Responsible to transform `Data` to `JSON` format.
public enum Parser {

    static func transformer(_ data: Data?) -> JSON? {
        guard
            let data = data,
            let object = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? JSON
        else {
            return nil
        }

        return object
    }

    static func transformer(_ data: Data?) -> String? {
        guard let data = data else { return nil }
        return String(bytes: data, encoding: .utf8)
    }
}

extension Dictionary where Key == String, Value == Any {

    var stringify: String {
        let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
        return String(data: data ?? Data(), encoding: .utf8) ?? ""
    }
}
