//
//  AppDelegate.swift
//  WSJ RSS feed
//
//  Created by Alper Demirci on 9/15/17.
//  Copyright © 2017 Alper Demirci. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController(rootViewController: RssFeederViewController())
 
        return true
    }
}

