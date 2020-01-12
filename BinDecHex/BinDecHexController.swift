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
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var decValueLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromPickerView: UIPickerView!
    @IBOutlet weak var toPickerView: UIPickerView!
    @IBOutlet weak var decLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var UnitChoices: [String] = ["Bin", "Dec", "Hex"]
    var labelDic: [String: Int] = ["Bin": 0, "Dec": 1, "Hex": 2]
    var typeFullName: [String: String] = ["Bin": "Binary", "Dec": "Decimal", "Hex": "Hexadecimal"]
    var syntaxCheck: Bool = false
    var dataController: DataController?
    var saveEntryName: [SavedEntry] = []
    var coreDataRetrieved: Bool = false
    var fetchResult: [SavedEntry] = []
    var fetchResult2: [SavedEntry] = []
    let context = DatabaseController.persistentStoreContainer().viewContext

    
    enum mChoices: String {
        case hexMsg = "Can't convert because input is not in hexadecimal format"
        case binMsg = "Can't convert because input is not in binary format"
        case decMsg = "Can't convert because input is not in decimal format"
        case upper = "Input is past upper limit"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        inputTextField.delegate = self
        fromPickerView.delegate = self
        toPickerView.delegate = self
        fromPickerView.dataSource = self
        toPickerView.dataSource = self
       // let i = "Dec" //dictionary indicator
        fromLabel.text = "Dec" //Initializing labels
        toLabel.text = "Dec"
        retrieveCoreData()
        activityIndicator.isHidden = true
       
        
        fromPickerView.selectRow(labelDic[fromLabel.text ?? "Dec"]!, inComponent: 0, animated: true) //default pickerview position
        toPickerView.selectRow(labelDic[toLabel.text ?? "Dec"]!, inComponent: 0, animated: true)
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
        //DispatchQueue.main.async {
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
                let alertTitle = "Syntax Error"
                //let alertMessage = "input is too large"
                alertMethod(alertTitle, mChoices.upper.rawValue)
                return false
            }
        return true //it is a valid int/decimal
    }
        else {
            let alertTitle = "Sytnax Error"
          //  let alertMessage = "Can't convert because input is not in decimal format"
            alertMethod(alertTitle, mChoices.decMsg.rawValue)
            
            return false
        }
    }
    
    func binaryCheck(_ binNum: String) -> Bool { //This method checks if input is in binary format
        
        if binNum == "" {
            let alertTitle = "Syntax Error"
           // let alertMessage = "Can't convert because input is not in binary format"
            alertMethod(alertTitle, mChoices.binMsg.rawValue)
            return false
        }
        
        for c in binNum { //checking if input is in binary syntax, if not 0/1 exit func
            
            if c != "0" && c != "1" {
                let alertTitle = "Syntax Error"
               // let alertMessage = "Can't convert because input is not in binary format"
                alertMethod(alertTitle, mChoices.binMsg.rawValue)
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
        let alertTitle = "Sytnax Error"
        alertMethod(alertTitle, message)
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
//            print(error) //if there is an error pulling data
            print("unable to fetch")
//            debugprint(error)
            return
        }
        guard !fetchResult.isEmpty else {
            return
        }
        print(fetchResult[0].fieldText)
        print(fetchResult[0].inputPick)
        print(fetchResult[0].outputPick)
        print(fetchResult[0].resultValue)
        
        inputTextField.text = fetchResult[0].fieldText
        fromLabel.text = fetchResult[0].inputPick
        toLabel.text = fetchResult[0].outputPick
        decValueLabel.text = fetchResult[0].resultValue
        
        decLabel.text = "\(typeFullName[toLabel.text!] ?? ""): "
        decLabel.isHidden = false

        }
    
    func deleteCoreGroup() { //deletes the saved data from core data
        for i in 0..<fetchResult.count {
            context.delete(fetchResult[i])
            try? context.save()
        }
        fetchResult.removeAll()
    }
    
    func saveCore(_ result: String) { // saving data to core data will be added when convert buttton is pressed
        fetchResult2 = fetchResult //saving data that will be added to core data
        deleteCoreGroup() //everytime data will save it will first be cleared in core data
        fetchResult = fetchResult2
        let coreSave = SavedEntry(context: context)
        coreSave.fieldText = inputTextField.text
        coreSave.inputPick = fromLabel.text
        coreSave.outputPick = toLabel.text
        coreSave.resultValue = result

        DatabaseController.saveContext()
//        try? dataController!.viewContext.save() //saving groupname object and it's attributes
//        saveEntryName.append(coreSave)
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

    



       
        
        
//        let result = SavedEntry(context: DatabaseController.persistentStoreContainer().viewContext)
//        saveEntryName[0] = result
//        inputTextField.text = result.fieldText
//        fromLabel.text = result.inputPick
//        toLabel.text = result.outputPick
//        decValueLabel.text = result.resultValue
//        coreDataRetrieved = true
        
        
//        let fetchRequest: NSFetchRequest<SavedEntry> = SavedEntry.fetchRequest()
        
//        if let result = try? dataController?.viewContext.fetch(fetchRequest) {
//            saveEntryName = result
//            let core = saveEntryName[0]
//            inputTextField.text = core.fieldText
//            fromLabel.text = core.inputPick
//            toLabel.text = core.outputPick
//            decValueLabel.text = core.resultValue
//            coreDataRetrieved = true //indicating that core data is present
//                return
//        }
//            else {
//                      debugPrint("unable to fetch")
//                      return
//                  }
