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
    
       override func viewDidLoad() {
        
        self.navigationController?.navigationBar.barStyle       = UIBarStyle.Black // I then set the color using:
        
//        self.navigationController?.navigationBar.barTintColor   = UIColor(red: 204/255, green: 47/255, blue: 40/255, alpha: 1.0) // a lovely red
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor() // for titles, buttons, etc.
        
        let navigationTitleFont = UIFont(name: "Geoma Thin Demo", size: 40)!
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName: navigationTitleFont]
        
        self.navigationController?.navigationBar.frame = CGRectMake(30, 0, 200, 30);

        
        
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
    }
    @IBAction func deleteAll() {
        if let fetchResult: PHFetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: nil) {
            
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