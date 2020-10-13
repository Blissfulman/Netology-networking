//
//  AppDelegate.swift
//  GitHub
//
//  Created by User on 11.10.2020.
//  Copyright © 2020 Evgeny. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        
        let rootVC = ViewController(nibName: nil, bundle: nil)
        let navigationController = UINavigationController(rootViewController: rootVC)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        navigationController.viewControllers = [rootVC]
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        return true
    }
}

