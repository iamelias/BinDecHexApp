//
//  Util.swift
//  BinDecHex
//
//  Created by Elias Hall on 2/19/22.
//  Copyright © 2022 Elias Hall. All rights reserved.
//

import Foundation
import UIKit

class Util {
    
    static func hapticError() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }

    static func decimalCheck(_ decNum: String) throws -> Bool {
        if decNum == "" {
            throw FormatError.blankError
        }
        let checkNum = Int(decNum) //convert passed string to int, won't convert non-int
        if let checkNum = checkNum {
            if checkNum > 1000000000 {
                throw FormatError.upperLimitError
            }
            return true
        }
        else {
            throw FormatError.decError
        }
    }

    static func binaryCheck(_ binNum: String) throws -> Bool { //This method checks if input is in binary format
        if binNum == "" {
            throw FormatError.blankError
        }
        for c in binNum { //checking if input is in binary syntax, if not 0/1 exit func
            if c != "0" && c != "1" {
                throw FormatError.binError
            }
        }
        return true
    }
    
    static func hexadecimalCheck(_ hexNum: String) throws -> Bool {
        if hexNum == "" {
            throw FormatError.blankError
        }
        if hexNum.count > 7 {
            throw FormatError.upperLimitError
        }
        let checkHex = hexNum.map { $0.isHexDigit}
        for i in 0..<checkHex.count{
            if checkHex[i] == false {
                throw FormatError.hexError
            }
        }
        return true
    }
}

