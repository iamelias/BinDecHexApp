//
//  Util.swift
//  BinDecHex
//
//  Created by Elias Hall on 2/19/22.
//  Copyright © 2022 Elias Hall. All rights reserved.
//

import Foundation
import UIKit

class Util {
    
    static func hapticError() {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.error)
    }

//static func callErrorAlert(alert: (title: String, message: String)) { //creating alert that includes error method calls
//    inputTextField.shake()
//    hapticError()
//    createAlert(details: alert)
//}

static func createAlert(details: (title: String, message: String)) -> UIAlertController { // Error alert
    let alert = UIAlertController(title: details.title, message: details.message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
    alert.addAction(ok)
    return alert
}

    static func decimalCheck(_ decNum: String) -> Bool {
        let checkNum = Int(decNum) //convert passed string to int, won't convert nonint
        if checkNum != nil { //if doesn't convert
            if checkNum! < 0 {
           //     callErrorAlert(alert: (mChoices.sytanxMsg.rawValue, mChoices.decMsg.rawValue))
                return false
            }
            guard checkNum! < 1000000000 else { //making an upperlimit to users capability
            //    callErrorAlert(alert: (mChoices.sytanxMsg.rawValue, mChoices.upper.rawValue))
                return false
            }
            return true //it is a valid int/decimal
        }
        else {
          //  callErrorAlert(alert: (mChoices.sytanxMsg.rawValue, mChoices.decMsg.rawValue))
            return false
        }
    }

    static func binaryCheck(_ binNum: String) -> Bool { //This method checks if input is in binary format
        if binNum == "" {
          //  callErrorAlert(alert: (mChoices.sytanxMsg.rawValue, mChoices.binMsg.rawValue))
            return false
        }

        for c in binNum { //checking if input is in binary syntax, if not 0/1 exit func
            if c != "0" && c != "1" {
               // callErrorAlert(alert: (mChoices.sytanxMsg.rawValue, mChoices.binMsg.rawValue))
                return false //return false if syntax error
            }
        }
        return true
    }
}

