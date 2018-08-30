//
//  AppDelegate.swift
//  PhotoApp
//
//  Created by mac-089-71 on 8/30/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private(set) var observers: [AppDelegateObservable] = []
    
    var window: UIWindow?
    
    override init() {
        observers += [LoginVCAppDelegateObserver() as AppDelegateObservable, FirebaseAppDelegateObserver() as AppDelegateObservable]        
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        for observer in observers {
            observer.application(application, didFinishLaunchingWithOptions: launchOptions, window: window)
        }
        assert(window?.rootViewController != nil, "One of the observers must set the rootViewController")
        window?.makeKeyAndVisible()
        return true
    }


}

protocol AppDelegateObservable {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?, window: UIWindow?)
}
