//
//  testing.swift
//  MemeV2
//
//  Created by Nikki L on 11/20/16.
//  Copyright © 2016 Nikki. All rights reserved.
//

import Foundation
import UIKit

class testing: UIViewController, UITextFieldDelegate {
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated) // do i need this??
        
        // for shifting view - when keyboard is hidden
        unsubscribeToKeyboardNotification(notification: UIKeyboardWillShowNotification)
//        unsubscribeToKeyboardNotification2()
    }

    func unsubscribeToKeyboardNotification(notification: NSNotification) {
        let notification = notification
        NSNotificationCenter.defaultCenter().removeObserver(self, name: NSNotification, object: nil)
    }
    


}



