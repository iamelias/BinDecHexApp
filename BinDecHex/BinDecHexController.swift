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
    @IBOutlet weak var decLabel: UILabel!
    @IBOutlet weak var binLabel: UILabel!
    @IBOutlet weak var hexLabel: UILabel!
    //var selectedUnit = ""
    
    var UnitChoices: [String] = ["Bin", "Dec", "Hex"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fromPickerView.delegate = self
        toPickerView.delegate = self
        fromPickerView.dataSource = self
        toPickerView.dataSource = self
        
        fromLabel.text = "Bin" //Initializing labels
        toLabel.text = "Bin"
        
        
    }
    
    @IBAction func convertButtonTapped(_ sender: Any) {
        
        if (fromLabel.text == "Bin" && toLabel.text == "Dec") {
            BinToDec()
        }
        
        else if (fromLabel.text == "Bin" && toLabel.text == "Hex") {
            BinToHex()
        }
        
        else if (fromLabel.text == "Dec" && toLabel.text == "Bin") {
            DecToBin()
        }
        
        else if (fromLabel.text == "Dec" && toLabel.text == "Hex") {
            DecToHex()
        }
        
        else if (fromLabel.text == "Hex" && toLabel.text == "Bin") {
            HexToBin()
        }
        
        else if (fromLabel.text == "Hex" && toLabel.text == "Dec") {
            HexToDec()
        }
        else { print("Error")}
    
    }
    
    func BinToDec() { //Complete
        
        if let number = Int(inputTextField.text ?? "", radix: 2) {
            print(number) // Output: 25
        }
    }

    func DecToBin() { //Transform decimal to binary with 8 digits //Complete
        let num = Int(inputTextField.text!) //input is ui textfield
        var binary = String(num!, radix: 2) //converting from string to binary
            print(binary) //binary after conversion
//        let additional = 8 - binary.count
        print(binary.count) //number of elements in binary
        
        while binary.count != 8 { //while num of elements in binary is not equal to 8...
            
            binary = "0\(binary)" //add a 0 to beginning of string
        }
        
        print("full binary: \(binary)") //when elements = 8 print
        
    }
    
    func BinToHex() {
        let binNum = inputTextField.text!
        let hexNum = String(Int(binNum, radix: 2)!, radix: 16) //Binary to Hex
        print(hexNum)
        
    }
    
    func DecToHex() {
 print("reached dechex")
        //let dec = inputTextField.text!
        let useDec = Int(inputTextField.text!)
        let hex = String(useDec!, radix: 16)
        print(hex) // "3d"
    }
    
    func HexToBin() {
        let hex = inputTextField.text!
        let bin = String(Int(hex, radix: 16)!, radix: 2)
        print(bin) // "1111101011001110"
    }
    
    func HexToDec() {
        let hex = inputTextField.text!
        let dec = Int(hex, radix: 16)!
        print(dec) // 163
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
        
            return UnitChoices[row] //format of each cell in pickerview
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
//        if fromLabel.is
        //pickerView'
        print("Made it here")
        if pickerView.tag == 1 {
            print("Reached here")
        fromLabel.text = UnitChoices[row]
        }
        
        else if pickerView.tag == 2 {
        toLabel.text = UnitChoices[row]
            print("Reached here 2")
        }
        
    }
}

