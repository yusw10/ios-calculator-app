//
//  model.swift
//  Calculator
//
//  Created by Red on 2022/03/15.
//

import Foundation

protocol CalculateItem {
}

enum Operator: CalculateItem {
    case add, subtract, multiply, division
}

extension Double: CalculateItem {
}

struct CalculatorItemQueue {
    var queue: [Int: CalculateItem] = [:]
    var head: Int = 0
    var tail: Int = 0
    
    mutating func enqueue(with data: CalculateItem) {
        self.queue[tail] = data
        tail += 1
    }
    
    mutating func dequeue() -> CalculateItem? {
        if queue.isEmpty {
            return nil
        }
        let value = self.queue[head]
        head += 1
        return value
    }
    
    mutating func reset() {
        queue = [:]
        head = 0
        tail = 0
    }
}
