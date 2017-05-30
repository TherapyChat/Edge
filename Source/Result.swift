//
//  Result.swift
//  Edge
//
//  Created by sergio on 02/01/2017.
//  Copyright © 2017 nc43tech. All rights reserved.
//

import Foundation

/// Responsible for `Edge` closure responses
public enum Result<T> {

    /// success case with associated generic object
    case success(T)
    /// failure case with associated object that implements Error protocol
    case failure(HTTPError)

    init(value: T) {
        self = .success(value)
    }

    init(error: HTTPError) {
        self = .failure(error)
    }
}
