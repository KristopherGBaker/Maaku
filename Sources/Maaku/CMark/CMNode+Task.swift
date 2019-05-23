//
//  CMNode+Task.swift
//  Maaku
//
//  Created by Kristopher Baker on 2019/05/23.
//  Copyright © 2019 Kristopher Baker. All rights reserved.
//

import Foundation
import libcmark_gfm

/// Extension properties for tasklist items
public extension CMNode {
    var taskCompleted: Bool? {
        // Only tasklist items should have a taskCompleted value.
        guard humanReadableType == CMExtensionName.tasklist.rawValue else {
            return nil
        }
        guard let value = cmark_gfm_extensions_get_tasklist_state(cmarkNode) else {
            return nil
        }
        // The state should either be "checked" or "unchecked".
        // If it is something else, then there is a mismatch between the C Parser and us.
        switch String(cString: value) {
        case "checked":
            return true
        case "unchecked":
            return false
        default:
            // It would be better if we could throw an exception,
            // but we'll have to settle for returning nil.
            return nil
        }
    }
}
