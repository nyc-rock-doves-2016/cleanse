//
//  SecondViewController.swift
//  Cleanse
//
//  Created by Emily on 5/14/16.
//  Copyright © 2016 emilyosowski. All rights reserved.
//

import UIKit
import Photos

class SecondViewController: UIViewController, UICollectionViewDataSource {
    // inherits from both UI classes
    
    @IBOutlet weak var collectionView: UICollectionView!
    // sets up connection with entire view grid on storyboard
    
    var collectionViewLayout: CustomImageFlowLayout!
    // setting a variable to connect the CustomImageFlowLayout
    var images:NSMutableArray!
    // creates uninitialized array to push images
    var imageAssets:AnyObject!
    // creates uninitialized array to push images
    var totalImageCountNeeded = 15
    // how many images we want to pull
    var imageCounter = 0
    // counter to add indexes to index set for fetchresult subresult
    var indexSet = NSMutableIndexSet()
    // creates empty index set for fetchresult
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewLayout = CustomImageFlowLayout()
        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.backgroundColor = .whiteColor()
        self.fetchPhotos()
    }
    
    // like a runner, calls our fetch photo method upon opening of the app, calls layout setup methods
    
    func fetchPhotos () {
        imageCounter = 0
        indexSet = NSMutableIndexSet()
        images = NSMutableArray()
        //reset values for fresh page
        
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
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        
        // filtering with fetchoptions
        
        if let fetchResult: PHFetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions) {
            
            if fetchResult.count > 0 {
                
                indexSet.addIndex(imageCounter)
                imageCounter+=1
                print(indexSet)
                
                imgManager.requestImageForAsset(fetchResult.objectAtIndex(index) as! PHAsset, targetSize: view.frame.size, contentMode: PHImageContentMode.AspectFill, options: requestOptions, resultHandler: { (image, _) in
                    
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
            imageAssets = fetchResult.objectsAtIndexes(indexSet)
        }
    }
    
    // setting media type to image and passing in fetchoptions
    // checks to see if count is greater than zero, requests the image, if not it skips
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalImageCountNeeded
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
            PHAssetChangeRequest.deleteAssets(self.imageAssets as! NSFastEnumeration)
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