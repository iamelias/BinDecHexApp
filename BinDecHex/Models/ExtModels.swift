//
//  SharedData.swift
//  BinDecHex
//
//  Created by Elias Hall on 1/12/20.
//  Copyright © 2020 Elias Hall. All rights reserved.
//

import Foundation

//MARK: REUSABLE CONSTANTS/MODELS

var unitChoices: [String] = ["Bin", "Dec", "Hex"]
var unitIndexDict: [String: Int] = ["Bin": 0, "Dec": 1, "Hex": 2]
var unitFullNameDict: [String: String] = ["Bin": "Binary", "Dec": "Decimal", "Hex": "Hexadecimal"]

enum FormatError: String,Error {
    case binError = "Error: Input must be binary format"
    case decError = "Error: Input must be in decimal format"
    case hexError = "Error: Input must be in hexadecimal format"
    case upperLimitError = "Error: Input is past upper limit"
    case blankError = "Error: Please enter your input"
    case syntaxError = "Error: Input Error"
}

