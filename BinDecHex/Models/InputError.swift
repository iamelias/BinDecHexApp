//
//  InputError.swift
//  BinDecHex
//
//  Created by Elias Hall on 2/22/22.
//  Copyright © 2022 Elias Hall. All rights reserved.
//

import Foundation

struct InputError {
    let errorType: FormatError
    let title: String
    let message: String
    
    public init(errorType: FormatError, title: String, message: String) {
        self.errorType = errorType
        self.title = title
        self.message = errorType.rawValue
    }
}
