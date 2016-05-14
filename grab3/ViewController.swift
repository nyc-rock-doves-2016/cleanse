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
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionViewLayout: CustomImageFlowLayout!
    var images:NSMutableArray!
    var totalImageCountNeeded:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchPhotos()
        
        collectionViewLayout = CustomImageFlowLayout()
        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.backgroundColor = .blackColor()
    }
    
    func fetchPhotos () {
        images = NSMutableArray()
        totalImageCountNeeded = 25
        self.fetchPhotoAtIndexFromEnd(0)
    }
    
    func fetchPhotoAtIndexFromEnd(index:Int) {
        
        let imgManager = PHImageManager.defaultManager()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.synchronous = true
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
        
        if let fetchResult: PHFetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions) {
            
            if fetchResult.count > 0 {
                imgManager.requestImageForAsset(fetchResult.objectAtIndex(fetchResult.count - 1 - index) as! PHAsset, targetSize: view.frame.size, contentMode: PHImageContentMode.AspectFill, options: requestOptions, resultHandler: { (image, _) in
                    
                    self.images.addObject(image!)
                    
                    if index + 1 < fetchResult.count && self.images.count < self.totalImageCountNeeded {
                        self.fetchPhotoAtIndexFromEnd(index + 1)
                    } else {
                        // Else you have completed creating your array
                    }
                })
            }
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 25
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ImageCollectionViewCell
        print(self.images)
        
        cell.imageView.image = self.images[0] as? UIImage
        
        return cell
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}