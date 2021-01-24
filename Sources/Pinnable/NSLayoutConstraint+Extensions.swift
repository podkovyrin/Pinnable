//
//  NSLayoutConstraint+Extensions.swift
//
//
//  Created by Kyle Bashour on 1/12/21.
//

import UIKit

public extension NSLayoutConstraint {
    /// Set `isActive` to true.
    ///
    /// - Returns: self
    @discardableResult func activate() -> Self {
        isActive = true
        return self
    }

    /// Set `isActive` to false.
    ///
    /// - Returns: self
    @discardableResult func deactivate() -> Self {
        isActive = false
        return self
    }

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
        return activate()
    }
}
