//
//  SecondViewController.swift
//  Cleanse
//
//  Created by Emily on 5/14/16.
//  Copyright © 2016 emilyosowski. All rights reserved.
//

import UIKit
import Photos


struct imageWithSize {
    var image: UIImage?
    var size = Float(0)
    var asset: PHAsset?
}

class SecondViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var activityInd: UIActivityIndicatorView!
    
    let navigationTitleFont = UIFont(name: "Geoma Thin Demo", size: 40)!
    
    var collectionViewLayout: CustomImageFlowLayout!
    var images = [imageWithSize]()
    var imageAssets = [AnyObject]()
    var viewIndexSet = NSMutableIndexSet()
    var deleteSet = NSMutableIndexSet()
    var totalImageCountNeeded = 15
    var imgManager = PHImageManager.defaultManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchAndGetSize()
        self.images = sortBySize()
        self.automaticallyAdjustsScrollViewInsets = false
        collectionViewLayout = CustomImageFlowLayout()
        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.backgroundColor = .whiteColor()
        collectionView.delegate = self;
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.handleSwipes))
        rightSwipe.direction = .Right
        view.addGestureRecognizer(rightSwipe)
    }
    
    func handleSwipes(sender: UISwipeGestureRecognizer){
        if sender.direction == .Right {
            self.performSegueWithIdentifier("unwindToMain", sender: self)
        }
    }

    func sortBySize() -> [imageWithSize] {
        return self.images.sort({ $0.size > $1.size })
    }
    
    
    func fetchAndGetSize() {
        
        let requestOptions = PHImageRequestOptions()
        requestOptions.synchronous = true
        requestOptions.networkAccessAllowed = false
        
        let fetchOptions = PHFetchOptions()
        
        let fetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions)
        print(fetchResult)
        
        if fetchResult.count == 0 {
            
            let alertController = UIAlertController(title: "Wow", message:
                "You don't have any photos! How does it feel to be so clean?", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default,handler: { (UIAlertAction) -> Void in
                self.navigationController?.popToRootViewControllerAnimated(true)
                }))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            
        }
        
        fetchResult.enumerateObjectsUsingBlock({ object, index, stop in
            
            let asset = object
            
            self.imgManager.requestImageDataForAsset(asset as! PHAsset, options: requestOptions){
                
                (data:NSData?, string:String?, orientation:UIImageOrientation, object:[NSObject : AnyObject]?) -> Void in
                let image = UIImage(data: data!)
                var imageSize = Float(data!.length)
                imageSize = imageSize/(1024*1024)
                var imgData = imageWithSize()
                imgData.image = image
                imgData.size = imageSize
                imgData.asset = asset as? PHAsset
                self.images.append(imgData)
//                print(imgData.asset)
            }
        })
    }
     
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalImageCountNeeded
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ImageCollectionViewCell
        
        collectionView.allowsMultipleSelection = true
        
        
        if self.images.count < totalImageCountNeeded  && self.images.count > 0 {
            let x = self.images.count - 1
            self.deleteSet = NSMutableIndexSet(indexesInRange: NSRange(0...x))
            self.viewIndexSet = NSMutableIndexSet(indexesInRange: NSRange(0...x))
        } else {
            self.deleteSet = NSMutableIndexSet(indexesInRange: NSRange(0...14))
            self.viewIndexSet = NSMutableIndexSet(indexesInRange: NSRange(0...14))
        }
        
        if cell.selected {
            cell.layer.opacity = 0.2
            cell.layer.cornerRadius = 10
        } else {
            collectionView.allowsMultipleSelection = true
            cell.layer.cornerRadius = 0
            cell.layer.opacity = 1
        }
        if indexPath.row < self.images.count {
            cell.imageView.image = self.images[indexPath.row].image! as UIImage
        } else {
            cell.hidden = true
        }
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ImageCollectionViewCell
        cell.layer.opacity = 0.2
        cell.layer.cornerRadius = 10
        self.deleteSet.removeIndex(indexPath.row)
    }
    
    
    func collectionView(collectionView:UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ImageCollectionViewCell
        cell.layer.opacity = 1.0
        cell.layer.cornerRadius = 0
        self.deleteSet.addIndex(indexPath.row)
    }
    
    @IBAction func deleteAssets() {
        
        var deleteImages = [AnyObject]()
        for i in self.deleteSet.sort().reverse() {
            deleteImages.append(self.images[i].asset!)
        }
        
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({PHAssetChangeRequest.deleteAssets(deleteImages as NSFastEnumeration)},
                                                           completionHandler: {(success, error) in
                                                            if(success){
                                                                
                                                                for i in self.viewIndexSet.reverse() {
                                                                    self.images.removeAtIndex(i)
                                                                }
                                                                
                                                                dispatch_async(dispatch_get_main_queue(), {
                                                                    if self.images.count > 0 {
                                                                        self.collectionView.reloadData()
                                                                    } else {
                                                                        let alertController = UIAlertController(title: "Yas!", message: "Your cleanse is complete.  Now go walk children in nature.", preferredStyle: .Alert)
                                                                        let actionOk = UIAlertAction(title: "neato", style: .Default, handler: { (UIAlertAction) -> Void in
                                                                            self.navigationController?.popToRootViewControllerAnimated(true)
                                                                        })
                                                                        alertController.addAction(actionOk)
                                                                        self.presentViewController(alertController, animated:true, completion:nil)
                                                                    }
                                                                })
                                                            } else{
                                                                dispatch_async(dispatch_get_main_queue(), {
                                                                    self.collectionView.reloadData()
                                                                })
                                                            }
        })
    }
}