//
//  Pinnable.swift
//
//
//  Created by Kyle Bashour on 1/12/21.
//

import UIKit

/// A shared interface for the pinnable properties of `UIView` and `UILayoutGuide`.
public protocol Pinnable: AnyObject {
    var topAnchor: NSLayoutYAxisAnchor { get }
    var leadingAnchor: NSLayoutXAxisAnchor { get }
    var trailingAnchor: NSLayoutXAxisAnchor { get }
    var bottomAnchor: NSLayoutYAxisAnchor { get }

    var firstBaselineAnchor: NSLayoutYAxisAnchor { get }
    var lastBaselineAnchor: NSLayoutYAxisAnchor { get }

    var centerXAnchor: NSLayoutXAxisAnchor { get }
    var centerYAnchor: NSLayoutYAxisAnchor { get }

    var widthAnchor: NSLayoutDimension { get }
    var heightAnchor: NSLayoutDimension { get }
}

public extension Pinnable {
    /// Constrain the edges of the receiver to the corresponding edges of the provided view or layout guide.
    ///
    /// - Parameters:
    ///   - edges: The edges to constrain. The `left` and `right` edge will constrain the `leading` and `trailing` anchors, respectively. Defaults to `.all`.
    ///   - object: The object to constrain the receiver to.
    ///   - insets: Optional insets to apply to the constraints. The top, left, bottom, and right constants will be applied to the top, leading, bottom, and trailing edges, respectively. Defaults to `.zero`.
    /// - Returns: A named tuple of the created constraints. The properties are optional, as edges not specified will not have constraints.
    @discardableResult func pinEdges(
        _ edges: UIRectEdge = .all,
        to object: Pinnable,
        insets: UIEdgeInsets = .zero
    ) -> (top: NSLayoutConstraint?, leading: NSLayoutConstraint?, bottom: NSLayoutConstraint?, trailing: NSLayoutConstraint?) {
        let top = edges.contains(.top) ? topAnchor.pin(to: object.topAnchor, constant: insets.top) : nil
        let leading = edges.contains(.left) ? leadingAnchor.pin(to: object.leadingAnchor, constant: insets.left) : nil
        let bottom = edges.contains(.bottom) ? bottomAnchor.pin(to: object.bottomAnchor, constant: -insets.bottom) : nil
        let trailing = edges.contains(.right) ? trailingAnchor.pin(to: object.trailingAnchor, constant: -insets.right) : nil

        disableTranslatesAutoresizingMaskIntoConstraintsIfNeeded()
        NSLayoutConstraint.activate([top, leading, bottom, trailing].compactMap { $0 })

        return (top: top, leading: leading, bottom: bottom, trailing: trailing)
    }

    /// Constrain the horizontal edges of the receiver to the corresponding edges of the provided view or layout guide.
    ///
    /// - Parameters:
    ///   - object: The object to constrain the receiver to.
    ///   - leading: Optional leading inset. Defaults to `0`.
    ///   - trailing: Optional trailing inset. Defaults to `0`.
    /// - Returns:  A named tuple of the created constraints.
    @discardableResult func pinHorizontally(
        to object: Pinnable,
        leading: CGFloat = 0,
        trailing: CGFloat = 0
    ) -> (leading: NSLayoutConstraint, trailing: NSLayoutConstraint) {
        let edges = pinEdges([.left, .right], to: object, insets: .init(top: 0, left: leading, bottom: 0, right: trailing))

        return (leading: edges.leading!, trailing: edges.trailing!)
    }

    /// Constrain the vertical edges of the receiver to the corresponding edges of the provided view or layout guide.
    ///
    /// - Parameters:
    ///   - object: The object to constrain the receiver to.
    ///   - top: Optional top inset. Defaults to `0`.
    ///   - bottom: Optional bottom inset. Defaults to `0`.
    /// - Returns:  A named tuple of the created constraints.
    @discardableResult func pinVertically(
        to object: Pinnable,
        top: CGFloat = 0,
        bottom: CGFloat = 0
    ) -> (top: NSLayoutConstraint, bottom: NSLayoutConstraint) {
        let edges = pinEdges([.top, .bottom], to: object, insets: .init(top: top, left: 0, bottom: bottom, right: 0))

        return (top: edges.top!, bottom: edges.bottom!)
    }

