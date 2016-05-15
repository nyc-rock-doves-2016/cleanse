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