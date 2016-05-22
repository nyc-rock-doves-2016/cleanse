import UIKit
import Photos

class ViewController: UIViewController {
    
    @IBAction func unwindToHere(segue: UIStoryboardSegue) { }
    
    override func viewDidLoad() {
        self.navigationBar()
    }
    

    func navigationBar() {
        let navigationTitleFont = UIFont(name: "Geoma Thin Demo", size: 35)!
        let nav =  self.navigationController?.navigationBar

        nav!.titleTextAttributes = [NSFontAttributeName: navigationTitleFont]
        nav!.setTitleVerticalPositionAdjustment(CGFloat(7), forBarMetrics: UIBarMetrics.Default)

        self.navigationController?.navigationBar.barTintColor   = UIColor.whiteColor()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem
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
                        let alertController = UIAlertController(title: "Congrats!", message: "Your cleanse is complete.", preferredStyle: .Alert)
                        let actionOk = UIAlertAction(title: "Dismiss", style: .Default, handler: { (UIAlertAction) -> Void in
                            self.navigationController?.popToRootViewControllerAnimated(true)
                        })
                        alertController.addAction(actionOk)
                        self.presentViewController(alertController, animated:true, completion:nil)
                    })
                }else{
                    print("Error: \(error)")
                }
            })
        }
    }
}