//
//  Array+NestedFlatten.swift
//
//  Created by Andrew Podkovyrin on 23.08.2020.
//  Copyright © 2020. All rights reserved.
//

import Foundation

public extension Array {
    func flatten<T>(_ index: Int = 0) -> [T] {
        guard index < count else {
            return []
        }

        var flatten: [T] = []

        if let itemArr = self[index] as? [T] {
            flatten += itemArr.flatten()
        }
        else if let element = self[index] as? T {
            flatten.append(element)
        }
        return flatten + self.flatten(index + 1)
    }
}
