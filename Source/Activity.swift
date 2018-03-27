//
//  Activity.swift
//  Edge
//
//  Created by sergio on 24/05/2017.
//  Copyright © 2017 nc43tech. All rights reserved.
//

#if os(iOS)
    import UIKit
#endif

/// Responsible for Network Activity Indicator on iOS Devices
public final class Activity {

    /// Counter for executing requests and handle network activity indicator.
    private var visible: Bool = false {
        didSet {
            if visible {
                activities += 1
            } else {
                activities -= 1
            }

            if activities < 0 {
                activities = 0
            }

            DispatchQueue.main.async {
                #if os(iOS)
                    Application<UIApplication>.shared?.isNetworkActivityIndicatorVisible = self.activities > 0
                #endif
            }
        }
    }

    private var activities = 0
    private let lock = NSLock()

    /// Create an instance of `Activity` network.
    public init(visible: Bool = false) {
        self.visible = visible
    }
}

extension Activity: Interceptor {

    // MARK: - Interceptor

    /// Increments in progress request counter by one
    public func willExecute(request: Request) {
        lock.lock(); defer { lock.unlock() }
        visible = true
    }

    /// Decrease in progress request counter by one
    public func didExecute(request: Request) {
        lock.lock(); defer { lock.unlock() }
        visible = false
    }

}
