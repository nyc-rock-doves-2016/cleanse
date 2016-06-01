//
//  AppDelegate.swift
//  grab3
//
//  Created by Emily on 5/13/16.
//  Copyright © 2016 emilyosowski. All rights reserved.
//


import UIKit
import Photos

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        UINavigationBar.appearance().tintColor = UIColor.blackColor()
        return true
    }
}

