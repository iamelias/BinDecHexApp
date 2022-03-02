//
//  CalculatorViewModel.swift
//  BinDecHex
//
//  Created by Elias Hall on 2/16/22.
//  Copyright © 2022 Elias Hall. All rights reserved.
//

import Foundation

class CalculatorViewModel {
    
    var calculator: Calculator!
    
    weak var delegate: CalculatorViewModelDelegate?
    
    enum State {
        case detailed, blank
    }
    
    var currentState: State {
        if self.calculator.inputPick == "Dec" && self.calculator.outputPick == "Dec" && self.calculator.resultHidden == true, self.calculator.fieldText == "", self.calculator.resultValue == "" {
            return .blank
        } else {
            return .detailed
        }
    }
    
    var textField: String {
        return self.calculator.fieldText
    }
    var inputPick: String {
        return self.calculator.inputPick
    }
    var outputPick: String {
        return self.calculator.outputPick
    }
    var resultHidden: Bool {
        return self.calculator.resultHidden
    }
    
    var resultValue: String {
        return self.calculator.resultValue
    }
    var resultLabel: String {
        return "\(unitFullNameDict[outputPick] ?? ""): "
    }
    
    public init(calculator: Calculator) {
        self.calculator = calculator
    }
    
    func appendText(text: Character) {
        calculator.fieldText.append(text)
        delegate?.didUpdateTextField(textField: textField)
    }
    func clearText() {
        calculator.fieldText.removeAll()
        delegate?.didUpdateTextField(textField: textField)
    }
    func popText() {
        _ = calculator.fieldText.popLast()
        delegate?.didUpdateTextField(textField: textField)
    }
    
    func setInputPick(input: String) {
        calculator.inputPick = input
    }
    
    func setOutputPick(input: String) {
        calculator.outputPick = input
    }
    
    func refresh() {
        calculator.inputPick = "Dec"
        calculator.outputPick = "Dec"
        calculator.resultValue = ""
        calculator.fieldText = ""
        calculator.resultHidden = true
    }
    
    func convertFormat() {
        let checkBool: Bool = true
        switch checkBool {
        case inputPick == "Bin" && outputPick == "Dec": binToDec()
        case inputPick == "Bin" && outputPick == "Hex": binToHex()
        case inputPick == "Bin" && outputPick == "Bin": binToBin()
        case inputPick == "Dec" && outputPick == "Bin": decToBin()
        case inputPick == "Dec" && outputPick == "Hex": decToHex()
        case inputPick == "Dec" && outputPick == "Dec": decToDec()
        case inputPick == "Hex" && outputPick == "Bin": hexToBin()
        case inputPick == "Hex" && outputPick == "Dec": hexToDec()
        case inputPick == "Hex" && outputPick == "Hex": hexToHex()
        default: print("Error") //will never execute default
        }
    }
    
    func padBin(_ binary: String ) -> String { //Adds 0s to pad to 8 characters
        var editBinary = binary
        while editBinary.count < 8 {
            editBinary = "0\(editBinary)"
        }
        return editBinary
    }
    
    //MARK: VIEW CONVERSION METHODS
    func binToDec() {
        let error = checkBinaryError(input: textField)
        if let error = error {
            let inputError = InputError(errorType: error, title: "Input Error", message: error.rawValue)
            delegate?.didGetError(errorType: inputError)
        } else {
            if let dec = Int(textField, radix: 2) {
                calculator.resultHidden = false
                calculator.resultValue = "\(dec)"
                delegate?.didConvert()
            }
        }
    }
    
    func decToBin() {
        let error = checkDecimalError(input: textField)
        
        if let error = error {
            let inputError = InputError(errorType: error, title: "Input Error", message: error.rawValue)
            delegate?.didGetError(errorType: inputError)
        } else {
            let bin = Int(textField)
            if let bin = bin {
                let binary = String(bin, radix: 2) //converting from string to binary
                calculator.resultHidden = false
                calculator.resultValue = padBin(binary) //padding to the left with 0 until num of binary digits = 8
                delegate?.didConvert()
            }
        }
    }
    
    func binToBin() {
        let error = checkBinaryError(input: textField)
        if let error = error {
            let inputError = InputError(errorType: error, title: "Input Error", message: error.rawValue)
            delegate?.didGetError(errorType: inputError)
        } else {
            calculator.resultHidden = false
            calculator.resultValue = padBin(textField)
            delegate?.didConvert()
        }
    }
    