    /// Constrain the center of the receiver to the center of the provided view or layout guide.
    ///
    /// - Parameters:
    ///   - object: The object to constrain the receiver to.
    ///   - offset: An optional offset for the constraints. The horizontal offset will be applied to the center X anchor, and the vertical offset will be applied to the center Y anchor. Defaults to `.zero`.
    /// - Returns: A named tuple of the created constraints.
    @discardableResult func pinCenter(
        to object: Pinnable,
        offset: UIOffset = .zero
    ) -> (x: NSLayoutConstraint, y: NSLayoutConstraint) {
        let centerX = centerXAnchor.pin(to: object.centerXAnchor, constant: offset.horizontal)
        let centerY = centerYAnchor.pin(to: object.centerYAnchor, constant: offset.vertical)

        disableTranslatesAutoresizingMaskIntoConstraintsIfNeeded()
        NSLayoutConstraint.activate([centerX, centerY])

        return (x: centerX, y: centerY)
    }

    /// Constrain the size of the receiver to the size of the provided view or layout guide.
    ///
    /// Note: to constrain a view or layout guide in a single dimension, pin the desired layout anchors directly, e.g.:
    ///
    ///     a.widthAnchor.pin(to: b.widthAnchor)
    ///
    /// - Parameters:
    ///   - object: The object to constrain the receiver to.
    /// - Returns: A named tuple of the created constraints.
    @discardableResult func pinSize(
        to object: Pinnable
    ) -> (width: NSLayoutConstraint, height: NSLayoutConstraint) {
        let height = heightAnchor.pin(to: object.heightAnchor)
        let width = widthAnchor.pin(to: object.widthAnchor)

        disableTranslatesAutoresizingMaskIntoConstraintsIfNeeded()
        NSLayoutConstraint.activate([height, width])

        return (width: width, height: height)
    }

    /// Constrain the size of the receiver to the provided constant size.
    ///
    /// Note: to constrain a view or layout guide in a single dimension, pin the desired layout anchor directly, e.g.:
    ///
    ///     a.widthAnchor.pin(to: 100)
    ///
    /// - Parameters:
    ///   - object: The size to constrain the receiver to.
    /// - Returns: A named tuple of the created constraints.
    @discardableResult func pinSize(
        to size: CGSize
    ) -> (width: NSLayoutConstraint, height: NSLayoutConstraint) {
        let height = heightAnchor.pin(to: size.height)
        let width = widthAnchor.pin(to: size.width)

        disableTranslatesAutoresizingMaskIntoConstraintsIfNeeded()
        NSLayoutConstraint.activate([height, width])

        return (width: width, height: height)
    }

    /// Constrain the width and height of the receiver to the provided constant.
    ///
    /// Note: to constrain a view or layout guide in a single dimension, pin the desired layout anchor directly, e.g.:
    ///
    ///     a.widthAnchor.pin(to: 100)
    ///
    /// - Parameters:
    ///   - object: The size to constrain the receiver's width and height to.
    /// - Returns: A named tuple of the created constraints.
    @discardableResult func pinSize(
        to constant: CGFloat
    ) -> (width: NSLayoutConstraint, height: NSLayoutConstraint) {
        pinSize(to: CGSize(width: constant, height: constant))
    }

    internal func disableTranslatesAutoresizingMaskIntoConstraintsIfNeeded() {
        if let self = self as? UIView {
            if self.translatesAutoresizingMaskIntoConstraints {
                self.translatesAutoresizingMaskIntoConstraints = false
            }
        }
    }
}
