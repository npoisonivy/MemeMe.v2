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
    
    // Add shareButton outlet and action that generates memeDImage, present Activity View..
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    
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
        
        // To bring 2 textfields back on top of UIImageView. Because I place textfield to MSB first then UIImageView after, so the imageView block the textfield
        self.view.addSubview(imagePickerView)
        self.view.sendSubviewToBack(imagePickerView)
        
        // disable Share button @ start, enable it @ func imagePickerController, when image is picked - H/W's didFinishPickingMediaWithInfo can detect that...
        shareButton.enabled = false
        
    }
    
    // when user launch the app, before view appears, will do this
    override func viewWillAppear(animated: Bool) {
        print("view will appear")
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        print("camera button is \(cameraButton.enabled)") // return false if device does not support camera
        
        super.viewWillAppear(animated) // do i tneed this still??
        
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
        
    }

    // this part is to shift view when KB is shown/ hidden
    // 1. subscribe to NS notification, trigger 2's func
    // 2. to set self.view.frame.origin.y's poisition -= getKeyboardHeight
    // 3. func getKeyboardHeight -> get it from UserInfo [key] from Notification
    // 4. unsubscribe
    func subscribeToKeyboardNotification() {
      //  NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillshow:", name: UIKeyboardWillShowNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillshow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    }
    
    // add if statment - prevent view got shifted up TWICE when user tapped top then bottom textfield continously!
    func keyboardWillshow(notification: NSNotification){
        if self.view.frame.origin.y == 0 {
            self.view.frame.origin.y -= getKeyboardHeight(notification)
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
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    func unsubscribeToKeyboardNotification2() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        
    }

    
    // call generateMemedImage() - when?? - inside an action when a user do what??? - when user pressed = shareMemeButtonPressed
    // var memedImage = generateMemedImage()
    // then....
    // since already initiialize within struct,
    //  var abc = Meme(topText: <#T##UITextField#>, bottomText: <#T##UITextField#>, image: <#T##UIImageView#>, memedImage: <#T##UIImageView#>)
    // abc.save(memedImage)
    
    // create Meme Struct with func save()
    struct Meme {
        // properties w/ their types
        var topText: String // As textfield's text is STRING!
        var bottomText: String // String?
        var image : UIImage!
        var memedImage : UIImage!
    }
    
    func save() {  // call this when user hit album/ photolibrary button
        // initialize meme object here - // how to grab the text from topText & bottomText?? Guess: from here? topTextField.text = "TOP", bottomTextField.text = "Bottom"
        // required memedImage, so pass it over to save(memedImage: UIImage) OR
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, image: imagePickerView.image, memedImage: generateMemedImage())
        
        print(meme.bottomText)
        print(meme.memedImage)
    }
    
    // Combining image and text - to return the combined image "memedImage"
    func generateMemedImage() -> UIImage {
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)   // set area/ context to be edited...
        view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)   // allow update after user add text on image
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()   // UIImage retrieved from Current ImageContext, saved to memedImage
        UIGraphicsEndImageContext()  // editing is completed
        print(memedImage)
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
        
        func donewithSharingHandler(activityType: String!, completed: Bool, returnedItems: [AnyObject]!, error: NSError!){
            if completed {
                save()
            } else { // user tap cancel...
                return
            }
        }
        // listener for notifying once sharing meme is completed... - apple doc - var completionWithItemsHandler: UIActivityViewControllerCompletionWithItemsHandler? { get set }
        nextController.completionWithItemsHandler = {
            
            (activity, success, items, error) in
            
            if success {
                print("new memedImg got saved! ")
                self.save()
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
    
}

