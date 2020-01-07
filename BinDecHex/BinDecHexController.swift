//
//  ViewController.swift
//  BinDecHex
//
//  Created by Elias Hall on 1/6/20.
//  Copyright © 2020 Elias Hall. All rights reserved.
//

import UIKit

class BinDecHexController: UIViewController {
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var decValueLabel: UILabel!
    @IBOutlet weak var binValueLabel: UILabel!
    @IBOutlet weak var hexValueLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromPickerView: UIPickerView!
    @IBOutlet weak var toPickerView: UIPickerView!
    //var selectedUnit = ""
    
    var fromUnitChoices: [String] = ["Bin", "Dec", "Hex"]
    var toUnitChoices: [String] = ["Bin", "Dec", "Hex"]
    var fromSelectedUnit: String?
    var toSelectedUnit: String?
    var selectedUnit = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        fromPickerView.delegate = self
        toPickerView.delegate = self
        fromPickerView.dataSource = self
        toPickerView.dataSource = self
        
        fromLabel.text = "Bin"
        toLabel.text = "Bin"
        
    }
    
    
}

extension BinDecHexController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
            return toUnitChoices[row] //format of each cell in pickerview
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
//        if fromLabel.is
        selectedUnit = fromUnitChoices[row] //selecting either breakfast, lunch, dinner, snacks
        //pickerView'
        print("Made it here")
        if pickerView.tag == 1 {
            print("Reached here")
        fromLabel.text = selectedUnit
        }
        
        else if pickerView.tag == 2 {
        toLabel.text = selectedUnit
            print("Reached here 2")
        }
        
    }
    
    
}
    
    
    


