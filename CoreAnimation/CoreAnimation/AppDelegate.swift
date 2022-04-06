//
//  AppDelegate.swift
//  CoreAnimation
//
//  Created by Miaokii on 2021/2/5.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        window?.makeKeyAndVisible()
        window?.rootViewController = UINavigationController.init(rootViewController: HomeViewController.init())
        
        UIColor.theme = UIColor.black
        return true
    }
}

