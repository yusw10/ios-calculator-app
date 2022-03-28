//
//  CalculatorItemQueue.swift
//  Calculator
//
//  Created by Lingo, mmim on 2022/03/28.
//

import Foundation

struct CalculatorItemQueue<Element: CalculateItem> {
  
  private var inputStack: [Element] = []
  private var outputStack: [Element] = []
  
  var count: Int {
    return inputStack.count + outputStack.count
  }
  
  var isEmpty: Bool {
    return inputStack.isEmpty && outputStack.isEmpty
  }
  
  var first: Element? {
    return outputStack.isEmpty ? inputStack.first : outputStack.last
  }
  
  var last: Element? {
    return inputStack.isEmpty ? outputStack.first : inputStack.last
  }
  
  mutating func enqueue(_ element: Element) {
    inputStack.append(element)
  }
  
  mutating func dequeue() -> Element? {
    if outputStack.isEmpty {
      outputStack = inputStack.reversed()
      inputStack.removeAll()
    }
    return outputStack.popLast()
  }
  
  mutating func removeAll() {
    inputStack.removeAll()
    outputStack.removeAll()
  }
}
