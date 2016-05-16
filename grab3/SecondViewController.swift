//
//  SecondViewController.swift
//  Cleanse
//
//  Created by Emily on 5/14/16.
//  Copyright © 2016 emilyosowski. All rights reserved.
//

import UIKit
import Photos

class SecondViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionViewLayout: CustomImageFlowLayout!
    var images:NSMutableArray!
    var imageFetch:PHFetchResult!
    var imageAssets:AnyObject!
    var indexSet = NSMutableIndexSet()
    var totalImageCountNeeded = 15
    var imageCounter = 0
    var savedCounter = 0
    var totalSavedCounter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionViewLayout = CustomImageFlowLayout()
        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.backgroundColor = .whiteColor()
        collectionView.delegate = self;
        self.fetchPhotos()
    }
    
    func fetchPhotos () {
        imageCounter = 0
        savedCounter = 0
        indexSet = NSMutableIndexSet()
        images = NSMutableArray()
        self.fetchPhotoAtIndexFromEnd(totalSavedCounter)
    }
    
    
    
    
//    func sortFunc(num1: Int, num2: Int) -> Bool {
////        var imageData =
////        var image = num1(data: imageData)
////        var imageSize = Float(imageData.length)
////        return num1(data: imageData) < num2(data: imageData)
//        
//        
//        var asset = self.fetchResults[index] as PHAsset
//        
//        self.imageManager.requestImageDataForAsset(asset, options: nil) { (data:NSData!, string:String!, orientation:UIImageOrientation, object:[NSObject : AnyObject]!) -> Void in
//            //transform into image
//            var image = UIImage(data: data)
//            
//            //Get bytes size of image
//            var imageSize = Float(data.length)
//            
//            //Transform into Megabytes
//            imageSize = imageSize/(1024*1024)
//        }
//    }
//
//    let numbers = [0, 2, 3, 5, 10, 2]
//    let sortedNumbers = sorted(numbers, sortFunc)
    
    
//    var image = UIImage(data: imageData)
//    var imageSize = Float(imageData.length)
//    
//    
//
//    
//
    
    func fetchPhotoAtIndexFromEnd(index:Int) {
        
        let imgManager = PHImageManager.defaultManager()
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.synchronous = true
        requestOptions.networkAccessAllowed = false
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: false)]
        
        if let fetchResult: PHFetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions) {
            
//            var images = [UIImage]()
//            let targetSize: CGSize = view.frame.size
//            let contentMode: PHImageContentMode = PHImageContentMode.AspectFill
//                
//                // photoAsset is an object of type PHFetchResult
//                fetchResult.enumerateObjectsUsingBlock {
//                    object, index, stop in
//                    
//                    let options = PHImageRequestOptions()
//                    options.synchronous = true
//                    
//                    PHImageManager.defaultManager().requestImageForAsset(object as! PHAsset, targetSize: targetSize, contentMode: contentMode, options: options) {
//                        image, info in
//                        images.append(image!)
//                    }
//                    print(images)
//            }
    
            if fetchResult.count > 0 {
                
                imgManager.requestImageForAsset(fetchResult.objectAtIndex(index) as! PHAsset, targetSize: view.frame.size, contentMode: PHImageContentMode.AspectFill, options: requestOptions, resultHandler: { (image, _) in
                    
                    self.images.addObject(image!)
                    
                    self.indexSet.addIndex(self.imageCounter + self.totalSavedCounter)
                    self.imageCounter+=1
                    
                    if index + 1 < fetchResult.count && self.images.count < self.totalImageCountNeeded {
                        self.fetchPhotoAtIndexFromEnd(index + 1)
                    }
                })
            }
            imageFetch = fetchResult
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalImageCountNeeded
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ImageCollectionViewCell
        
        collectionView.allowsMultipleSelection = true
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.redColor().CGColor
        
        if indexPath.row < self.images.count {
            cell.imageView.image = self.images[indexPath.row] as? UIImage
        }
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ImageCollectionViewCell
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.greenColor().CGColor
        savedCounter+=1
        indexSet.removeIndex(indexPath.row + totalSavedCounter)
    }
    
    
    func collectionView(collectionView:UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ImageCollectionViewCell
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.redColor().CGColor
        savedCounter-=1
        indexSet.addIndex(indexPath.row + totalSavedCounter)
    }
    
    
    @IBAction func deleteLast() {
        imageAssets = imageFetch.objectsAtIndexes(indexSet)
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({PHAssetChangeRequest.deleteAssets(self.imageAssets as! NSFastEnumeration)},
                                                           completionHandler: {(success, error) in
                                                            NSLog("\nDeleted Image -> %@", (success ? "Success":"Error!"))
                                                            if(success){
                                                                self.totalSavedCounter+=self.savedCounter
                                                                dispatch_async(dispatch_get_main_queue(), {print("Trashed")
                                                                    self.fetchPhotos()
                                                                    NSLog("fetched")
                                                                    self.collectionView.reloadData()
                                                                    NSLog("Reloaded")
                                                                })
                                                            } else{
                                                                print("Error: \(error)")
                                                            }
        })
    }
}