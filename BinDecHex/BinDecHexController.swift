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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    //var selectedUnit = ""
    
    var UnitChoices: [String] = ["Bin", "Dec", "Hex"]
    var syntaxCheck: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextField.delegate = self
        fromPickerView.delegate = self
        toPickerView.delegate = self
        fromPickerView.dataSource = self
        toPickerView.dataSource = self
        activityIndicator.isHidden = true
        fromLabel.text = "Dec" //Initializing labels
        toLabel.text = "Dec"

       // fromLabel.font.
        
        fromPickerView.selectRow(1, inComponent: 0, animated: true) //default pickerview position
        toPickerView.selectRow(1, inComponent: 0, animated: true) 

    }
    
    @IBAction func convertButtonTapped(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
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
        let bin = getBinary()
        guard bin != "error" else{ return}
        
        if let bin = Int(inputTextField.text ?? "", radix: 2) {
            print(bin) // Output: 25
            let stringBin = "\(bin)"
            displayResult("Binary:",stringBin)
        }
    }

    func DecToBin() { //Transform decimal to binary with 8 digits //Complete
      //  let num = Int(inputTextField.text!) //input is ui textfield
        let retrievedDec = getDecimal()
        guard retrievedDec != "error" else {
            return
        }
        let bin = Int(retrievedDec)
        var binary = String(bin!, radix: 2) //converting from string to binary
            print(binary) //binary after conversion
//        let additional = 8 - binary.count
        print(binary.count) //number of elements in binary
        
        while binary.count != 8 { //while num of elements in binary is not equal to 8...
            
            binary = "0\(binary)" //add a 0 to beginning of string
        }
        
        print("full binary: \(binary)") //when elements = 8 print
        displayResult("Binary:",binary)
        
    }

    func BinToHex() {

        let bin = getBinary()
        guard bin != "error" else{
            
            return
            
        }
        
        let hex = String(Int(bin, radix: 2)!, radix: 16) //Convert Binary to Hex
        print(hex.uppercased())
        displayResult("Hexadecimal:",hex.uppercased())
        
    }
    
    func DecToHex() {
 print("reached dechex")
        //let dec = inputTextField.text!
        let retrievedDec = getDecimal()
        guard retrievedDec != "error" else {
            return
        }
       let dec = Int(retrievedDec)
        let hex = String(dec!, radix: 16)
        print(hex.uppercased()) // "3d"
        displayResult("Hexadecimal:",hex.uppercased())
    }
    
    func HexToBin() {
        let hex = getCheckHex()
        guard hex != "error" else{
            hexAlert()
            return
        }
        
        let bin = String(Int(hex, radix: 16)!, radix: 2)
        print(bin) // "1111101011001110"
        displayResult("Binary:",bin)
    }
    
    func HexToDec() {
        let hex = getCheckHex()
        guard hex != "error" else{
            hexAlert()
            return
        }
        let dec = Int(hex, radix: 16)!
        print(dec) // 163
        let stringDec = "\(dec)"
        displayResult("Decimal:",stringDec)
    }
    
    func getBinary() -> String {
        
        let bin = inputTextField.text!
        let checkSyntax = binaryCheck(bin) //checking input syntax
        guard checkSyntax == true else { //will only calculate if input is in right format else leave func
            return "error"
        }
        return bin
    }
    
    func getDecimal() -> String {
        let dec = inputTextField.text!
        let checkSyntax = decimalCheck(dec)
        guard checkSyntax == true else {
            return "error"
        }
        return dec
    }
    
    func getCheckHex() -> String { //Gets and Checks input Hex
        let hex = inputTextField.text!
        let checkHex = hex.map { $0.isHexDigit}
       
        for i in 0..<checkHex.count{
            if checkHex[i] == false {
                return "error"
            }
        }
        return hex
    }
    
    func decimalCheck(_ decNum: String) -> Bool {

        let checkNum = Int(decNum) //convert passed string to int, won't convert nonint
        print("checkNum: \(String(describing: checkNum))") //print the converted int
        if checkNum != nil { //if doesn't convert
        return true //it is a valid int/decimal
    }
        else {
            let alertTitle = "Sytnax Error"
            let alertMessage = "Can't convert because input is not in decimal format"
            alertMethod(alertTitle, alertMessage)
            
            return false
            
        }
    }
    
    func binaryCheck(_ binNum: String) -> Bool { //This method checks if input is in binary format
        
        for c in binNum { //checking if input is in binary syntax, if not 0/1 exit func
            
            if c != "0" && c != "1" {
                print("called alertmethod in binaryCheck")
                let alertTitle = "Syntax Error"
                let alertMessage = "Can't convert because input is not in binary format"
                alertMethod(alertTitle, alertMessage)
                return false //return false if syntax error
            }
            //else  {return true} //if no syntax error return true
        }
        return true
    }
    
    func alertMethod(_ alertTitle: String,_ alertMessage: String) { // Error alert
        print("called alert method")
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true)
        activityIndicator.stopAnimating()
    }
    
    func hexAlert() {
        let alertTitle = "Sytnax Error"
        let alertMessage = "Can't convert because input is not in hexadecimal format"
        alertMethod(alertTitle, alertMessage)
        activityIndicator.stopAnimating()
        
    }
    
    func displayResult(_ convertedType: String,_ convertedValue: String) {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        decValueLabel.text = convertedValue
        decLabel.text = convertedType
        
        
    }
    
}

//MARK: Extensions

extension BinDecHexController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputTextField.resignFirstResponder()
        return true
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

    
