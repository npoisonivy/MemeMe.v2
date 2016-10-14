//
//  bottomTextFieldDelegate.swift
//  ImagePickerExperiment
//
//  Created by Nikki L on 10/5/16.
//  Copyright © 2016 Nikki. All rights reserved.
//

import Foundation
import UIKit

class bottomTextFieldDelegate: NSObject, UITextFieldDelegate {
    
    // let user to add the text - return true - this goes before textFieldDidBeginEditing
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    // when user taps the textfield - behind the scene - textfield becomes first responder
    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }
    
    // when user did not end up typing any char after tapping @ textfield, revert placeholder's text
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        if (textField.text!.isEmpty) {
             textField.text = "Bottom"
        }
        return true
    }
    
    // when user hits return -> dismiss keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder() // resign as a first responder
        return true
    }
    
}
