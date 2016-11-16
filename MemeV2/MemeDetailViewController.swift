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
    var memedImage_toshow: UIImage! // this to save the memedImage being passed
    
    // set outlet, set outlet's display as memedImage_show
    @IBOutlet weak var imageDisplay: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        
        // show memedImage_toshow below!
        imageDisplay.image = memedImage_toshow
        
    }
    
}













