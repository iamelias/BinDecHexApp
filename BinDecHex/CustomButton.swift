//
//  CustomButton.swift
//  BinDecHex
//
//  Created by Elias Hall on 2/14/22.
//  Copyright © 2022 Elias Hall. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
final class CustomButton: UIButton {

//    var borderWidth: CGFloat = 1.0
//    var borderColor = UIColor.black.cgColor
    

    override init(frame: CGRect){
        super.init(frame: frame)
       
    }
    
    @IBInspectable override var isHighlighted: Bool {
        didSet {
            layer.opacity = isHighlighted ? 0.5 : 1.0
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setup()
    }

    func setup() {
        self.clipsToBounds = true
        self.layer.cornerRadius = 6.0
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1.0
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3.0
        self.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
    }
}
