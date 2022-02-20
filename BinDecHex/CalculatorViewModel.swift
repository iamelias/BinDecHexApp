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

    enum State {
        case empty, notEmpty
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
    var resultPresent: Bool {
        return self.calculator.resultPresent
    }

    var resultValue: String {
        getFormat()
        return self.calculator.resultValue
    }

    public init(calculator: Calculator) {
        self.calculator = calculator
    }

     func appendText(text: Character) {
        calculator.fieldText.append(text)
    }
     func clearText() {
        calculator.fieldText.removeAll()
    }
     func popText() {
        _ = calculator.fieldText.popLast()
    }

    func getFormat() {
        let checkBool: Bool = true
        switch checkBool {
        case inputPick == "Bin" && outputPick == "Dec": binToDec()
            print("Bin-Dec")
        case inputPick == "Bin" && outputPick == "Hex": binToHex()
            print("Bin-Hex")
        case inputPick == "Bin" && outputPick == "Bin": binToBin()
            print("Bin-Bin")
        case inputPick == "Dec" && outputPick == "Bin": decToBin()
            print("Dec-Bin")
        case inputPick == "Dec" && outputPick == "Hex": decToHex()
            print("Dec-Hex")
        case inputPick == "Dec" && outputPick == "Dec": decToDec()
            print("Dec-Dec")
        case inputPick == "Hex" && outputPick == "Bin": hexToBin()
            print("Hex-Bin")
        case inputPick == "Hex" && outputPick == "Dec": hexToDec()
            print("Hex-Dec")
        case inputPick == "Hex" && outputPick == "Hex": hexToHex()
            print("Hex-Hex")
        default: print("Error") //will never execute decault
        }
    }

    func padBin(_ binary: String ) -> String { //adds 0s for padding
        var editBinary = binary
        while editBinary.count < 8 { //while num of elements in binary is not equal to 8...

            editBinary = "0\(editBinary)" //add a 0 to beginning of string
        }
        return editBinary
    }

    //MARK: CONVERSION METHODS
    func binToDec() { //Complete
        let bin = getBinary(input: textField)
        guard bin != "error" else{ return}
        if let dec = Int(textField, radix: 2) {
            calculator.resultValue = "\(dec)"
        }
    }

    func decToBin() { //Transform decimal to binary with 8 digits //Complete
        let retrievedDec = getDecimal(input: textField)
        guard retrievedDec != "error" else {
            return
        }
        let bin = Int(retrievedDec)
        var binary = String(bin!, radix: 2) //converting from string to binary

        binary = padBin(binary) //padding to the left with 0 until num of binary digits = 8
        calculator.resultValue = binary
    }

    func binToBin() {
        var bin = getBinary(input: textField)

        guard bin != "error" else{
            return
        }
        bin = padBin(bin)
      //  saveCore(bin)
        print("Binary: \(bin)")
        calculator.resultValue = bin
    }

    func decToDec() {
        let dec = getDecimal(input: textField)
        guard dec != "error" else {
            return
        }
        //saveCore(dec)
        print("Decimal: \(dec)")
        calculator.resultValue = dec
    }

    func hexToHex() {
        let hex = getCheckHex(input: textField)

        guard hex != "error" else{
        //    callErrorAlert(alert: (mChoices.sytanxMsg.rawValue, mChoices.hexMsg.rawValue))
            return
        }
        guard hex != "error2" else {
        //    callErrorAlert(alert: (mChoices.sytanxMsg.rawValue, mChoices.upper.rawValue))
            return
        }
      //  saveCore(hex.uppercased())
        print("Hex: \(hex.uppercased())")
        calculator.resultValue = hex.uppercased()
     //   displayResultView("Hexadecimal: ", hex.uppercased())
    }

    func binToHex() {
        let bin = self.getBinary(input: textField)
        guard bin != "error" else{
            return
        }
        let hex = String(Int(bin, radix: 2)!, radix: 16) //Convert Binary to Hex
    //    saveCore(hex.uppercased())
        print("Hex: \(hex.uppercased())")
        calculator.resultValue = hex.uppercased()
    }

    func decToHex() {
        let retrievedDec = getDecimal(input: textField)
        guard retrievedDec != "error" else {
            return
        }
        let dec = Int(retrievedDec)
        let hex = String(dec!, radix: 16)
    //    saveCore(hex.uppercased())
        print("Hex: \(hex.uppercased())")
        calculator.resultValue = hex
      //  displayResultView("Hexadecimal:",hex.uppercased())
    }

    func hexToBin() {
        let hex = getCheckHex(input: textField)
        guard hex != "error" else{
           // callErrorAlert(alert: (mChoices.sytanxMsg.rawValue, mChoices.hexMsg.rawValue))
            return
        }
        guard hex != "error2" else {
         //   callErrorAlert(alert: (mChoices.sytanxMsg.rawValue, mChoices.upper.rawValue))
            return
        }
        var bin = String(Int(hex, radix: 16)!, radix: 2)
        bin = padBin(bin)
   //     saveCore(bin)
        print("Binary: \(bin)")
        calculator.resultValue = bin
      //  displayResultView("Binary:",bin)
    }

    func hexToDec() {
        let hex = getCheckHex(input: textField)
        guard hex != "error" else{
         //   callErrorAlert(alert: (mChoices.sytanxMsg.rawValue, mChoices.hexMsg.rawValue))
            return
        }
        guard hex != "error2" else {
         //   callErrorAlert(alert: (mChoices.sytanxMsg.rawValue, mChoices.upper.rawValue))
            return
        }
        let dec = Int(hex, radix: 16)!
        let stringDec = "\(dec)"
     //   saveCore(stringDec)
        print("Decimal: \(dec)")
        calculator.resultValue = stringDec
    }

    func getBinary(input: String ) -> String {
        //let bin = input
        let checkSyntax = Util.binaryCheck(input) //checking input syntax
        guard checkSyntax == true else { //will only calculate if input is in right format else leave func
            return "error"
        }
        return input
    }

    func getDecimal(input: String) -> String {
       // let dec = input

        let checkSyntax = Util.decimalCheck(input)
        guard checkSyntax == true else {
            return "error"
        }
        return input
    }

    func getCheckHex(input: String) -> String { //Gets and Checks input Hex
        let hex = input

        if hex == "" {
            return "error"
        }

        if hex.count > 7 {
            return "error2"
        }
        let checkHex = hex.map { $0.isHexDigit}

        for i in 0..<checkHex.count{
            if checkHex[i] == false {
                return "error"
            }
        }
        return hex
    }

    //MARK: FORMAT CHECK METHODS

}
