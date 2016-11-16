//
//  MemeDetailViewController.swift
//  MemeV2
//
//  Created by Nikki L on 11/11/16.
//  Copyright © 2016 Nikki. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController {
    var memedImage_toshow: UIImage! // memedImage will be passed
    
    override func viewWillAppear(animated: Bool) {
        print(memedImage_toshow) // image <UIImage: 0x7f8e40569f00> size {375, 667} orientation 0 scale 1.000000
    }
    
}













