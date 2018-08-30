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
        observers += [FirebaseAppDelegateObserver()]
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        for observer in observers {
            observer.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
        return true
    }


}

protocol AppDelegateObservable {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?)
}
