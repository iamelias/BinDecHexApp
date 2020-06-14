//
//  SharedData.swift
//  BinDecHex
//
//  Created by Elias Hall on 1/12/20.
//  Copyright © 2020 Elias Hall. All rights reserved.
//

import Foundation
var UnitChoices: [String] = ["Bin", "Dec", "Hex"]
var labelDic: [String: Int] = ["Bin": 0, "Dec": 1, "Hex": 2]
var typeFullName: [String: String] = ["Bin": "Binary", "Dec": "Decimal", "Hex": "Hexadecimal"]

enum mChoices: String {
    case hexMsg = "Can't convert because input is not in hexadecimal format"
    case binMsg = "Can't convert because input is not in binary format"
    case decMsg = "Can't convert because input is not in decimal format"
    case upper = "Input is past upper limit"
    case sytanxMsg = "Syntax Error"
}


