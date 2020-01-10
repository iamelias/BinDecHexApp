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
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromPickerView: UIPickerView!
    @IBOutlet weak var toPickerView: UIPickerView!
    @IBOutlet weak var decLabel: UILabel!
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
        decLabel.isHidden = true

       // fromLabel.font.
        
        fromPickerView.selectRow(1, inComponent: 0, animated: true) //default pickerview position
        toPickerView.selectRow(1, inComponent: 0, animated: true) 

    }
    
    @IBAction func convertButtonTapped(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        if (fromLabel.text == "Bin" && toLabel.text == "Dec") {
            binToDec()
        }
        
        else if (fromLabel.text == "Bin" && toLabel.text == "Hex") {
            binToHex()
        }
            
        else if (fromLabel.text == "Bin" && toLabel.text == "Bin") { //BinBin
                binToBin()
            }
        
        else if (fromLabel.text == "Dec" && toLabel.text == "Bin") {
            decToBin()
        }
        
        else if (fromLabel.text == "Dec" && toLabel.text == "Hex") {
            decToHex()
        }
        
        else if (fromLabel.text == "Dec" && toLabel.text == "Dec") {  //DecDec
            decToDec()
        }
        
        else if (fromLabel.text == "Hex" && toLabel.text == "Bin") {
            hexToBin()
        }
        
        else if (fromLabel.text == "Hex" && toLabel.text == "Dec") {
            hexToDec()
        }
            
        else if (fromLabel.text == "Hex" && toLabel.text == "Hex") { //HexHex
            hexToHex()
        }
        else { print("Error")}
    
    }
    
    func binToDec() { //Complete
        let bin = getBinary()
        guard bin != "error" else{ return}
        
        if let bin = Int(inputTextField.text ?? "", radix: 2) {
            let stringBin = "\(bin)"
            displayResult("Binary:",stringBin)
        }
    }

    func decToBin() { //Transform decimal to binary with 8 digits //Complete
      //  let num = Int(inputTextField.text!) //input is ui textfield
        
            let retrievedDec = getDecimal()
        guard retrievedDec != "error" else {
            return
        }
        let bin = Int(retrievedDec)
        print("made it passed int setup")
        var binary = String(bin!, radix: 2) //converting from string to binary
//        let additional = 8 - binary.count
        
        print("made it passed binary radix conversion")
        
        while binary.count < 8 { //while num of elements in binary is not equal to 8...
            
            binary = "0\(binary)" //add a 0 to beginning of string
        }
        
            displayResult("Binary:",binary)
        }
    
    
    func binToBin() {
        
        let bin = getBinary()
        
        guard bin != "error" else{
            return
        }
        
        displayResult("Binary:",bin)
    }
    
    func decToDec() {
        let dec = getDecimal()
        guard dec != "error" else {
            return
        }
        
        displayResult("Decimal:", dec)
    }
    
    func hexToHex() {
        let hex = getCheckHex()
        
        guard hex != "error" else{
            hexAlert()
            return
        }
        
        displayResult("Hexadecimal: ", hex)
    }

    func binToHex() {
        //DispatchQueue.main.async {
            let bin = self.getBinary()
        guard bin != "error" else{
            
            return
        }
        
        let hex = String(Int(bin, radix: 2)!, radix: 16) //Convert Binary to Hex
            displayResult("Hexadecimal:",hex.uppercased())
      //  }
    }
    
    func decToHex() {
        //let dec = inputTextField.text!
        let retrievedDec = getDecimal()
        guard retrievedDec != "error" else {
            return
        }
       let dec = Int(retrievedDec)
        let hex = String(dec!, radix: 16)
        displayResult("Hexadecimal:",hex.uppercased())
    }
    
    func hexToBin() {
        let hex = getCheckHex()
        guard hex != "error" else{
            hexAlert()
            return
        }
        
        let bin = String(Int(hex, radix: 16)!, radix: 2)
        displayResult("Binary:",bin)
    }
    
    func hexToDec() {
        let hex = getCheckHex()
        guard hex != "error" else{
            hexAlert()
            return
        }
        let dec = Int(hex, radix: 16)!
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
        if hex == "" {
            return "error"
        }
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
        
        if binNum == "" {
            let alertTitle = "Syntax Error"
            let alertMessage = "Can't convert because input is not in binary format"
            alertMethod(alertTitle, alertMessage)
            return false
        }
        
        for c in binNum { //checking if input is in binary syntax, if not 0/1 exit func
            
            if c != "0" && c != "1" {
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
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true)
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func hexAlert() {
        let alertTitle = "Sytnax Error"
        let alertMessage = "Can't convert because input is not in hexadecimal format"
        alertMethod(alertTitle, alertMessage)
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        
    }
    
    func displayResult(_ convertedType: String,_ convertedValue: String) {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        decValueLabel.text = convertedValue
        decLabel.text = convertedType
        decLabel.isHidden = false
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
        
        if pickerView.tag == 1 {
        fromLabel.text = UnitChoices[row]
        }
        
        else if pickerView.tag == 2 {
        toLabel.text = UnitChoices[row]
        }
    }
}

    
