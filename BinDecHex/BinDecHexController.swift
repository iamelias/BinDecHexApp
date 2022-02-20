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
    @IBOutlet weak var keyboardView: UIView!
    @IBOutlet weak var resLabel: UILabel!

    let context = DatabaseController.persistentStoreContainer().viewContext
    var calculator = Calculator(fieldText: "", inputPick: "Dec", outputPick: "Dec", resultPresent: false, resultValue: "")
    var acalculatorVM: CalculatorViewModel?
    
    var coreFetched: [SavedEntry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDelegatesDataSources()
        initialView()
        retrieveCoreData() //getting persisted data
        acalculatorVM = CalculatorViewModel(calculator: calculator)
        outletConfig()
        //       deleteCoreGroup() //**for testing**
        keyboardConfig()
    }
     
    @IBAction func convertButtonTapped(_ sender: Any) {
        deleteCoreGroup() //clearing what is currently saved

        let checkBool: Bool = true
        switch checkBool {
        case fromLabel.text == "Bin" && toLabel.text == "Dec": binToDec()
            print("Bin-Dec")
        case fromLabel.text == "Bin" && toLabel.text == "Hex": binToHex()
            print("Bin-Hex")
        case fromLabel.text == "Bin" && toLabel.text == "Bin": binToBin()
            print("Bin-Bin")
        case fromLabel.text == "Dec" && toLabel.text == "Bin": decToBin()
            print("Dec-Bin")
        case fromLabel.text == "Dec" && toLabel.text == "Hex": decToHex()
            print("Dec-Hex")
        case fromLabel.text == "Dec" && toLabel.text == "Dec": decToDec()
            print("Dec-Dec")
        case fromLabel.text == "Hex" && toLabel.text == "Bin": hexToBin()
            print("Hex-Bin")
        case fromLabel.text == "Hex" && toLabel.text == "Dec": hexToDec()
            print("Hex-Dec")
        case fromLabel.text == "Hex" && toLabel.text == "Hex": hexToHex()
            print("Hex-Hex")
        default: print("Error") //will never execute decault
        }
    }
    
    //MARK: IBACTIONS
    @IBAction func refreshTapped(_ sender: Any) { //refreshing everything to default settings
        initialView()
        deleteCoreGroup()
        saveCore("")
    }
    
    @IBAction func buttonDidTouch(_ sender: UIButton) {
        switch sender.tag {
        case 0: inputTextField.text!.append("0")
        case 1: inputTextField.text!.append("1")
        case 2: inputTextField.text!.append("2")
        case 3: inputTextField.text!.append("3")
        case 4: inputTextField.text!.append("4")
        case 5: inputTextField.text!.append("5")
        case 6: inputTextField.text!.append("6")
        case 7: inputTextField.text!.append("7")
        case 8: inputTextField.text!.append("8")
        case 9: inputTextField.text!.append("9")
        case 10: inputTextField.text!.append("A")
        case 11: inputTextField.text!.append("B")
        case 12: inputTextField.text!.append("C")
        case 13: inputTextField.text!.append("D")
        case 14: inputTextField.text!.append("E")
        case 15: inputTextField.text!.append("F")
        case 16:inputTextField.text!.append(".")
        case 17: _ = inputTextField.text!.popLast()
        default:
            print("Error")
        }
    }
    
    func outletConfig() {
        guard let acalculatorVM = acalculatorVM else {
            return
        }
        inputTextField.text = acalculatorVM.textField
        fromLabel.text = acalculatorVM.inputPick
        toLabel.text = acalculatorVM.outputPick
        fromPickerView.selectedRow(inComponent: labelDic[acalculatorVM.inputPick] ?? 1)
        toPickerView.selectedRow(inComponent: labelDic[acalculatorVM.outputPick] ?? 1)
        resLabel.isHidden = acalculatorVM.resultPresent
        resultValueLabel.text = acalculatorVM.resultValue
    }
    
    func setDelegatesDataSources() {
        inputTextField.delegate = self
        fromPickerView.delegate = self
        toPickerView.delegate = self
        fromPickerView.dataSource = self
        toPickerView.dataSource = self
    }
    
    func keyboardConfig() {
        keyboardView.layer.cornerRadius = 8.0
        keyboardView.layer.borderWidth = 0.5
        keyboardView.layer.borderColor = UIColor.systemGray4.cgColor
        keyboardView.clipsToBounds = true
        keyboardView.layer.masksToBounds = true
    }
    
    func padBin(_ binary: String ) -> String { //adds 0s for padding
        var editBinary = binary
        while editBinary.count < 8 { //while num of elements in binary is not equal to 8...
            
            editBinary = "0\(editBinary)" //add a 0 to beginning of string
        }
        return editBinary
    }
    
    func hapticError() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    //MARK: CONVERSION METHODS
    func binToDec() { //Complete
        let bin = getBinary()
        guard bin != "error" else{ return}
        
        if let dec = Int(inputTextField.text ?? "", radix: 2) {
            let stringDec = "\(dec)"
            saveCore(stringDec)
            print("Decimal: \(stringDec)")
            displayResultView("Decimal:",stringDec)
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
        print("Binary: \(binary)")
        displayResultView("Binary:",binary)
    }
    
    func binToBin() {
        var bin = getBinary()
        
        guard bin != "error" else{
            return
        }
        
        bin = padBin(bin)
        
        saveCore(bin)
        print("Binary: \(bin)")
        displayResultView("Binary:",bin)
    }
    
    func decToDec() {
        let dec = getDecimal()
        guard dec != "error" else {
            return
        }
        saveCore(dec)
        print("Decimal: \(dec)")
        displayResultView("Decimal:", dec)
    }
    
    func hexToHex() {
        let hex = getCheckHex()
        
        guard hex != "error" else{
            callErrorAlert(alert: (mChoices.sytanxMsg.rawValue, mChoices.hexMsg.rawValue))
            return
        }
        guard hex != "error2" else {
            callErrorAlert(alert: (mChoices.sytanxMsg.rawValue, mChoices.upper.rawValue))
            return
        }
        saveCore(hex.uppercased())
        print("Hex: \(hex.uppercased())")
        displayResultView("Hexadecimal: ", hex.uppercased())
    }
    
    func binToHex() {
        let bin = self.getBinary()
        guard bin != "error" else{
            return
        }
        let hex = String(Int(bin, radix: 2)!, radix: 16) //Convert Binary to Hex
        saveCore(hex.uppercased())
        print("Hex: \(hex.uppercased())")
        displayResultView("Hexadecimal:",hex.uppercased())
    }
    
    func decToHex() {
        let retrievedDec = getDecimal()
        guard retrievedDec != "error" else {
            return
        }
        let dec = Int(retrievedDec)
        let hex = String(dec!, radix: 16)
        saveCore(hex.uppercased())
        print("Hex: \(hex.uppercased())")
        displayResultView("Hexadecimal:",hex.uppercased())
    }
    
    func hexToBin() {
        let hex = getCheckHex()
        guard hex != "error" else{
            callErrorAlert(alert: (mChoices.sytanxMsg.rawValue, mChoices.hexMsg.rawValue))
            return
        }
        guard hex != "error2" else {
            callErrorAlert(alert: (mChoices.sytanxMsg.rawValue, mChoices.upper.rawValue))
            return
        }
        var bin = String(Int(hex, radix: 16)!, radix: 2)
        bin = padBin(bin)
        saveCore(bin)
        print("Binary: \(bin)")
        displayResultView("Binary:",bin)
    }
    
    func hexToDec() {
        let hex = getCheckHex()
        guard hex != "error" else{
            callErrorAlert(alert: (mChoices.sytanxMsg.rawValue, mChoices.hexMsg.rawValue))
            return
        }
        guard hex != "error2" else {
            callErrorAlert(alert: (mChoices.sytanxMsg.rawValue, mChoices.upper.rawValue))
            return
        }
        let dec = Int(hex, radix: 16)!
        let stringDec = "\(dec)"
        saveCore(stringDec)
        print("Decimal: \(dec)")
        displayResultView("Decimal:",stringDec)
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
    //MARK: FORMAT CHECK METHODS
    func decimalCheck(_ decNum: String) -> Bool {

        let checkNum = Int(decNum) //convert passed string to int, won't convert nonint
        if checkNum != nil { //if doesn't convert
            
            if checkNum! < 0 {
                callErrorAlert(alert: (mChoices.sytanxMsg.rawValue, mChoices.decMsg.rawValue))
                return false
            }

            guard checkNum! < 1000000000 else { //making an upperlimit to users capability
                callErrorAlert(alert: (mChoices.sytanxMsg.rawValue, mChoices.upper.rawValue))
                return false
            }
            return true //it is a valid int/decimal
        }
        else {
            callErrorAlert(alert: (mChoices.sytanxMsg.rawValue, mChoices.decMsg.rawValue))
            return false
        }
    }
    
    func binaryCheck(_ binNum: String) -> Bool { //This method checks if input is in binary format
        if binNum == "" {
            callErrorAlert(alert: (mChoices.sytanxMsg.rawValue, mChoices.binMsg.rawValue))
            return false
        }
        
        for c in binNum { //checking if input is in binary syntax, if not 0/1 exit func
            if c != "0" && c != "1" {
                callErrorAlert(alert: (mChoices.sytanxMsg.rawValue, mChoices.binMsg.rawValue))
                return false //return false if syntax error
            }
        }
        return true
    }
    
    //MARK: ALERT METHODS
    func callErrorAlert(alert: (title: String, message: String)) { //creating alert that includes error method calls
        inputTextField.shake()
        hapticError()
        createAlert(details: alert)
    }
    
    func createAlert(details: (title: String, message: String)) { // Error alert
        let alert = UIAlertController(title: details.title, message: details.message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    //MARK: CORE DATA METHODS
    func retrieveCoreData() { //retrieving persisted data from Core Data
        let fetchRequest: NSFetchRequest = SavedEntry.fetchRequest() //pulling data from coreData
        do {
            coreFetched = try context.fetch(fetchRequest) //setting fetched result into array
            guard coreFetched.count == 1 else {
                return
            }
            calculator = Calculator(fieldText: coreFetched[0].fieldText ?? "", inputPick: coreFetched[0].inputPick ?? "Dec", outputPick: coreFetched[0].outputPick ?? "Dec", resultPresent: coreFetched[0].resultPresent, resultValue: coreFetched[0].resultValue ?? "")
        }
        catch{
            print("unable to fetch")
            //            debugprint(error)
            return
        }
        guard !coreFetched.isEmpty else {
            return 
        }
        postCoreFetchView()
    }
    
    func deleteCoreGroup() { //deletes the saved data from core data
        for i in 0..<coreFetched.count {
            context.delete(coreFetched[i])
            DatabaseController.saveContext()
        }
        coreFetched.removeAll()
    }
    func saveCore(_ result: String) { // saving data to core data will be added when convert buttton is pressed
        let coreSave = SavedEntry(context: context)
        coreSave.fieldText = inputTextField.text
        coreSave.inputPick = fromLabel.text
        coreSave.outputPick = toLabel.text
        coreSave.resultValue = result
        
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

//MARK: PICKER VIEW METHODS
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

