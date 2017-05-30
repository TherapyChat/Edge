//
//  SessionMock.swift
//  Edge
//
//  Created by sergio on 19/01/2017.
//  Copyright © 2017 nc43tech. All rights reserved.
//

import Foundation
import Edge

final class MockSessionDelegate: NSObject, URLSessionDelegate, URLSessionTaskDelegate {

    func urlSession(_ session: URLSession,
                    didReceive challenge: URLAuthenticationChallenge,
                    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(
            URLSession.AuthChallengeDisposition.useCredential,
            URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }

}

let URLSessionMock = URLSession(configuration: URLSessionConfiguration.default,
                                 delegate: MockSessionDelegate(),
                                 delegateQueue: OperationQueue.main)
