//
//  Stack.swift
//  BinDecHex
//
//  Created by Elias Hall on 1/7/20.
//  Copyright © 2020 Elias Hall. All rights reserved.
//

import Foundation

struct Stack<T> {
    var elementArray: [T] = []
    public var isEmpty: Bool {
        peek() == nil
    }
    
    public mutating func push(_ element: T) {
    
        elementArray.append(element)
    }
    
    public mutating func pop() -> T? {
        let popped = elementArray.popLast()
        
        return popped
    }
    
    public func peek() -> T? {
        elementArray.last
    }
    
}
