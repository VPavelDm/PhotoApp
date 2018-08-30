//
//  AppDelegate.swift
//  PhotoApp
//
//  Created by mac-089-71 on 8/30/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        window = UIWindow(frame: UIScreen.main.bounds)
        if Auth.auth().currentUser != nil {
            let viewController = TabBarViewController()
            window?.rootViewController = viewController
        } else {
            let viewController = LoginViewController.create(asClass: LoginViewController.self)
            let navigation = UINavigationController(rootViewController: viewController)
            window?.rootViewController = navigation
        }
        assert(window?.rootViewController != nil, "One of the observers must set the rootViewController")
        window?.makeKeyAndVisible()
        return true
    }


}

protocol AppDelegateObservable {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?, window: UIWindow?)
}
