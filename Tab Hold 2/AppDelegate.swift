//
//  AppDelegate.swift
//  Tab Hold 2
//
//  Created by Govanni Deleon on 6/10/18.
//  Copyright © 2018 Deleon Apps. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("went into background")
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
       
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
     
        
    }

    func applicationWillTerminate(_ application: UIApplication) {
       
        print("Terminate")
        
    }


}

