//
//  EdgeSpec.swift
//  Edge
//
//  Created by sergio on 09/01/2017.
//  Copyright © 2017 nc43tech. All rights reserved.
//

import XCTest
import Nimble
import Reach

@testable import Edge

final class EdgeTests: XCTestCase {

    private lazy var sut: Edge = {
        let queueMock = Queue()
        let sessionMock = Session(with: MockTask.endpoint, session: URLSessionMock)
        let reachMock = Reach()
        return Edge(with: sessionMock, queue: queueMock, reach: reachMock)
    }()

    override func tearDown() {
        sut.removePlugIns()

        super.tearDown()
    }

    func testMakeRequest() {
        var reachedSuccessResponse = false
        var reachedFailureResponse = false

        waitUntil { done in
            self.sut.request(MockTask.get) { (result: JSONResponse) in
                switch result {
                case .success:
                    reachedSuccessResponse = true
                case .failure:
                    reachedFailureResponse = false
                }
                done()
            }
        }

        expect(reachedSuccessResponse).toEventually(beTruthy())
        expect(reachedFailureResponse).toEventually(beFalsy())
    }

    func testDefaultContentType() {
        var reachedSuccessResponse = false
        var reachedFailureResponse = false

        waitUntil { done in
            self.sut.request(MockTask.headers) { (result: JSONResponse) in
                switch result {
                case .success(let JSON):
                    if let headers = JSON["headers"] as? [String: Any],
                        let contentType = headers["Content-Type"] as? String {
                        expect(contentType).to(equal("application/json"))
                        reachedSuccessResponse = true
                    }
                case .failure:
                    reachedFailureResponse = false
                }
                done()
            }
        }

        expect(reachedSuccessResponse).toEventually(beTruthy())
        expect(reachedFailureResponse).toEventually(beFalsy())
    }

    func testAuthorizationHeader() {
        var reachedSuccessResponse = false
        var reachedFailureResponse = false

        waitUntil { done in
            let auth = Authorization(scheme: .Bearer, token: "token")
            self.sut.add(interceptor: auth)

            self.sut.request(MockTask.get) { (result: JSONResponse) in
                switch result {
                case .success(let JSON):
                    if let headers = JSON["headers"] as? [String: Any],
                        let contentType = headers["Authorization"] as? String {
                        expect(contentType).to(equal("Bearer token"))
                        reachedSuccessResponse = true
                    }
                case .failure:
                    reachedFailureResponse = false
                }
                done()
            }
        }

        expect(reachedSuccessResponse).toEventually(beTruthy())
        expect(reachedFailureResponse).toEventually(beFalsy())
    }

    func testQueryURLParameters() {
        var reachedSuccessResponse = false
        var reachedFailureResponse = false

        waitUntil { done in
            self.sut.request(MockTask.parameters) { (result: JSONResponse) in
                switch result {
                case .success(let JSON):
                    if let args = JSON["args"] as? [String: Any],
                        let showEnv = args["show_env"] as? String {
                        expect(showEnv).to(equal("1"))
                        reachedSuccessResponse = true
                    }
                case .failure:
                    reachedFailureResponse = false
                }
                done()
            }
        }

        expect(reachedSuccessResponse).toEventually(beTruthy())
        expect(reachedFailureResponse).toEventually(beFalsy())
    }

    func testURLEncodedParameters() {
        var reachedSuccessResponse = false
        var reachedFailureResponse = false

        waitUntil { done in
            self.sut.request(MockTask.get) { (result: JSONResponse) in
                switch result {
                case .success(let JSON):
                    if let headers = JSON["headers"] as? [String: Any],
                        let contentType = headers["Content-Type"] as? String {
                        expect(contentType).to(equal("application/x-www-form-urlencoded; charset=utf-8"))
                        reachedSuccessResponse = true
                    }
                case .failure:
                    reachedFailureResponse = false
                }
                done()
            }
        }

        expect(reachedSuccessResponse).toEventually(beTruthy())
        expect(reachedFailureResponse).toEventually(beFalsy())
    }

    func testEnqueuedRequest() {
        var reachedTwiceResponse = 0

        waitUntil { done in
            self.sut.request(MockTask.get) { (result: ResponseHandler) in
                switch result {
                case .success:
                    reachedTwiceResponse += 1
                case .failure:
                    reachedTwiceResponse = 0
                }
            }
            self.sut.request(MockTask.get) { (result: PlainResponse) in
                switch result {
                case .success:
                    reachedTwiceResponse += 1
                case .failure:
                    reachedTwiceResponse = 0
                }
                done()
            }
        }

        expect(reachedTwiceResponse).toEventually(equal(2))
    }

    func testClientStopExecution() {

        let queueMock = Queue()
        let sessionMock = Session(with: MockTask.endpoint)
        let reachMock = Reach()

        let sut = Edge(with: sessionMock, queue: queueMock, reach: reachMock)

        sut.stop()
        expect(queueMock.isStopped).to(beTruthy())
    }

    func testExecutingInterceptors() {

        let interceptor = InterceptorMock()
        sut.add(interceptor: interceptor)

        waitUntil { done in
            self.sut.request(MockTask.get) { (result: DataResponse) in
                done()
            }
        }

        expect(interceptor.willExecute).toEventually(beTruthy())
        expect(interceptor.didExecute).toEventually(beTruthy())
        expect(interceptor.process).toEventually(beTruthy())
    }

    func testErrorTask() {
        var reachedFailureResponse = false

        waitUntil { done in
            self.sut.request(ErrorTask.get) { (result: DataResponse) in
                if case .failure(let error) = result,
                    case HTTPError.Code.notFound = error.code {
                    reachedFailureResponse = true
                    print(error.localizedDescription)
                }
                done()
            }
        }
        expect(reachedFailureResponse).toEventually(beTruthy())
    }

    func testHostUnreachable() {
        var reachedFailureResponse = false

        let sut = Edge(with: "https://test.nc43tech.com")

        waitUntil { done in
            sut.request(ErrorTask.get) { (result: DataResponse) in
                if case .failure(let error) = result {
                    reachedFailureResponse = true
                    print(error.localizedDescription)
                }
                done()
            }
        }
        expect(reachedFailureResponse).toEventually(beTruthy())
    }
}

