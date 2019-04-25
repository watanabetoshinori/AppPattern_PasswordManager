//
//  AppDelegate.swift
//  PasswordManager
//
//  Created by Watanabe Toshinori on 4/23/19.
//  Copyright © 2019 Watanabe Toshinori. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    // MARK: - Application lifecycle

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        QuickTypeManager.shared.activate()
        
        return true
    }

}

