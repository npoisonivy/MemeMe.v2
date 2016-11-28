//
//  MemeEditorViewController.swift
//  MemeMeV1
//
//  Created by Nikki L on 10/4/16.
//  Copyright © 2016 Nikki. All rights reserved.
//

import UIKit


class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    // Add shareButton outlet and action that generates memeDImage, present Activity View..
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    

    // initialize & declare Delegate files
    let bothTextFieldDelegate = memeTextFieldDelegate()
    
    // code for setting how text/ color/ font should be...
    // set character attributes for textField's font, outline and color
    let memeTextAttributes = [
        NSStrokeColorAttributeName: UIColor.blackColor(),
        NSStrokeWidthAttributeName: -5.0,
        NSForegroundColorAttributeName: UIColor.whiteColor(),
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set texField's initial text
        topTextField.text = "TOP"
        bottomTextField.text = "Bottom"
        
        styleTextField(topTextField)
        styleTextField(bottomTextField)
        
        // To bring 2 textfields back on top of UIImageView. Because I place textfield to MSB first then UIImageView after, so the imageView block the textfield
        self.view.addSubview(imagePickerView)
        self.view.sendSubviewToBack(imagePickerView)
        
        // disable Share button @ start, enable it @ func imagePickerController, when image is picked - H/W's didFinishPickingMediaWithInfo can detect that...
        shareButton.enabled = false
        
    }
    
    @IBAction func cancelMemeEditor(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // this styling func will apply to both top & bottom textField
    func styleTextField(textField: UITextField) {
        
        textField.delegate = bothTextFieldDelegate // set delegate of textfield
        
        textField.backgroundColor = UIColor.clearColor()           // set background color of textfields
        textField.defaultTextAttributes = memeTextAttributes       // When viewDidLoad, set each textfield's defaultTextAttribute as memeTextAttributes
        textField.textAlignment = .Center                       //  set text alignment - center-aligned - must be after .defaultAttributes, otherwise, it reset the textAlignment!
        textField.borderStyle = .None
    }
    
    
    
    // when user launch the app, before view appears, will do this
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("view will appear")
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        print("camera button is \(cameraButton.enabled)") // return false if device does not support camera
        
        // for shifting views - when keyboard shows
        subscribeToKeyboardNotification()
        subscribeToKeyboardNotification2()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated) // do i need this??
        
        // for shifting view - when keyboard is hidden
        unsubscribeToKeyboardNotification()
        unsubscribeToKeyboardNotification2()
    }
    
    func configureImagePickerController(sourceType: UIImagePickerControllerSourceType) {
        let pickerController = UIImagePickerController() // sourcetype of camera, photoLibrary/ savedPhotosAlbum
        // need to implement delegate pattern - set our current view controller as a delegate of imagepickercontroller, so curretn VC will do what a UIImagePicketController would
        pickerController.delegate = self    // without this, current VC will not show chosen pic
      
        pickerController.sourceType = sourceType
        print("Source type is chosen.. \(pickerController.sourceType)")
        self.presentViewController(pickerController, animated: true, completion: nil)
    }
    
    // code related to launch imagePicker + set sourceType
    // The action method connected to the album button
    @IBAction func pickAnImageFromAlbum(sender: AnyObject) {
        let sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        configureImagePickerController(sourceType)
    }
    
    // code related to launch imagePicker + set sourceType
    // The action method for the camera button
    @IBAction func pickAnImageFromCamera(sender: AnyObject) {
        let sourceType = UIImagePickerControllerSourceType.Camera
        configureImagePickerController(sourceType)
    }
    
    // hard ware level, retrieve data (UIImage) to replace the placeholder - to showw user's chosen img
    // When user picked a photo (either from Camera / photoAlbum) on the app, it will call its delegate's imagePickerController , so I want to set a listener to do below when it comes! To do - this photo will present @ outlet imagePickerView
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
            // inf[key] -> return value (value retrived from iOS device)
        }
        dismissViewControllerAnimated(true, completion: nil) // dismiss pickerController VC from pickerController OR imagePicker
        
        shareButton.enabled = true // change to true when H/W detects didFinishPickingMediaWithInfo is done!
        
        if imagePickerView == nil {
            print("there is no image picked yet")
        } else {
            print("User choice a pic!")
        }
        
        print(imagePickerView.contentMode)  // UIViewContentMode
        
    }

    // this part is to shift view when KB is shown/ hidden
    // 1. subscribe to NS notification, trigger 2's func
    // 2. to set self.view.frame.origin.y's poisition -= getKeyboardHeight
    // 3. func getKeyboardHeight -> get it from UserInfo [key] from Notification
    // 4. unsubscribe
    func subscribeToKeyboardNotification() {
      //  NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillshow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillshow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    }
    
    
    // add if isFirstResponder == bottomTextField - ensure that this change only happens when user tapps bottom textfield
    func keyboardWillshow(notification: NSNotification){
        if bottomTextField.isFirstResponder() {
            self.view.frame.origin.y = -getKeyboardHeight(notification)   // since ios8 returns diff value
        }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.CGRectValue().height
    }
    
    func unsubscribeToKeyboardNotification() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
    }
    
    // shift view back when keyboard is hidden
    
    func subscribeToKeyboardNotification2() {
        // NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func unsubscribeToKeyboardNotification2() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func save() {  // call this when user hit album/ photolibrary button
        // initialize meme object here - // how to grab the text from topText & bottomText?? Guess: from here? topTextField.text = "TOP", bottomTextField.text = "Bottom"
        // required memedImage, so pass it over to save(memedImage: UIImage) OR
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imagePickerView.image, memedImage: generateMemedImage())
        
        print(meme.bottomText)
        print("save() is called")
        
        
        // @ App Delegate - var memes = [Meme]() , add this newly saved meme (= new Struct Meme) to this Array
        // Delegate.memes.append(meme) - call Delegate's array name, append ocb to it
        (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        
    }
    
    // Combining image and text - to return the image "memedImage" that ombines the image view + the textfields
    func generateMemedImage() -> UIImage {
        
        // hide toolbar and navbar
        topToolBar.hidden = true
        bottomToolBar.hidden = true
        
        
        // Render view to an image - with no toolbar/ navbar
        UIGraphicsBeginImageContext(self.view.frame.size)   // set area/ context to be edited...
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)   // allow update after user add text on image
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()   // UIImage retrieved from Current ImageContext, saved to memedImage
        UIGraphicsEndImageContext()  // editing is completed
        print("memedImage is just generated!")
        
        // before retuning memedImage, show toolbar/ navbar again -> so memedImg ends up having only 1 navbar + toolbar
        topToolBar.hidden = false
        bottomToolBar.hidden = false
//
        return memedImage
    }
    
    // Add share button action here to generate memedImage, Activity VC View, pass this UIImage "memedImage" to Activity VC
    @IBAction func shareBtnPressed(sender: AnyObject) {
        // generate memedImage as a UIImage
        let newMemedImage = generateMemedImage()
        // Pass that memedImage as an Array [] to Activity View Controller, set Activity VC instance
        // this will set newMemedImage as - the object to SHARE
        let nextController = UIActivityViewController(activityItems: [newMemedImage], applicationActivities: nil)
        // present Activity VC
        self.presentViewController(nextController, animated: true, completion: nil)
        
        // listener for notifying once sharing meme is completed... - apple doc - var completionWithItemsHandler: UIActivityViewControllerCompletionWithItemsHandler? { get set }
        nextController.completionWithItemsHandler = {
            
            (activity, success, items, error) in
            
            if success {
                print("new memedImg got saved! ")
                self.save()       // when user successfully share the memedImage - save it also!
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
}

