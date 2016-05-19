//
//  ViewController.swift
//  grab3
//
//  Created by Emily on 5/13/16.
//  Copyright © 20/Users/Emily/Desktop/grab3/grab3/ImageCollectionViewCell.swift16 emilyosowski. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    @IBAction func unwindToHere(segue: UIStoryboardSegue) { }
    
    override func viewDidLoad() {
        
        self.navigationBar()
        
    }
    
//    
    func navigationBar() {
//
        let navigationTitleFont = UIFont(name: "Geoma Thin Demo", size: 35)!
        let nav =  self.navigationController?.navigationBar

        nav!.titleTextAttributes = [NSFontAttributeName: navigationTitleFont]
//        nav!.barStyle = UIBarStyle.Black // I then set the color using:
//        nav!.tintColor = UIColor.blackColor() // for titles, buttons, etc.
//        nav!.titleTextAttributes = [NSFontAttributeName: navigationTitleFont]
//        nav!.frame = CGRectMake(30, 0, 200, 30);
        nav!.setTitleVerticalPositionAdjustment(CGFloat(7), forBarMetrics: UIBarMetrics.Default)
//
        self.navigationController?.navigationBar.barTintColor   = UIColor.whiteColor()
        // UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName:UIColor.blackColor()]
//    
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
    @IBAction func deleteAll() {
        if let fetchResult: PHFetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: nil) {
            
            if fetchResult.count == 0 {
                let alertController = UIAlertController(title: "Wow!", message:
                    "You don't have any photos! How does it feel to be so clean?", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: nil))
                
                self.presentViewController(alertController, animated: true, completion: nil)
            }
            
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({
                PHAssetChangeRequest.deleteAssets(fetchResult)
                },
               completionHandler: {(success, error)in
                NSLog("\nDeleted Image -> %@", (success ? "Success":"Error!"))
                if(success){
                    dispatch_async(dispatch_get_main_queue(), {
                        print("Trashed")
                    })
                }else{
                    print("Error: \(error)")
                }
            })
        }
    }
}