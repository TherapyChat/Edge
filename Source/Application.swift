//
//  Application.swift
//  Edge
//
//  Created by sergio on 25/07/2017.
//  Copyright © 2017 nc43tech. All rights reserved.
//

import Foundation

/// Safe application abstraction for UIApplication/NSApplication
public final class Application<Base> {
    /// Generic type for UIApplication/NSApplication
    public let base: Base

    /// Default constructor for Application
    public init(_ base: Base) {
        self.base = base
    }
}

#if !os(macOS) && !os(watchOS) && !os(tvOS)

import UIKit

// MARK: - For App Extensions
extension Application where Base: UIApplication {

    /// Objective-C binding for safe UIApplication use on Application Extension
    public static var shared: UIApplication? {
        let selector = NSSelectorFromString("sharedApplication")
        guard
            Base.responds(to: selector),
            !Bundle.main.bundlePath.hasSuffix(".appex")
            else { return nil }
        return Base.perform(selector).takeUnretainedValue() as? UIApplication
    }
}

#endif
