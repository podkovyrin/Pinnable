//
//  NSLayoutConstraint+Extensions.swift
//
//
//  Created by Kyle Bashour on 1/12/21.
//

// swiftlint:disable attributes

import UIKit

public extension NSLayoutConstraint {
    /// Recursively activates array of arrays of constraints
    class func activate(_ constraints: [Any]) {
        let flatten: [NSLayoutConstraint] = constraints.flatten()
        NSLayoutConstraint.activate(flatten)
    }
}

public extension NSLayoutConstraint {
    /// Set the priority on the constraint.
    ///
    /// - Parameter priority: The value of the priority.
    /// - Returns: self
    @discardableResult func prioritize(_ priority: UILayoutPriority) -> Self {
        self.priority = priority
        return self
    }

    internal func setUp() -> NSLayoutConstraint {
        (firstItem as? UIView)?.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}
