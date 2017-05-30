import Foundation
import Edge
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true
/*:
 # Edge

 ### Foobar Value Type
 Enum case with all diferent requests
 */

enum Foobar {
    case foo
    case bar(String)
    case foobar
}

//: ## Task
//: Definition of all request statements
extension Foobar: Task {

    var method: HTTPMethod {
        switch self {
        case .bar:
            return .post
        default:
            return .get
        }
    }

    var path: String {
        switch self {
        case .foo:
            return "get"
        case .bar:
            return "post"
        case .foobar:
            return "encoding/utf8"
        }
    }

    var headers: Headers {
        return [
            "custom": "headers"
        ]
    }

    var parameters: Parameters {
        switch self {
        case .bar(let msg):
            return [
                "msg": msg
            ]
        default:
            return [:]
        }
    }

    var encoding: Encoding {
        switch self {
        case .bar:
            return JSONEncoding.default
        default:
            return URLEncoding.default
        }
    }

}

//: ### GET Request
//: - response: JSON Response
let client = Edge(with: "https://httpbin.org/")

client.request(Foobar.foo) { (response: JSONResponse) in
    switch response {
    case .success(let JSON):
        print(JSON)
    case .failure(let error):
        print(error)
    }
}

//: #### Authentication Interceptor
//: - header: { "Authorization": "Bearer 1" }

let token = Authorization(scheme: .Bearer, token: "1")
client.add(interceptor: token)

//: ### POST Request
//: - response: JSON Response

client.request(Foobar.bar("text")) { (response: JSONResponse) in
    switch response {
    case .success(let JSON):
        print(JSON)
    case .failure(let error):
        print(error)
    }
}

//: ### GET `encoding/utf8` Request
//: - response: String Response

client.request(Foobar.foobar) { (response: PlainResponse) in
    switch response {
    case .success(let text):
        print(text)
    case .failure(let error):
        print(error)
    }
}
