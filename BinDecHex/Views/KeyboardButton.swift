//
//  KeyboardButton.swift
//  BinDecHex
//
//  Created by Elias Hall on 2/15/22.
//  Copyright © 2022 Elias Hall. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
final class KeyboardButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override var isHighlighted: Bool {
        didSet {
            layer.opacity = isHighlighted ? 0.5 : 1.0
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
