//
//  InfoController.swift
//  Cleanse
//
//  Created by Emily on 5/18/16.
//  Copyright © 2016 emilyosowski. All rights reserved.
//

import UIKit

class InfoController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clearColor()
        view.opaque = false
        
        
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        var swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipeDown)
        
    }
    
    @IBAction func buttonClicked(sender: AnyObject){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func handleSwipe(gesture:UISwipeGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.Down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.Left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.Up:
                print("Swiped up")
            default:
                break
            }
    
    }
}
}
    
    

