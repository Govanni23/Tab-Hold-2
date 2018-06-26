//
//  AppDelegate.swift
//  Tab Hold 2
//
//  Created by Govanni Deleon on 6/10/18.
//  Copyright © 2018 Deleon Apps. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print(Realm.Configuration.defaultConfiguration.fileURL)
        
        do{
            _ = try Realm()
        } catch {
            print("Error initializing new realm. \(error)")
        }
        
        return true
    }

}

