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
    var totalImageCountNeeded:Int!
    // how many images we want to pull
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchPhotos()
        
        collectionViewLayout = CustomImageFlowLayout()
        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.backgroundColor = .blackColor()
    }
    
    // like a runner, calls our fetch photo method upon opening of the app, calls layout setup methods
    
    func fetchPhotos () {
        images = NSMutableArray()
        totalImageCountNeeded = 25
        self.fetchPhotoAtIndexFromEnd(0)
    }
    
    // calls method that fetches photos from photo library
    
    func fetchPhotoAtIndexFromEnd(index:Int) {
        
        let imgManager = PHImageManager.defaultManager()
        
        // controller of the photos
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.synchronous = true
        
        // request only thumbnails by setting synchronous to true
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
        
        // filtering with fetchoptions
        
        if let fetchResult: PHFetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions) {
            
            if fetchResult.count > 0 {
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
        return 25
    }
    
    // how many items we want to return
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ImageCollectionViewCell
        print(self.images)
        
        // calling a cell reusable performs iteration
        
        if indexPath.row < self.images.count {
            cell.imageView.image = self.images[indexPath.row] as? UIImage
        }
        
        // everytime move to next cell, move to next image, avoids repetition of images
        
        return cell
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    // status bar hidden
}