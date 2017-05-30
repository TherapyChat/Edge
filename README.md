# Edge

A modern HTTP network library. Built on top of `URLSession`. 

## Table of Contents
* [Overview](#overview)
* [Features](#features)
* [Getting Started](#getting-started)
* [Installation](#installation)
* [Author](#author)
* [Contribution](#contribution)
* [License](#license)
* [Changelog](#changelog)

## Overview
Edge is a lightweight network abstraction layer. 
We designed Edge to be simple to use and also very flexible. We oriented this framework to make API REST requests. We have added some useful features like Authentication, Network activity indicator, and custom logging with `Interceptors`. This network layer queues all requests to avoid making redundant network requests. Also, when the user loses the connection, the requests are queued and are paused until the user recovers the network connection.

## Features
- Generic, protocol-based task implementation
- Eliminates redundant network requests
- Enqueue requests when user lost connection
- Singleton free
- Super friendly API
- Stop and go engine
- No external dependencies
- Robust `Interceptor` system
- Minimal implementation
- Support for `iOS/macOS/tvOS/watchOS/Linux`
- Support for CocoaPods/Carthage/Swift Package Manager

## Getting Started

This is a tiny example to build and execute a network request with `Edge`.

```swift
enum Foo {
    case bar
}

extension Foo: Task {
    var path: String {
        return "get"
    }
}

let client = Edge(with "https://httpbin.org")

client.request(Foo.bar) { (result: JSONResponse) in
    switch result {
    case .success(let JSON):
        print(JSON)
    case .failure(let error):
        print(error)
    }
}
```

## Interceptors

### Authentication

You can authenticate all requests with `Authorization`. 

```swift 

let jwt = Authorization(scheme: .Bearer, token: "1")

client.add(interceptor: jwt)

```

### Network Activity Indicator

You can show on status bar the network activity indicator with `Activity`.

```swift

let networkActivity = Activity()

client.add(interceptor: networkActivity)

```

### Custom Logger 

You can simple build a network interceptor to log all requests.

```swift

struct Logger: Interceptor {

    func willExecute(request: Request) {
        print(request)
    }

    func process(response: Response) {
        print(response)
    }

}

client.add(interceptor: Logger())
```

You can check the `Edge.playground` to experiment with more examples. If you need to see deeply information you can check our [Documentation](https://therapychat.github.io/Edge/)

## Installation

### CocoaPods

Edge is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
platform :ios, '10.0'
use_frameworks!
swift_version = '3.0'

target 'MyApp' do
  pod 'Edge'
end
```
### Carthage

You can also install it via [Carthage](https://github.com/Carthage/Carthage). To do so, add the following to your Cartfile:

```swift
github 'therapychat/Edge'
```

### Swift Package Manager

You can use [Swift Package Manager](https://swift.org/package-manager/) and specify dependency in `Package.swift` by adding this:
```
.Package(url: "https://github.com/therapychat/Edge.git", majorVersion: 0)
```

## Author

Sergio Fernández, fdz.sergio@gmail.com

## Contribution

For the latest version, please check [develop](https://github.com/therapychat/Edge/tree/develop) branch. Changes from this branch will be merged into the [master](https://github.com/therapychat/Edge/tree/master) branch at some point.

- If you want to contribute, submit a [pull request](https://github.com/therapychat/Edge/pulls) against a development `develop` branch.
- If you found a bug, [open an issue](https://github.com/therapychat/Edge/issues).
- If you have a feature request, [open an issue](https://github.com/therapychat/Edge/issues).

## License

Edge is available under the `Apache License 2.0`. See the [LICENSE](./LICENSE) file for more info.


## Changelog

See [CHANGELOG](./CHANGELOG) file.