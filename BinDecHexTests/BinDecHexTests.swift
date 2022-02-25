//
//  BinDecHexTests.swift
//  BinDecHexTests
//
//  Created by Elias Hall on 2/22/22.
//  Copyright © 2022 Elias Hall. All rights reserved.
//

import XCTest
@testable import BinDecHex

class BinDecHexTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCanInitialize() throws -> BinDecHexController { //Testing initializing of NavController and BinDecHexControlelr
        let bundle = Bundle(for: BinDecHexController.self)
        let storyB = UIStoryboard(name: "Main", bundle: bundle)
        
        let initialVC = storyB.instantiateInitialViewController()
        let navController = try XCTUnwrap(initialVC as? UINavigationController)
        
        let result = try XCTUnwrap(navController.topViewController as? BinDecHexController)
        
        return result
    }
    
    func testViewDidLoadDelegates() throws { //Testing delegates/dataSources initializing
        let selfInit = try testCanInitialize() //Testing testCanInitialize
        selfInit.loadViewIfNeeded()
        
        //Testing to ensure delegates and datasources contain an instance of 'self' and not nil
        //to pass
        XCTAssertNotNil(selfInit.fromPickerView.delegate)
        XCTAssertNotNil(selfInit.toPickerView.dataSource)
        XCTAssertNotNil(selfInit.fromPickerView.dataSource)
        XCTAssertNotNil(selfInit.toPickerView.dataSource)
        XCTAssertNotNil(selfInit.inputTextField.delegate)
        XCTAssertNotNil(selfInit.calculatorVM?.delegate)
        
        //to fail
        //Testing if delegates hold and instance of "self" class
        //            XCTAssertNil(selfInit.fromPickerView.delegate)
        //            XCTAssertNil(selfInit.toPickerView.dataSource)
        //            XCTAssertNil(selfInit.fromPickerView.dataSource)
        //            XCTAssertNil(selfInit.toPickerView.dataSource)
        //            XCTAssertNil(selfInit.inputTextField.delegate)
        //            XCTAssertNil(selfInit.calculatorVM?.delegate)
    }
    
    func testCalculatorViewModel() {
        let calculator = Calculator(fieldText: "01", inputPick: "Dec", outputPick: "Dec", resultHidden: false, resultValue: "01")
        
        let calculatorVM = CalculatorViewModel(calculator: calculator)
        
        //to pass
        XCTAssertEqual(calculator.inputPick, calculatorVM.inputPick)
        XCTAssertEqual(calculator.inputPick, calculatorVM.outputPick)
        XCTAssertEqual(calculator.fieldText, calculatorVM.textField)
        
        //to fail
        //        XCTAssertNotEqual(calculator.inputPick, calculatorVM.inputPick)
        //        XCTAssertNotEqual(calculator.inputPick, calculatorVM.outputPick)
        //        XCTAssertNotEqual(calculator.fieldText, calculatorVM.textField)
    }
    
    func testBinaryCheck() {
        //to pass
        XCTAssertNoThrow(try Util.binaryCheck("01"))
        XCTAssertNoThrow(try Util.binaryCheck("00"))
        XCTAssertNoThrow(try Util.binaryCheck("1"))
        XCTAssertNoThrow(try Util.binaryCheck("0"))
        XCTAssertNoThrow(try Util.binaryCheck("000001"))
        XCTAssertNoThrow(try Util.binaryCheck("000000"))
        XCTAssertNoThrow(try Util.binaryCheck("101111"))
        XCTAssertNoThrow(try Util.binaryCheck("111111"))
        
        XCTAssertThrowsError(try Util.binaryCheck("")) //Will throw blank error
        XCTAssertThrowsError(try Util.binaryCheck("2")) //Will throw format error
        XCTAssertThrowsError(try Util.binaryCheck("10023"))
        XCTAssertThrowsError(try Util.binaryCheck("001116"))
        XCTAssertThrowsError(try Util.binaryCheck("000111100011100005"))
        XCTAssertThrowsError(try Util.binaryCheck("353425345834534"))
        
        //to fail
        //        XCTAssertNoThrow(try Util.binaryCheck("")) //Will throw blank error
        //        XCTAssertNoThrow(try Util.binaryCheck("2")) //Will throw format error
        //        XCTAssertNoThrow(try Util.binaryCheck("10023"))
        //        XCTAssertNoThrow(try Util.binaryCheck("001116"))
        //        XCTAssertNoThrow(try Util.binaryCheck("000111100011100005"))
        //        XCTAssertNoThrow(try Util.binaryCheck("353425345834534"))
        
        //        XCTAssertThrowsError(try Util.binaryCheck("1000")) //Will throw blank error
        //        XCTAssertThrowsError(try Util.binaryCheck("00000")) //Will throw format error
        //        XCTAssertThrowsError(try Util.binaryCheck("01111"))
        //        XCTAssertThrowsError(try Util.binaryCheck("101010101"))
        //        XCTAssertThrowsError(try Util.binaryCheck("000000000000000000"))
        //        XCTAssertThrowsError(try Util.binaryCheck("1000100000100001"))
    }
    
    func testDecimalCheck() {
        //to pass
        XCTAssertNoThrow(try Util.decimalCheck("01"))
        XCTAssertNoThrow(try Util.decimalCheck("12"))
        XCTAssertNoThrow(try Util.decimalCheck("45"))
        XCTAssertNoThrow(try Util.decimalCheck("3444444"))
        XCTAssertNoThrow(try Util.decimalCheck("100010001"))
        XCTAssertNoThrow(try Util.decimalCheck("999999999"))
        XCTAssertNoThrow(try Util.decimalCheck("1000000000"))
        XCTAssertNoThrow(try Util.decimalCheck("0"))

        XCTAssertThrowsError(try Util.decimalCheck("")) //will throw blank error
        XCTAssertThrowsError(try Util.decimalCheck("1000000001")) //will throw upper limit error
        XCTAssertThrowsError(try Util.decimalCheck("00000000000000000000000")) //will throw upper limit error
        XCTAssertThrowsError(try Util.decimalCheck("A")) //will throw format error
        XCTAssertThrowsError(try Util.decimalCheck("4A"))
        XCTAssertThrowsError(try Util.decimalCheck("C2312EFF"))

        //to fail
//                XCTAssertThrowsError(try Util.decimalCheck("01"))
//                XCTAssertThrowsError(try Util.decimalCheck("12"))
//                XCTAssertThrowsError(try Util.decimalCheck("45"))
//                XCTAssertThrowsError(try Util.decimalCheck("3444444"))
//                XCTAssertThrowsError(try Util.decimalCheck("100010001"))
//                XCTAssertThrowsError(try Util.decimalCheck("999999999"))
//                XCTAssertThrowsError(try Util.decimalCheck("1000000000"))
//                XCTAssertThrowsError(try Util.decimalCheck("0"))
//
//                XCTAssertNoThrow(try Util.decimalCheck(""))
//                XCTAssertNoThrow(try Util.decimalCheck("1000000001"))
//                XCTAssertNoThrow(try Util.decimalCheck("00000000000000000000000"))
//                XCTAssertNoThrow(try Util.decimalCheck("A"))
//                XCTAssertNoThrow(try Util.decimalCheck("4A"))
//                XCTAssertNoThrow(try Util.decimalCheck("C2312EFF"))
    }
    
    func testHexadecimalCheck() {
        //to pass
        XCTAssertNoThrow(try Util.hexadecimalCheck("A"))
        XCTAssertNoThrow(try Util.hexadecimalCheck("0"))
        XCTAssertNoThrow(try Util.hexadecimalCheck("67"))
        XCTAssertNoThrow(try Util.hexadecimalCheck("01"))
        XCTAssertNoThrow(try Util.hexadecimalCheck("4E1F5"))
        XCTAssertNoThrow(try Util.hexadecimalCheck("A4F316F"))
        
        XCTAssertThrowsError(try Util.hexadecimalCheck("")) //will throw blank error
        XCTAssertThrowsError(try Util.hexadecimalCheck("A84212FC")) //will throw upper limit error
        
        //to fail
        //        XCTAssertThrowsError(try Util.hexadecimalCheck("A"))
        //        XCTAssertThrowsError(try Util.hexadecimalCheck("0"))
        //        XCTAssertThrowsError(try Util.hexadecimalCheck("67"))
        //        XCTAssertThrowsError(try Util.hexadecimalCheck("01"))
        //        XCTAssertThrowsError(try Util.hexadecimalCheck("4E1F5"))
        //        XCTAssertThrowsError(try Util.hexadecimalCheck("A4F316F"))
        //
        //        XCTAssertNoThrow(try Util.hexadecimalCheck(""))
        //        XCTAssertNoThrow(try Util.hexadecimalCheck("A84212FC"))
    }
    
    func testBinToBin() {
        let calculator = Calculator(fieldText: "1010", inputPick: "Bin", outputPick: "Bin", resultHidden: true, resultValue: "00001010")
        
        let calculatorVM = CalculatorViewModel(calculator: calculator)
        calculatorVM.convertFormat()
        
        //to pass
        XCTAssertFalse(calculatorVM.resultHidden)
        XCTAssertEqual(calculator.fieldText, calculatorVM.textField)
        XCTAssertEqual(calculator.resultValue, calculatorVM.resultValue)
        XCTAssertEqual(calculator.inputPick, calculatorVM.inputPick)
        XCTAssertEqual(calculator.outputPick, calculatorVM.outputPick)
        XCTAssertEqual(calculatorVM.textField, "1010")
        XCTAssertEqual(calculatorVM.resultValue, "00001010")
        
        //to fail
        //        XCTAssertTrue(calculatorVM.resultHidden)
        //        XCTAssertNotEqual(calculator.fieldText, calculatorVM.textField)
        //        XCTAssertNotEqual(calculator.resultValue, calculatorVM.resultValue)
        //        XCTAssertNotEqual(calculator.inputPick, calculatorVM.inputPick)
        //        XCTAssertNotEqual(calculator.outputPick, calculatorVM.outputPick)
        //        XCTAssertNotEqual(calculatorVM.textField, "1010")
        //        XCTAssertNotEqual(calculatorVM.resultValue, "00001010)
    }
    
    func testBinToDec() {
        let calculator = Calculator(fieldText: "0001", inputPick: "Bin", outputPick: "Dec", resultHidden: true, resultValue: "1")
        
        let calculatorVM = CalculatorViewModel(calculator: calculator)
        calculatorVM.convertFormat()
        
        //to pass
        XCTAssertFalse(calculatorVM.resultHidden)
        XCTAssertEqual(calculator.fieldText, calculatorVM.textField)
        XCTAssertEqual(calculator.resultValue, calculatorVM.resultValue)
        XCTAssertEqual(calculator.inputPick, calculatorVM.inputPick)
        XCTAssertEqual(calculator.outputPick, calculatorVM.outputPick)
        XCTAssertEqual(calculatorVM.textField, "0001")
        XCTAssertEqual(calculatorVM.resultValue, "1")
        
        //to fail
        //        XCTAssertTrue(calculatorVM.resultHidden)
        //        XCTAssertNotEqual(calculator.fieldText, calculatorVM.textField)
        //        XCTAssertNotEqual(calculator.resultValue, calculatorVM.resultValue)
        //        XCTAssertNotEqual(calculator.inputPick, calculatorVM.inputPick)
        //        XCTAssertNotEqual(calculator.outputPick, calculatorVM.outputPick)
        //        XCTAssertNotEqual(calculatorVM.textField, "0001")
        //        XCTAssertNotEqual(calculatorVM.resultValue, "1")
    }
    
    func testBinToHex() {
        let calculator = Calculator(fieldText: "0001010", inputPick: "Bin", outputPick: "Hex", resultHidden: true, resultValue: "A")
        
        let calculatorVM = CalculatorViewModel(calculator: calculator)
        calculatorVM.convertFormat()
        
        //to pass
        XCTAssertFalse(calculatorVM.resultHidden)
        XCTAssertEqual(calculator.fieldText, calculatorVM.textField)
        XCTAssertEqual(calculator.resultValue, calculatorVM.resultValue)
        XCTAssertEqual(calculator.inputPick, calculatorVM.inputPick)
        XCTAssertEqual(calculator.outputPick, calculatorVM.outputPick)
        XCTAssertEqual(calculatorVM.textField, "0001010")
        XCTAssertEqual(calculatorVM.resultValue, "A")
        
        //to fail
        //        XCTAssertTrue(calculatorVM.resultHidden)
        //        XCTAssertNotEqual(calculator.fieldText, calculatorVM.textField)
        //        XCTAssertNotEqual(calculator.resultValue, calculatorVM.resultValue)
        //        XCTAssertNotEqual(calculator.inputPick, calculatorVM.inputPick)
        //        XCTAssertNotEqual(calculator.outputPick, calculatorVM.outputPick)
        //        XCTAssertNotEqual(calculatorVM.textField, "0001010")
        //        XCTAssertNotEqual(calculatorVM.resultValue, "A")
    }
    
    func testDecToBin() {
        let calculator = Calculator(fieldText: "15", inputPick: "Dec", outputPick: "Bin", resultHidden: true, resultValue: "00001111")
        
        let calculatorVM = CalculatorViewModel(calculator: calculator)
        calculatorVM.convertFormat()
        
        //to pass
        XCTAssertFalse(calculatorVM.resultHidden)
        XCTAssertEqual(calculator.fieldText, calculatorVM.textField)
        XCTAssertEqual(calculator.resultValue, calculatorVM.resultValue)
        XCTAssertEqual(calculator.inputPick, calculatorVM.inputPick)
        XCTAssertEqual(calculator.outputPick, calculatorVM.outputPick)
        XCTAssertEqual(calculatorVM.textField, "15")
        XCTAssertEqual(calculatorVM.resultValue, "00001111")
        
        //to fail
        //        XCTAssertTrue(calculatorVM.resultHidden)
        //        XCTAssertNotEqual(calculator.fieldText, calculatorVM.textField)
        //        XCTAssertNotEqual(calculator.resultValue, calculatorVM.resultValue)
        //        XCTAssertNotEqual(calculator.inputPick, calculatorVM.inputPick)
        //        XCTAssertNotEqual(calculator.outputPick, calculatorVM.outputPick)
        //        XCTAssertNotEqual(calculatorVM.textField, "15")
        //        XCTAssertNotEqual(calculatorVM.resultValue, "00001111")
    }
    
    func testDecToDec() {
        let calculator = Calculator(fieldText: "18", inputPick: "Dec", outputPick: "Dec", resultHidden: true, resultValue: "18")
        
        let calculatorVM = CalculatorViewModel(calculator: calculator)
        calculatorVM.convertFormat()
        
        //to pass
        XCTAssertFalse(calculatorVM.resultHidden)
        XCTAssertEqual(calculator.fieldText, calculatorVM.textField)
        XCTAssertEqual(calculator.resultValue, calculatorVM.resultValue)
        XCTAssertEqual(calculator.inputPick, calculatorVM.inputPick)
        XCTAssertEqual(calculator.outputPick, calculatorVM.outputPick)
        XCTAssertEqual(calculatorVM.textField, "18")
        XCTAssertEqual(calculatorVM.resultValue, "18")
        
        //to fail
        //        XCTAssertTrue(calculatorVM.resultHidden)
        //        XCTAssertNotEqual(calculator.fieldText, calculatorVM.textField)
        //        XCTAssertNotEqual(calculator.resultValue, calculatorVM.resultValue)
        //        XCTAssertNotEqual(calculator.inputPick, calculatorVM.inputPick)
        //        XCTAssertNotEqual(calculator.outputPick, calculatorVM.outputPick)
        //        XCTAssertNotEqual(calculatorVM.textField, "18")
        //        XCTAssertNotEqual(calculatorVM.resultValue, "18")
    }
    
    func testDecToHex() {
        let calculator = Calculator(fieldText: "25", inputPick: "Dec", outputPick: "Hex", resultHidden: true, resultValue: "19")
        
        let calculatorVM = CalculatorViewModel(calculator: calculator)
        calculatorVM.convertFormat()
        
        //to pass
        XCTAssertFalse(calculatorVM.resultHidden)
        XCTAssertEqual(calculator.fieldText, calculatorVM.textField)
        XCTAssertEqual(calculator.resultValue, calculatorVM.resultValue)
        XCTAssertEqual(calculator.inputPick, calculatorVM.inputPick)
        XCTAssertEqual(calculator.outputPick, calculatorVM.outputPick)
        XCTAssertEqual(calculatorVM.textField, "25")
        XCTAssertEqual(calculatorVM.resultValue, "19")
        
        //to fail
        //        XCTAssertTrue(calculatorVM.resultHidden)
        //        XCTAssertNotEqual(calculator.fieldText, calculatorVM.textField)
        //        XCTAssertNotEqual(calculator.resultValue, calculatorVM.resultValue)
        //        XCTAssertNotEqual(calculator.inputPick, calculatorVM.inputPick)
        //        XCTAssertNotEqual(calculator.outputPick, calculatorVM.outputPick)
        //        XCTAssertNotEqual(calculatorVM.textField, "25")
        //        XCTAssertNotEqual(calculatorVM.resultValue, "19")
    }
    
    func testHexToBin() {
        let calculator = Calculator(fieldText: "28", inputPick: "Hex", outputPick: "Bin", resultHidden: true, resultValue: "00101000")
        
        let calculatorVM = CalculatorViewModel(calculator: calculator)
        calculatorVM.convertFormat()
        
        //to pass
        XCTAssertFalse(calculatorVM.resultHidden)
        XCTAssertEqual(calculator.fieldText, calculatorVM.textField)
        XCTAssertEqual(calculator.resultValue, calculatorVM.resultValue)
        XCTAssertEqual(calculator.inputPick, calculatorVM.inputPick)
        XCTAssertEqual(calculator.outputPick, calculatorVM.outputPick)
        XCTAssertEqual(calculatorVM.textField, "28")
        XCTAssertEqual(calculatorVM.resultValue, "00101000")
        
        //to fail
        //        XCTAssertTrue(calculatorVM.resultHidden)
        //        XCTAssertNotEqual(calculator.fieldText, calculatorVM.textField)
        //        XCTAssertNotEqual(calculator.resultValue, calculatorVM.resultValue)
        //        XCTAssertNotEqual(calculator.inputPick, calculatorVM.inputPick)
        //        XCTAssertNotEqual(calculator.outputPick, calculatorVM.outputPick)
        //        XCTAssertNotEqual(calculatorVM.textField, "28")
        //        XCTAssertNotEqual(calculatorVM.resultValue, "00101000")
    }
    
    func testHexToDec() {
        let calculator = Calculator(fieldText: "47", inputPick: "Hex", outputPick: "Dec", resultHidden: true, resultValue: "71")
        
        let calculatorVM = CalculatorViewModel(calculator: calculator)
        calculatorVM.convertFormat()
        
        //to pass
        XCTAssertFalse(calculatorVM.resultHidden)
        XCTAssertEqual(calculator.fieldText, calculatorVM.textField)
        XCTAssertEqual(calculator.resultValue, calculatorVM.resultValue)
        XCTAssertEqual(calculator.inputPick, calculatorVM.inputPick)
        XCTAssertEqual(calculator.outputPick, calculatorVM.outputPick)
        XCTAssertEqual(calculatorVM.textField, "47")
        XCTAssertEqual(calculatorVM.resultValue, "71")
        
        //to fail
        //        XCTAssertTrue(calculatorVM.resultHidden)
        //        XCTAssertNotEqual(calculator.fieldText, calculatorVM.textField)
        //        XCTAssertNotEqual(calculator.resultValue, calculatorVM.resultValue)
        //        XCTAssertNotEqual(calculator.inputPick, calculatorVM.inputPick)
        //        XCTAssertNotEqual(calculator.outputPick, calculatorVM.outputPick)
        //        XCTAssertNotEqual(calculatorVM.textField, "47")
        //        XCTAssertNotEqual(calculatorVM.resultValue, "71")
    }
    
    func testHexToHex() {
        let calculator = Calculator(fieldText: "E", inputPick: "Hex", outputPick: "Hex", resultHidden: true, resultValue: "E")
        
        let calculatorVM = CalculatorViewModel(calculator: calculator)
        calculatorVM.convertFormat()
        
        //to pass
        XCTAssertFalse(calculatorVM.resultHidden)
        XCTAssertEqual(calculator.fieldText, calculatorVM.textField)
        XCTAssertEqual(calculator.resultValue, calculatorVM.resultValue)
        XCTAssertEqual(calculator.inputPick, calculatorVM.inputPick)
        XCTAssertEqual(calculator.outputPick, calculatorVM.outputPick)
        XCTAssertEqual(calculatorVM.textField, "E")
        XCTAssertEqual(calculatorVM.resultValue, "E")
        
        //to fail
        //        XCTAssertTrue(calculatorVM.resultHidden)
        //        XCTAssertNotEqual(calculator.fieldText, calculatorVM.textField)
        //        XCTAssertNotEqual(calculator.resultValue, calculatorVM.resultValue)
        //        XCTAssertNotEqual(calculator.inputPick, calculatorVM.inputPick)
        //        XCTAssertNotEqual(calculator.outputPick, calculatorVM.outputPick)
        //        XCTAssertNotEqual(calculatorVM.textField, "E")
        //        XCTAssertNotEqual(calculatorVM.resultValue, "E")
    }
    
    func testPerformanceBinToBin() {
        let calculator = Calculator(fieldText: "1010", inputPick: "Bin", outputPick: "Bin", resultHidden: true, resultValue: "00001010")
        
        let calculatorVM = CalculatorViewModel(calculator: calculator)
        measure {
            calculatorVM.convertFormat()
        }
    }
    
    func testPerformanceBinToHex() {
        let calculator = Calculator(fieldText: "0001010", inputPick: "Bin", outputPick: "Hex", resultHidden: true, resultValue: "A")
        
        let calculatorVM = CalculatorViewModel(calculator: calculator)
        measure {
            calculatorVM.convertFormat()
        }
    }
    
    func testPerformanceDecToHex() {
        let calculator = Calculator(fieldText: "25", inputPick: "Dec", outputPick: "Hex", resultHidden: true, resultValue: "19")
        
        let calculatorVM = CalculatorViewModel(calculator: calculator)
        calculatorVM.convertFormat()
        measure {
            calculatorVM.convertFormat()
        }
    }
}


