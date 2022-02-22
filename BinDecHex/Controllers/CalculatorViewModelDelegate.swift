//
//  CalculatorViewModelDelegate.swift
//  BinDecHex
//
//  Created by Elias Hall on 2/22/22.
//  Copyright © 2022 Elias Hall. All rights reserved.
//

import Foundation

protocol CalculatorViewModelDelegate: AnyObject {
    func didUpdateTextField(textField: String)
    func didGetError(errorType: InputError)
    func didConvert()
}
