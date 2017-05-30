//
//  InterceptorMock.swift
//  Edge
//
//  Created by sergio on 11/04/2017.
//  Copyright © 2017 nc43tech. All rights reserved.
//

import Foundation
import Edge

final class InterceptorMock {

    var willExecute = false
    var didExecute = false
    var process = false

}

extension InterceptorMock: Interceptor {

    func willExecute(request: Request) {
        willExecute = true
    }

    func didExecute(request: Request) {
        didExecute = true
    }

    func process(response: Response) {
        process = true
    }

}
