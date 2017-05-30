//
//  ErrorTask.swift
//  Edge
//
//  Created by sergio on 11/04/2017.
//  Copyright © 2017 nc43tech. All rights reserved.
//

import Foundation
import Edge

enum ErrorTask {
    case get
}

extension ErrorTask: Task {

    var path: String {
        return "hidden-basic-auth/user/passwd"
    }
}
