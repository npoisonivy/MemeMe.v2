//
//  SentMemesTableViewController.swift
//  MemeV2
//
//  Created by Nikki L on 11/11/16.
//  Copyright © 2016 Nikki. All rights reserved.
//

import Foundation
import UIKit

class SentMemesTableViewController: UITableViewController {
    var memes: [Meme]!
    
    // access AppDelegate's model object 
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.memes
        
        self.navigationItem.title = "Sent Memes"
        self.tableView?.reloadData()
    }
    
    // 3 methods to display Meme in Table View
 
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(memes.count)
        return self.memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // dequeue reusable cell
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomMemeCell")!
        
        // set each row
        let meme = memes[indexPath.row]  // new var meme carries struct properties - topText, bottomText, image, memedImage
        
        // set cell's properties = struct properties
        cell.imageView?.image = meme.memedImage
        cell.textLabel!.text = ""
        cell.detailTextLabel!.text = meme.topText + "..." + meme.bottomText
    
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // instantiate vc on msb
        let nextController = self.storyboard?.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        
        // populate view controller with data
        let meme = self.memes[indexPath.item]
        // only to show memedImage on memeDetailController
        nextController.memedImage_toshow = meme.memedImage
        
        // present the view controller using navigation
        self.navigationController?.pushViewController(nextController, animated: true)
    }
}