    func decToDec() {
        let error = checkDecimalError(input: textField)
        if let error = error {
            let inputError = InputError(errorType: error, title: "Input Error", message: error.rawValue)
            delegate?.didGetError(errorType: inputError)
        } else {
            calculator.resultHidden = false
            calculator.resultValue = textField
            delegate?.didConvert()
        }
    }
    
    func binToHex() {
        let error = checkBinaryError(input: textField)
        if let error = error {
            let inputError = InputError(errorType: error, title: "Input Error", message: error.rawValue)
            delegate?.didGetError(errorType: inputError)
        } else {
            let hex = String(Int(textField, radix: 2)!, radix: 16) //Convert Binary to Hex
            calculator.resultHidden = false
            calculator.resultValue = hex.uppercased()
            delegate?.didConvert()
        }
    }
    
    func decToHex() {
        let error = checkDecimalError(input: textField)
        if let error = error {
            let inputError = InputError(errorType: error, title: "Input Error", message: error.rawValue)
            delegate?.didGetError(errorType: inputError)
        } else {
            let dec = Int(textField)
            if let dec = dec {
                let hex = String(dec, radix: 16)
                calculator.resultHidden = false
                calculator.resultValue = hex.uppercased()
                delegate?.didConvert()
            }
        }
    }
    
    func hexToBin() {
        let error = checkHexadecimalError(input: textField)
        if let error = error {
            let inputError = InputError(errorType: error, title: "Input Error", message: error.rawValue)
            delegate?.didGetError(errorType: inputError)
        } else {
            var bin:String?
            let intInput = Int(textField, radix: 16) //first converting Hexadecimal(16) to Integer(10)
            if let intInput = intInput {
                bin = String(intInput, radix: 2) // then converting Integer(10) to a Binary(2) String
            }
            if let bin = bin {
                calculator.resultHidden = false
                calculator.resultValue = padBin(bin)
                delegate?.didConvert()
            }
        }
    }
    
    func hexToDec() {
        let error = checkHexadecimalError(input: textField)
        if let error = error {
            let inputError = InputError(errorType: error, title: "Input Error", message: error.rawValue)
            delegate?.didGetError(errorType: inputError)
        } else {
            let dec = Int(textField, radix: 16)
            if let dec = dec {
                calculator.resultHidden = false
                calculator.resultValue = "\(dec)"
                delegate?.didConvert()
            }
        }
    }
    
    func hexToHex() {
        let error = checkHexadecimalError(input: textField)
        if let error = error {
            let inputError = InputError(errorType: error, title: "Input Error", message: error.rawValue)
            delegate?.didGetError(errorType: inputError)
        } else {
            calculator.resultHidden = false
            calculator.resultValue = textField
            delegate?.didConvert()
        }
    }
    
    //MARK: CORRECT FORMAT CHECKERS
    func checkBinaryError(input: String ) -> FormatError? {
        do {
            _ = try Util.binaryCheck(input) //Calls the static throwable func in Util class
        }
        catch(FormatError.blankError) {
            return FormatError.blankError
        }
        catch (FormatError.binError) {
            return FormatError.binError
        }
        catch(FormatError.upperLimitError) {
            return FormatError.upperLimitError
        }
        catch {
            return FormatError.syntaxError
        }
        return nil
    }
    
    func checkDecimalError(input: String) -> FormatError? {
        do {
            _ = try Util.decimalCheck(input)
        }
        catch(FormatError.blankError) {
            return FormatError.blankError
        }
        catch(FormatError.decError) {
            return FormatError.decError
        }
        catch(FormatError.upperLimitError) {
            return FormatError.upperLimitError
        }
        catch {
            return FormatError.syntaxError
        }
        return nil
    }
    
    func checkHexadecimalError(input: String) -> FormatError? {
        do {
            _ = try Util.hexadecimalCheck(input)
        }
        catch(FormatError.blankError) {
            return FormatError.blankError
        }
        catch(FormatError.hexError) {
            return FormatError.hexError
        }
        catch(FormatError.upperLimitError) {
            return FormatError.upperLimitError
        }
        catch {
            return FormatError.syntaxError
        }
        return nil
    }
}
