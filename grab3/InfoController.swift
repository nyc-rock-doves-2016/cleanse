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
    }
    
    @IBAction func closeClicked(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
    
    

