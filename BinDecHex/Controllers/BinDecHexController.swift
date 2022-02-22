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
    //MARK: IBOUTLETS
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var resultValueLabel: UILabel!
    @IBOutlet weak var fromLabel: UILabel!
    @IBOutlet weak var toLabel: UILabel!
    @IBOutlet weak var fromPickerView: UIPickerView!
    @IBOutlet weak var toPickerView: UIPickerView!
    @IBOutlet weak var keyboardView: UIView!
    @IBOutlet weak var resLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    var calculator = Calculator(fieldText: "", inputPick: "Dec", outputPick: "Dec", resultHidden: true, resultValue: "")
    var calculatorVM: CalculatorViewModel?
    var coreFetched: [CoreCalculator] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveCoreData() //getting persisted data
        calculatorVM = CalculatorViewModel(calculator: calculator)
        setDelegatesDataSources()
        outletViewConfig()
        inputTextField.layer.cornerRadius = 8.0
        //       deleteCoreGroup() //**for testing**
        keyboardConfig()
    }
    
    @IBAction func convertButtonDidTouch(_ sender: Any) {
        calculatorVM?.getFormat()
    }
    
    //MARK: IBACTIONS
    @IBAction func refreshButtonDidTouch(_ sender: Any) { //refreshing everything to default settings
        calculatorVM?.refresh()
        inputTextField.text = calculatorVM?.textField
        fromLabel.text = calculatorVM?.inputPick
        toLabel.text = calculatorVM?.outputPick
        resLabel.text = calculatorVM?.resultLabel
        resLabel.isHidden = calculatorVM?.resultHidden ?? true
        resultValueLabel.text = calculatorVM?.resultValue
        fromPickerView.selectRow(unitIndexDict[fromLabel.text ?? "Dec"]!, inComponent: 0, animated: true)
        toPickerView.selectRow(unitIndexDict[toLabel.text ?? "Dec"]!, inComponent: 0, animated: true)
        deleteCoreGroup()
        saveCore()
    }
    
    @IBAction func buttonDidTouch(_ sender: UIButton) {
        switch sender.tag {
        case 0: calculatorVM?.appendText(text: "0")
        case 1: calculatorVM?.appendText(text: "1")
        case 2: calculatorVM?.appendText(text: "2")
        case 3: calculatorVM?.appendText(text: "3")
        case 4: calculatorVM?.appendText(text: "4")
        case 5: calculatorVM?.appendText(text: "5")
        case 6: calculatorVM?.appendText(text: "6")
        case 7: calculatorVM?.appendText(text: "7")
        case 8: calculatorVM?.appendText(text: "8")
        case 9: calculatorVM?.appendText(text: "9")
        case 10: calculatorVM?.appendText(text: "A")
        case 11: calculatorVM?.appendText(text: "B")
        case 12: calculatorVM?.appendText(text: "C")
        case 13: calculatorVM?.appendText(text: "D")
        case 14: calculatorVM?.appendText(text: "E")
        case 15: calculatorVM?.appendText(text: "F")
        case 16: calculatorVM?.clearText()
        case 17: calculatorVM?.popText()
        default: break
        }
    }
    
    func outletViewConfig() {
        guard let calculatorVM = calculatorVM else {
            return
        }
        inputTextField.text = calculatorVM.textField
        fromLabel.text = calculatorVM.inputPick
        toLabel.text = calculatorVM.outputPick
        fromPickerView.selectRow(unitIndexDict[calculatorVM.inputPick] ?? 1, inComponent: 0, animated: true) //default
        toPickerView.selectRow(unitIndexDict[calculatorVM.outputPick] ?? 1, inComponent: 0, animated: true)
        resultValueLabel.text = calculatorVM.resultValue
        resLabel.text = calculatorVM.resultLabel
        resLabel.isHidden = calculatorVM.resultHidden
    }
    
    func setDelegatesDataSources() {
        inputTextField.delegate = self
        fromPickerView.delegate = self
        toPickerView.delegate = self
        fromPickerView.dataSource = self
        toPickerView.dataSource = self
        calculatorVM?.delegate = self
    }
    
    func keyboardConfig() {
        keyboardView.layer.cornerRadius = 8.0
       // keyboardView.layer.borderWidth = 0.5
       // keyboardView.layer.borderColor = UIColor.systemGray4.cgColor
        keyboardView.clipsToBounds = true
        keyboardView.layer.masksToBounds = true
    }
    
    func hapticError() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }
    
    //MARK: CONVERSION METHODS
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
    //MARK: ALERT METHODS
    func callErrorAlert(alert: InputError) { //creating alert that includes error method calls
        inputTextField.shake()
        hapticError()
        createAlert(details: alert)
    }
    
    func createAlert(details: InputError) { // Error alert
        let alert = UIAlertController(title: details.title, message: details.message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    //MARK: CORE DATA METHODS
    func retrieveCoreData() { //retrieving persisted data from Core Data
        guard let context = context else {
            return
        }
        do {
            coreFetched = try context.fetch(CoreCalculator.fetchRequest())
            guard coreFetched.count > 0 else {
                return
            }
            for i in coreFetched {
                print(i.resultValue)
            }
            print(coreFetched.count)
            if let lastElement = coreFetched.last {
                calculator = Calculator(fieldText: lastElement.fieldText ?? "", inputPick: lastElement.inputPick ?? "Dec", outputPick: lastElement.outputPick ?? "Dec", resultHidden: lastElement.resultHidden, resultValue: lastElement.resultValue ?? "")
            }
        }
        catch {
            print("unable to fetch")
            print(error.localizedDescription)
            //            debugprint(error)
            return
        }
    }
    
    func deleteCoreGroup() { //deletes the saved data from core data
        guard let context = context else {
            return
        }
        for element in coreFetched {
            context.delete(element)
        }
        do {
            try context.save()
        }
        catch {
            print("Core Delete Error")
            print(error.localizedDescription)
        }
    }
    func saveCore() { // saving data to core data will be added when convert buttton is pressed
        guard let context = context else {
            print("Save Error")
            return
        }
        let coreSave = CoreCalculator(context: context)
        coreSave.fieldText = calculatorVM?.textField
        coreSave.inputPick = calculatorVM?.inputPick
        coreSave.outputPick = calculatorVM?.outputPick
        coreSave.resultValue = calculatorVM?.resultValue
        coreSave.resultHidden = calculatorVM?.resultHidden ?? true
        coreSave.resultLabel = calculatorVM?.resultLabel
        do {
            print("try save called")
            try context.save()
        } catch {
            print("Core add error")
            print(error.localizedDescription)
        }
    }
}

//MARK: EXTENSIONS
//MARK: TEXTFIELD DELEGATE METHODS
extension BinDecHexController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        inputTextField.resignFirstResponder()
        return true
    }
}

//MARK: VIEW EXTENSIONS
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

//MARK: PICKER DELEGATE METHODS
extension BinDecHexController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return unitChoices[row] //format of each cell in pickerview
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            fromLabel.text = unitChoices[row]
            calculatorVM?.setInputPick(input: unitChoices[row])
        }
        else if pickerView.tag == 2 {
            toLabel.text = unitChoices[row]
            calculatorVM?.setOutputPick(input: unitChoices[row])
        }
    }
}

//MARK: VIEW MODEL DELEGATE METHODS
extension BinDecHexController: CalculatorViewModelDelegate {
    func didUpdateTextField(textField: String) {
        inputTextField.text = textField
    }
    
    func didGetError(errorType: InputError) {
        inputTextField.shake()
        hapticError()
        createAlert(details: errorType)
    }
    
    func didConvert() {
        guard let calculatorVM = calculatorVM else {
            return
        }
        resLabel.isHidden = calculatorVM.resultHidden
        resultValueLabel.isHidden = calculatorVM.resultHidden
        resLabel.text = calculatorVM.resultLabel
        resultValueLabel.text = calculatorVM.resultValue //performs conversion
        deleteCoreGroup()
        saveCore()
    }
}
