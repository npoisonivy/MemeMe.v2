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
        
        self.navigationItem.title = "Sent Memes"
        collectionView?.reloadData()
    }
    
override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        print(memes.count)
        return memes.count
    }
    
    // show Meme in collection summary view
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        // dequeue usable cell with identifer
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("MemeCollectionViewCell", forIndexPath: indexPath) as! MemeCollectionViewCell
        
        // set UI data with struct Meme data
        // Struct: topText, bottomText, image, memedImage - at the right hand side of "="
        // MemeCollectionViewCell's properties - topLabel, memeImage, bottomLabel - at the left side of "="
        let meme = memes[indexPath.item] // that ONE meme out of ALL Memes
        // set cell's content 

        // @ cell-MemeCollectionViewcell - @IBOutlet weak var memeImage: UIImageView!
        // @ Struct Meme (Meme.swift) - let memedImage : UIImage!
        cell.memeImage.image = meme.memedImage
      
        return cell
    }
    
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // instantite VC on MSB that you want to show next
        let nextController = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        
        // let individual meme when user choose one of meme -> return indexPath to this method
        let meme = memes[indexPath.item]
        
        // set DetailView's data
        nextController.memedImage_toshow = meme.memedImage
        
        // push this nextController to nav stack
        self.navigationController?.pushViewController(nextController, animated: true)
        
    }
}















