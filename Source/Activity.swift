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
    var inProgress: Int {
        didSet {
            #if os(iOS)
                UIApplication.shared.isNetworkActivityIndicatorVisible = inProgress > 0
            #endif
        }
    }

    /// Create an instance of `Activity` network.
    public init(active: Int = 0) {
        inProgress = active
    }
}

extension Activity: Interceptor {

    // MARK: - Interceptor

    /// Increments in progress request counter by one
    public func willExecute(request: Request) {
        inProgress += 1
    }

    /// Decrease in progress request counter by one
    public func didExecute(request: Request) {
        inProgress -= 1
    }

}
