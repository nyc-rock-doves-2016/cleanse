//
//  ViewController.swift
//  grab3
//
//  Created by Emily on 5/13/16.
//  Copyright © 20/Users/Emily/Desktop/grab3/grab3/ImageCollectionViewCell.swift16 emilyosowski. All rights reserved.
//

import UIKit
import Photos

class ViewController: UIViewController, UICollectionViewDataSource {
    // inherits from both UI classes
    
    @IBOutlet weak var collectionView: UICollectionView!
    // sets up connection with entire view grid on storyboard
    
    var collectionViewLayout: CustomImageFlowLayout!
    // setting a variable to connect the CustomImageFlowLayout
    var images:NSMutableArray!
    // creates uninitialized array to push images
    var imageAssets:PHFetchResult!
    // creates uninitialized array to push images
    var totalImageCountNeeded:Int!
    // how many images we want to pull
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewLayout = CustomImageFlowLayout()
        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.backgroundColor = .whiteColor()
        self.fetchPhotos()
    }
    
    // like a runner, calls our fetch photo method upon opening of the app, calls layout setup methods
    
    func fetchPhotos () {
        images = NSMutableArray()
        totalImageCountNeeded = 12
        self.fetchPhotoAtIndexFromEnd(0)
    }
    
    // calls method that fetches photos from photo library
    
    func fetchPhotoAtIndexFromEnd(index:Int) {
        
        let imgManager = PHImageManager.defaultManager()
        
        // controller of the photos
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.synchronous = true
        requestOptions.networkAccessAllowed = false
        
        // request only thumbnails by setting synchronous to true, ignore cloud photos
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
        fetchOptions.fetchLimit = totalImageCountNeeded
        
        // filtering with fetchoptions
        
        if let fetchResult: PHFetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions) {
            
            if fetchResult.count > 0 {
                
                imageAssets = fetchResult
                
                imgManager.requestImageForAsset(fetchResult.objectAtIndex(fetchResult.count - 1 - index) as! PHAsset, targetSize: view.frame.size, contentMode: PHImageContentMode.AspectFill, options: requestOptions, resultHandler: { (image, _) in

                    self.images.addObject(image!)
                    
                    // adds images
                    
                    if index + 1 < fetchResult.count && self.images.count < self.totalImageCountNeeded {
                        self.fetchPhotoAtIndexFromEnd(index + 1)
                        // is this the last photo? if not pull one more after it (recursion), add index plus 1 everytime
                    } else {
                        // Else you have completed creating your array
                    }
                })
            }
        }
    }
    
    // setting media type to image and passing in fetchoptions 
    // checks to see if count is greater than zero, requests the image, if not it skips
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 12
    }
    
    // how many items we want to return
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ImageCollectionViewCell
        
        // calling a cell reusable performs iteration
        
        if indexPath.row < self.images.count {
            cell.imageView.image = self.images[indexPath.row] as? UIImage
        }
        
        // everytime move to next cell, move to next image, avoids repetition of images
        
        return cell
    }
    
    
    @IBAction func deleteLast() {

        PHPhotoLibrary.sharedPhotoLibrary().performChanges({
            PHAssetChangeRequest.deleteAssets(self.imageAssets)
            },
           completionHandler: {(success, error)in
            NSLog("\nDeleted Image -> %@", (success ? "Success":"Error!"))
            if(success){
                dispatch_async(dispatch_get_main_queue(), {
                    print("Trashed")
                })
                self.fetchPhotos()
                self.collectionView.reloadData()
            }else{
                print("Error: \(error)")
            }
        })
    }
}