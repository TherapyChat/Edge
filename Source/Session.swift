//
//  Session.swift
//  Edge
//
//  Created by sergio on 10/01/2017.
//  Copyright © 2017 nc43tech. All rights reserved.
//

import Foundation

private let kiloBytes = 1024
private let megaBytes = 1024 * kiloBytes

/// Responsible for creating `URLRequest` and `URLSessionDataTask` objects, as well as their underlying `URLSession`.
public final class Session {

    private let baseURL: URL
    private let session: URLSession

    // MARK: - Lifecycle

    /**
     Creates an instance with specific `URL` and `URLSession`

     - parameter url:       Base url for requests
     - parameter session:   The underlying session

     - returns:             The new `Session` instance.

     */
    init(with url: URL, session: URLSession) {
        self.baseURL = url
        self.session = session
    }

    /**
     Creates an instance with specific `URL` with default `URLSession`

     - parameter url:   Base url for requests

     - returns:         The new `Session` instance.

     */
    convenience init(with url: URL) {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache(memoryCapacity: 10 * megaBytes, diskCapacity: 50 * megaBytes, diskPath: nil)
        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.httpAdditionalHeaders = Session.defaultHTTPHeaders
        let session = URLSession(configuration: configuration)
        self.init(with: url, session: session)
    }

    // MARK: - URLRequest

    /**
     Create a `URLRequest` from Task protocol specification

     - parameter task:  Generic type object with Task protocol implementation

     - returns:         URLRequest from task.

     */
    func request<T: Task>(with task: T) -> URLRequest {
        return task.request(with: self.baseURL)
    }

    // MARK: - URLSessionDataTask

    /**
     Transfrom an `URLRequest` to `URLSessionDataTask`

     - parameter request:       `URLRequest` to execute
     - parameter completion:    closure to handle response from `URLSessionDataTask`

     - returns: The new `Session` instance.

     */
    func task(with request: URLRequest, completion: @escaping (HTTPResponse) -> Void) -> URLSessionDataTask {
        return session.dataTask(with: request) { (data, response, error) in
            completion((data: data, response: response, error: error))
        }
    }
}

private extension Session {

    // MARK: - User-Agent

    /// Default User-Agent
    static let defaultHTTPHeaders: Headers = {
        guard
            let info = Bundle.main.infoDictionary
        else {
            return [
                "User-Agent": "Edge"
            ]
        }

        let executable = info[kCFBundleExecutableKey as String] as? String ?? "Unknown"
        let bundle = info[kCFBundleIdentifierKey as String] as? String ?? "Unknown"
        let appBuild = info[kCFBundleVersionKey as String] as? String ?? "Unknown"
        let appVersion = info["CFBundleShortVersionString"] as? String ?? "Unknown"

        let osNameVersion: String = {
            let osName: String = {
                #if os(iOS)
                    return "iOS"
                #elseif os(watchOS)
                    return "watchOS"
                #elseif os(tvOS)
                    return "tvOS"
                #elseif os(macOS)
                    return "macOS"
                #elseif os(Linux)
                    return "Linux"
                #else
                    return "Unknown"
                #endif
            }()

            let osVersion: String = {
                let version = ProcessInfo.processInfo.operatingSystemVersion
                return "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
            }()

            return "\(osName) \(osVersion)"
        }()

        let edgeVersion: String = {
            guard
                let edgeInfo = Bundle(for: Edge.self).infoDictionary,
                let edgeBuild = edgeInfo["CFBundleShortVersionString"]
            else {
                return "Unknown"
            }

            return "Edge/\(edgeBuild)"
        }()

        return [
            "User-Agent": "\(executable)/\(appVersion) (\(bundle); build:\(appBuild); \(osNameVersion)) \(edgeVersion)"
        ]
    }()

}
