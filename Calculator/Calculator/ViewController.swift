//
//  Calculator - ViewController.swift
//  Created by yagom. 
//  Copyright © yagom. All rights reserved.
// 

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollViewContents: UIStackView!
    @IBOutlet weak var currentOperand: UILabel!
    @IBOutlet weak var currentOperator: UILabel!
    private var operationQueue: String = ""
    private let ZERO = "0"
    private var isEndOperation = false
    override func viewDidLoad() {
        super.viewDidLoad()
        clearScrollviewContent()
        clearCurrentOperand()
        clearCurrentOperator()
        // Do any additional setup after loading the view.
    }
    // MARK: - IBAction
    @IBAction func pressOperandButton(_ sender: UIButton) {
        isEndOperation = false
        if currentOperand.text?.first == "0" || currentOperand.text == "NaN"{
            currentOperand.text = ""
        }
        if currentOperand.text?.contains(".") == true,
           sender.currentTitle == "." {
            return
        }
        if currentOperand.text == "." {
            currentOperand.text = "0."
        }
        currentOperand?.text = (currentOperand?.text ?? "") + (sender.currentTitle ?? "")
    }
    
    @IBAction func pressOperatorButton(_ sender: UIButton) {
        guard currentOperand.text != ZERO else {
            currentOperator.text = (sender.currentTitle ?? "")
            return
        }
        addScrollViewContent()
        currentOperator.text = sender.currentTitle
        operationQueue += "\(currentOperand?.text ?? ZERO) \(sender.currentTitle ?? "") "
        //create Scrollview Content
        clearCurrentOperand()
        scrolling()
    }
    
    @IBAction func pressAllClearButton(_ sender: UIButton) {
        operationQueue = ""
        clearScrollviewContent()
        clearCurrentOperand()
        clearCurrentOperator()
    }
    @IBAction func pressClearEntryButton(_ sender: UIButton) {
        clearCurrentOperand()
    }
    @IBAction func pressReverseSignButton(_ sender: UIButton) {
        guard currentOperand.text != ZERO else {
            return
        }
        if currentOperand.text?.first == "-" {
            currentOperand.text?.removeFirst()
        } else {
            currentOperand.text = "-" + (currentOperand.text ?? "")
        }
    }
    @IBAction func pressEqualButton(_ sender: UIButton) {
        if isEndOperation {
            return
        }
        addScrollViewContent()
        operationQueue += currentOperand.text ?? ZERO
        operationQueue = operationQueue.filter {
            $0 != ","
        }
        var formula = ExpressionParser.parse(from: operationQueue)
        do {
            let operationResult = try formula.result()
            currentOperand.text = stringToDecimal(String(operationResult))
        } catch CalculatorError.divideByZero {
            currentOperand.text = "NaN"
        } catch {
            debugPrint("UNKNOWN ERROR")
        }
        clearCurrentOperator()
        operationQueue = ""
        scrolling()
        isEndOperation = true
    }
    
    //MARK: - ViewController Method
    private func clearCurrentOperand() {
        currentOperand.text = ZERO
    }
    private func clearCurrentOperator() {
        currentOperator.text = ""
    }
    private func clearScrollviewContent() {
        scrollViewContents.subviews.forEach { UIView in
            UIView.removeFromSuperview()
        }
    }
}
//MARK: - UI Components
extension ViewController {
    private func createScrollViewContent(_ inputOperator: String, _ inputOperand: String) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.addArrangedSubview(createUILabel(inputOperator))
        stackView.addArrangedSubview(createUILabel(inputOperand))
        return stackView
    }
    private func createUILabel(_ text: String) -> UILabel {
        let uiLabel = UILabel()
        uiLabel.textColor = .white
        uiLabel.font = .preferredFont(forTextStyle: .title3, compatibleWith: nil)
        uiLabel.text = text
        return uiLabel
    }
    private func addScrollViewContent() {
        let currentContent = createScrollViewContent(currentOperator.text ?? "", currentOperand.text ?? "")
        scrollViewContents.addArrangedSubview(currentContent)
    }
    private func scrolling() {
        scrollView.setContentOffset(CGPoint(x: 0,
                                            y: scrollView.contentSize.height - scrollView.bounds.height), animated: true)
    }
    private func stringToDecimal(_ input: String?) -> String {
        let filteredInput = input?.filter {
            $0 != ","
        }
        let numberFormmater = NumberFormatter()
        numberFormmater.numberStyle = .decimal
        numberFormmater.maximumSignificantDigits = 20
        return numberFormmater.string(for: Double(filteredInput ?? "")) ?? ""
    }
}
