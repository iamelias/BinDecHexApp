//
//  SharedData.swift
//  BinDecHex
//
//  Created by Elias Hall on 1/12/20.
//  Copyright © 2020 Elias Hall. All rights reserved.
//

import Foundation
import Metal
var UnitChoices: [String] = ["Bin", "Dec", "Hex"]
var labelDic: [String: Int] = ["Bin": 0, "Dec": 1, "Hex": 2]
var typeFullName: [String: String] = ["Bin": "Binary", "Dec": "Decimal", "Hex": "Hexadecimal"]

enum mChoices: String {
    case hexMsg = "Can't convert because input is not in hexadecimal format."
    case binMsg = "Can't convert because input is not in binary format."
    case decMsg = "Can't convert because input is not in decimal format. Input can't be negative."
    case upper = "Input is past upper limit"
    case sytanxMsg = "Input Error"
}

//enum Errors: Error {
//    case binErrorz "Error: Input must be binary format"
//    case decError = "Error: Input must be in decimal format"
//    case hexError = "Error: Input must be in hexadecimal format"
//    case upperLimitError = "Error: Input is past upper limit"
//}


enum FormatError: Error {
    case binError
    case decError
    case hexError
    case upperLimitError
    case syntaxError
}

var error: [FormatError: String] = [.binError:"Error: Input must be binary format", .decError:"Error: Input must be in decimal format", .hexError:"Error: Input must be in hexadecimal format", .upperLimitError:"Error: Input is past upper limit"]
