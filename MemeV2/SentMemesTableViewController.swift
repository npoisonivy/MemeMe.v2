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
    }
    
    // 3 methods to display Meme in Table View
 
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomMemeCell")!
        
        let meme = memes[indexPath.row]
        cell.textLabel!.text = meme.topText
        cell.detailTextLabel!.text = meme.topText + meme.bottomText
        cell.imageView?.image = meme.image
        // can also just get meme.memedImage
    
        return cell
    }
//
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        <#code#>
//    }(<#parameters#>) -> <#return type#> {
//        <#function body#>
//    }
}