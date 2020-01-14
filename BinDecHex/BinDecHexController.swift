//
//  ViewController.swift
//  BinDecHex
//
//  Created by Elias Hall on 1/6/20.
//  Copyright © 2020 Elias Hall. All rights reserved.
//

import UIKit
import CoreData

class BinDecHexController: UIViewController {
    //MARK: IBOutlets
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var resultValueLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromPickerView: UIPickerView!
    @IBOutlet weak var toPickerView: UIPickerView!
    @IBOutlet weak var resLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var syntaxCheck: Bool = false
    var saveEntryName: [SavedEntry] = []
    var coreDataRetrieved: Bool = false
    var fetchResult: [SavedEntry] = []
    var dataCopy: SavedEntry?
    let context = DatabaseController.persistentStoreContainer().viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextField.delegate = self
        fromPickerView.delegate = self
        toPickerView.delegate = self
        fromPickerView.dataSource = self
        toPickerView.dataSource = self
        fromLabel.text = "Dec" //Initializing labels
        toLabel.text = "Dec"
        resLabel.isHidden = true
        retrieveCoreData() //getting persisted data
        activityIndicator.isHidden = true //hiding activity indicator
        //       deleteCoreGroup()
        
        fromPickerView.selectRow(labelDic[fromLabel.text ?? "Dec"]!, inComponent: 0, animated: true) //default pickerview position from core data or default
        toPickerView.selectRow(labelDic[toLabel.text ?? "Dec"]!, inComponent: 0, animated: true)
    }
    
    @IBAction func convertButtonTapped(_ sender: Any) {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        deleteCoreGroup() //everytime data will save it will first be cleared in core data
        
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
    
    @IBAction func refreshTapped(_ sender: Any) { //refreshing everything to default settings
        inputTextField.text = ""
        fromLabel.text = "Dec"
        toLabel.text = "Dec"
        resLabel.isHidden = true
        resultValueLabel.isHidden = true
        print("refresh tapped")
        fromPickerView.selectRow(labelDic["Dec"]!, inComponent: 0, animated: true) //default pickerview position from core data or default
        toPickerView.selectRow(labelDic["Dec"]!, inComponent: 0, animated: true)
            deleteCoreGroup()
        saveCore("")
    }
    
    func binToDec() { //Complete
        let bin = getBinary()
        guard bin != "error" else{ return}
        
        if let dec = Int(inputTextField.text ?? "", radix: 2) {
            let stringDec = "\(dec)"
            saveCore(stringDec)
            displayResult("Decimal:",stringDec)
        }
    }
    
    func decToBin() { //Transform decimal to binary with 8 digits //Complete
        
        let retrievedDec = getDecimal()
        guard retrievedDec != "error" else {
            return
        }
        let bin = Int(retrievedDec)
        var binary = String(bin!, radix: 2) //converting from string to binary
        
        binary = padBin(binary) //padding to the left with 0 until num of binary digits = 8
        
        saveCore(binary)
        displayResult("Binary:",binary)
    }
    
    func binToBin() {
        
        var bin = getBinary()
        
        guard bin != "error" else{
            return
        }
        
        bin = padBin(bin)
        
        saveCore(bin)
        displayResult("Binary:",bin)
    }
    
    func decToDec() {
        let dec = getDecimal()
        guard dec != "error" else {
            return
        }
        saveCore(dec)
        displayResult("Decimal:", dec)
    }
    
    func hexToHex() {
        let hex = getCheckHex()
        
        guard hex != "error" else{
            hexAlert(mChoices.hexMsg.rawValue)
            return
        }
        saveCore(hex.uppercased())
        displayResult("Hexadecimal: ", hex.uppercased())
    }
    
    func binToHex() {
        let bin = self.getBinary()
        guard bin != "error" else{
            
            return
        }
        
        let hex = String(Int(bin, radix: 2)!, radix: 16) //Convert Binary to Hex
        
        saveCore(hex.uppercased())
        displayResult("Hexadecimal:",hex.uppercased())
    }
    
    func decToHex() {
        let retrievedDec = getDecimal()
        guard retrievedDec != "error" else {
            return
        }
        let dec = Int(retrievedDec)
        let hex = String(dec!, radix: 16)
        saveCore(hex.uppercased())
        displayResult("Hexadecimal:",hex.uppercased())
    }
    
    func hexToBin() {
        let hex = getCheckHex()
        guard hex != "error" else{
            hexAlert(mChoices.hexMsg.rawValue)
            return
        }
        
        guard hex != "error2" else {
            hexAlert(mChoices.upper.rawValue)
            return
        }
        
        var bin = String(Int(hex, radix: 16)!, radix: 2)
        
        bin = padBin(bin)
        
        saveCore(bin)
        
        displayResult("Binary:",bin)
    }
    
    func hexToDec() {
        let hex = getCheckHex()
        guard hex != "error" else{
            hexAlert(mChoices.hexMsg.rawValue)
            return
        }
        guard hex != "error2" else {
            hexAlert(mChoices.upper.rawValue)
            return
        }
        let dec = Int(hex, radix: 16)!
        let stringDec = "\(dec)"
        saveCore(stringDec)
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
        
        if hex.count > 7 {
            return "error2"
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
            
            guard checkNum! < 1000000000 else { //making an upperlimit to users capability
                alertMethod(mChoices.sytanxMsg.rawValue, mChoices.upper.rawValue)
                return false
            }
            return true //it is a valid int/decimal
        }
        else {
            alertMethod(mChoices.sytanxMsg.rawValue, mChoices.decMsg.rawValue)
            
            return false
        }
    }
    
    func binaryCheck(_ binNum: String) -> Bool { //This method checks if input is in binary format
        
        if binNum == "" {
            alertMethod(mChoices.sytanxMsg.rawValue, mChoices.binMsg.rawValue)
            return false
        }
        
        for c in binNum { //checking if input is in binary syntax, if not 0/1 exit func
            
            if c != "0" && c != "1" {
                alertMethod(mChoices.sytanxMsg.rawValue, mChoices.binMsg.rawValue)
                return false //return false if syntax error
            }
        }
        return true
    }
    
    func alertMethod(_ alertTitle: String,_ alertMessage: String) { // Error alert
        inputTextField.shake()
        hapticError()
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true)
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func hexAlert(_ message: String) {
        inputTextField.shake()
        hapticError()
        alertMethod(mChoices.sytanxMsg.rawValue, message)
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    func displayResult(_ convertedType: String,_ convertedValue: String) {
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        resultValueLabel.isHidden = false
        resultValueLabel.text = convertedValue
        resLabel.text = convertedType
        resLabel.isHidden = false
    }
    
    func hapticError() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    func padBin(_ binary: String ) -> String { //adds 0s for padding
        
        var editBinary = binary
        while editBinary.count < 8 { //while num of elements in binary is not equal to 8...
            
            editBinary = "0\(editBinary)" //add a 0 to beginning of string
        }
        
        return editBinary
    }
    
    func retrieveCoreData() { //retrieving persisted data from Core Data
        
        
        let fetchRequest: NSFetchRequest = SavedEntry.fetchRequest() //pulling data from coreData
        
        do {
            fetchResult = try context.fetch(fetchRequest) //setting fetched result into array
        }
        catch{
            print("unable to fetch")
            //            debugprint(error)
            return
        }
        guard !fetchResult.isEmpty else {
            return
        }
        //print(fetchResult.count)
        
        inputTextField.text = fetchResult.last!.fieldText
        fromLabel.text = fetchResult.last!.inputPick
        toLabel.text = fetchResult.last!.outputPick
        resultValueLabel.text = fetchResult.last!.resultValue
        
        resLabel.text = "\(typeFullName[toLabel.text!] ?? ""): "
        
        if resultValueLabel.text != "" {
        resLabel.isHidden = false
        }
    }
    
    func deleteCoreGroup() { //deletes the saved data from core data
        for i in 0..<fetchResult.count {
            context.delete(fetchResult[i])
            // try? context.save()
            DatabaseController.saveContext()
            
            //print("emptying core")
        }
        fetchResult.removeAll()
    }
    func saveCore(_ result: String) { // saving data to core data will be added when convert buttton is pressed
        
        //deleteCoreGroup()
        let coreSave = SavedEntry(context: context)
        coreSave.fieldText = inputTextField.text
        coreSave.inputPick = fromLabel.text
        coreSave.outputPick = toLabel.text
        coreSave.resultValue = result
        dataCopy = coreSave
        
        DatabaseController.saveContext()
    }
}


//MARK: Extensions

extension BinDecHexController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputTextField.resignFirstResponder()
        return true
    }
}

extension UITextField {
    func shake() { //setting up shake animation for alert error
        let animation = CABasicAnimation(keyPath: "position")
        animation.repeatCount = 2
        animation.duration = 0.05
        animation.autoreverses = true
        animation.fromValue = CGPoint(x: self.center.x - 4.0, y: self.center.y)
        animation.toValue = CGPoint(x: self.center.x + 4.0, y: self.center.y)
        layer.add(animation, forKey: "position")
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

