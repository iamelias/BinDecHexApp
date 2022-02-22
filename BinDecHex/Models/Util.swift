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

    static func decimalCheck(_ decNum: String) throws -> Bool { //Verifying that dec input is in correct format
        if decNum == "" {
            throw FormatError.blankError
        }
        let checkNum = Int(decNum) //Convert passed string to int, won't convert non-int characters ex. 'a'
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

    static func binaryCheck(_ binNum: String) throws -> Bool { //Verifying that bin input is in correct format
        if binNum == "" {
            throw FormatError.blankError
        }
        for c in binNum { //If char is not 0/1, throw error
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

