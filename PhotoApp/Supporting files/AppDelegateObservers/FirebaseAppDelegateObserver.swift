//
//  FirebaseAppDelegate.swift
//  PhotoApp
//
//  Created by mac-089-71 on 8/30/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class FirebaseAppDelegateObserver: AppDelegateObservable {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?, window: UIWindow?) {
        FirebaseApp.configure()
    }
}
