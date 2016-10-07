//
//  ViewController.swift
//  ImagePickerExperiment
//
//  Created by Nikki L on 10/4/16.
//  Copyright © 2016 Nikki. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    // initialize & declare Delegate files
    let topDelegate = topTextFieldDelegate()
    let bottomDelegate = bottomTextFieldDelegate()
    
    // code for setting how text/ color/ font should be...
    // set character attributes for textField's font, outline and color
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSStrokeWidthAttributeName: 5.0,
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set texField's initial text
        topTextField.text = "TOP"
        bottomTextField.text = "Bottom"
        
        // When viewDidLoad, set each textfield's defaultTextAttribute as memeTextAttributes
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        // set text alignment - center-aligned - must be after .defaultAttributes, otherwise, it reset the textAlignment!
        topTextField.textAlignment = .Center
        bottomTextField.textAlignment = .Center
        
        // set each textfield's delegate with variable set earlier
        self.topTextField.delegate = topDelegate
        self.bottomTextField.delegate = bottomDelegate
        
    }
    
    // when user launch the app, before view appears, will do this
    override func viewWillAppear(animated: Bool) {
        print("view will appear")
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        print("camera button is \(cameraButton.enabled)") // return false if device does not support camera
    }
    
    // code related to launch imagePicker + set sourceType
    // The action method connected to the album button
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        let pickerController = UIImagePickerController() // sourcetype of camera, photoLibrary/ savedPhotosAlbum
        
        // need to implement delegate pattern - set our current view controller as a delegate of imagepickercontroller, so curretn VC will do what a UIImagePicketController would
        pickerController.delegate = self    // without this, current VC will not show chosen pic
        pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    // code related to launch imagePicker + set sourceType
    // The action method for the camera button
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
        // is it here to place imagePickerControllerDidCancel ?? - to listen to this func, and do below?
        // dismissViewControllerAnimated(<#T##flag: Bool##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
    }
    
    // hard ware level, retrieve data (UIImage) to replace the placeholder - to showw user's chosen img
    // When user picked a photo (either from Camera / photoAlbum) on the app, it will call its delegate's imagePickerController , so I want to set a listener to do below when it comes! To do - this photo will present @ outlet imagePickerView
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            // inf[key] -> return value (value retrived from iOS device)
        }
        dismissViewControllerAnimated(true, completion: nil) // dismiss pickerController VC from pickerController OR imagePicker
    }
}

