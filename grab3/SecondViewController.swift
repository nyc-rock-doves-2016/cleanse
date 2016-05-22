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
    var totalImageCountNeeded = 12
    var imgManager = PHImageManager.defaultManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        collectionViewLayout = CustomImageFlowLayout()
        collectionView.collectionViewLayout = collectionViewLayout
        collectionView.backgroundColor = .whiteColor()
        collectionView.delegate = self;
        self.fetchAndGetSize()
        self.images = sortBySize()
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
        fetchOptions.includeAllBurstAssets = true
        
        let fetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions)
        
        print(fetchResult.count)
        
        if fetchResult.count == 0 {
            
            let alertController = UIAlertController(title: "Wow", message:
                "You don't have any photos! How does it feel to be so clean?", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "Go back", style: UIAlertActionStyle.Default,handler: { (UIAlertAction) -> Void in
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
            }
        })
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.images.count < totalImageCountNeeded && self.images.count > 0 {
            self.deleteSet = NSMutableIndexSet()
            self.viewIndexSet = NSMutableIndexSet(indexesInRange: NSRange(0...self.images.count - 1))
        } else {
            self.deleteSet = NSMutableIndexSet()
            self.viewIndexSet = NSMutableIndexSet(indexesInRange: NSRange(0...11))
        }
        return totalImageCountNeeded
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! ImageCollectionViewCell
        
        collectionView.allowsMultipleSelection = true
        
        cell.selected = false
        
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
        }
        
        return cell
    }
    
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ImageCollectionViewCell
        cell.layer.opacity = 0.2
        cell.layer.cornerRadius = 10
        self.deleteSet.addIndex(indexPath.row)
    }
    
    
    func collectionView(collectionView:UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! ImageCollectionViewCell
        cell.layer.opacity = 1.0
        cell.layer.cornerRadius = 0
        self.deleteSet.removeIndex(indexPath.row)
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
                        let alertController = UIAlertController(title: "Congrats!", message: "Your cleanse is complete.", preferredStyle: .Alert)
                        let actionOk = UIAlertAction(title: "Dismiss", style: .Default, handler: { (UIAlertAction) -> Void in
                            self.navigationController?.popToRootViewControllerAnimated(true)
                        })
                        alertController.addAction(actionOk)
                        self.presentViewController(alertController, animated:true, completion:nil)
                    }
                })
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    self.collectionView.reloadData()
                })
            }
        })
    }
}