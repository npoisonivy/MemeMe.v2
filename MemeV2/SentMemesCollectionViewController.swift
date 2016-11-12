//
//  SentMemesCollectionViewController.swift
//  MemeV2
//
//  Created by Nikki L on 11/11/16.
//  Copyright © 2016 Nikki. All rights reserved.
//

import Foundation
import UIKit

class SentMemesCollectionViewController: UICollectionViewController  {
    var memes: [Meme]!
    
    // access to appdelegate's meme 
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.memes
    }
    
override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.memes.count
    }
    
    // show Meme in collection summary view
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        // Struct: topText, bottomText, image, memedImage - at the right hand side of "="
        // MemeCollectionViewCell's properties - topLabel, memeImage, bottomLabel - at the left side of "="
        
        let meme = self.memes[indexPath.item]
        cell.topLabel?.text = meme.topText
        cell.bottomLabel?.text = meme.bottomText
        
        let imageView = UIImageView(image: meme.image)
        cell.memeImage = imageView
        
        return cell
    }
    
//    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        // storyboard 
//        self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
//        
//        
//    }
    
}

