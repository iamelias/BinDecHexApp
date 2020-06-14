//
//  ExtView.swift
//  BinDecHex
//
//  Created by Elias Hall on 6/13/20.
//  Copyright © 2020 Elias Hall. All rights reserved.
//

extension BinDecHexController { //holds preSet views
    
    func initialView() {
        inputTextField.text = ""
        fromLabel.text = "Dec" //Initializing labels
        toLabel.text = "Dec"
        resLabel.isHidden = true
        resultValueLabel.isHidden = true
        controlActivityIndicator(indicatorOn: false)
        setPickerViews()
    }
    
    func postCoreFetchView() { //View setup after fetching from core data
        inputTextField.text = coreFetched.last!.fieldText
        fromLabel.text = coreFetched.last!.inputPick
        toLabel.text = coreFetched.last!.outputPick
        resultValueLabel.text = coreFetched.last!.resultValue
        resultValueLabel.isHidden = false
        setPickerViews()
        
        resLabel.text = "\(typeFullName[toLabel.text!] ?? ""): "
        
        if resultValueLabel.text != "" {
            resLabel.isHidden = false
        }
    }
    
    func displayResultView(_ convertedType: String,_ convertedValue: String) { //view after convert button tapped
        controlActivityIndicator(indicatorOn: false)
        resultValueLabel.isHidden = false
        resultValueLabel.text = convertedValue
        resLabel.text = convertedType
        resLabel.isHidden = false
    }
    
    func setPickerViews() {
        fromPickerView.selectRow(labelDic[fromLabel.text ?? "Dec"]!, inComponent: 0, animated: true) //default pickerview position from core data or default
        toPickerView.selectRow(labelDic[toLabel.text ?? "Dec"]!, inComponent: 0, animated: true)
    }
}
