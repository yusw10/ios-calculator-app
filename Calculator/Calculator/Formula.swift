import Foundation

struct Formula {
    var operands = CalculatorItemQueue<Double>()
    var operators = CalculatorItemQueue<String>()
    
    func result() -> Double {

    }
}

extension String {
    func split(with target: Character) -> [String] {
        let splitedString = self.split(separator: target).map { String($0) }
        return splitedString
    }
}


enum ExpressionParser {
    func parse(from input: String) -> Formula {
        let operatorEnumArray = Operator.allCases.map { String($0.rawValue) }
        let inputCharacters = Array(input).map { String($0) }
        let inputOperator = inputCharacters.filter { operatorEnumArray.contains($0) == true }
        let inputOperands = componentsByOperators(from: input)
        
        let formula = Formula()
        for operandIndex in 0...inputOperands.count {
            formula.operands.insertToQueue(Double(inputOperands[operandIndex]) ?? 0)
        }
        for operatorIndex in 0...inputOperator.count {
            formula.operators.insertToQueue(inputOperator[operatorIndex])
        }
        return formula
    }

    private func componentsByOperators(from input: String) -> [String] {
        var splitedWithTarget: [String]
        var joinedString = input
        for operatorCase in Operator.allCases {
            splitedWithTarget = joinedString.split(with: operatorCase.rawValue)
            joinedString = splitedWithTarget.joined(separator: " ")
        }
        let inputOperands = joinedString.components(separatedBy: " ")
        return inputOperands
    }
}

