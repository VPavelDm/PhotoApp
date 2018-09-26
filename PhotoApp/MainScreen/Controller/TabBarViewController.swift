//
//  TabBarViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 8/30/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    private let map = "Map".localized()
    private let timeline = "Timeline".localized()
    private let more = "More".localized()

    override func viewDidLoad() {
        super.viewDidLoad()

        let mapViewController = MapViewController.createController(asClass: MapViewController.self)
        mapViewController.tabBarItem = UITabBarItem(title: map, image: UIImage(named: "ic_map"), tag: 1)
        
        let timelineViewController = TimelineViewController.createController(asClass: TimelineViewController.self)
        timelineViewController.tabBarItem = UITabBarItem(title: timeline, image: UIImage(named: "ic_timeline"), tag: 2)
        let navigationViewController = UINavigationController(rootViewController: timelineViewController)
        
        let moreViewController = MoreViewController.createController(asClass: MoreViewController.self)
        moreViewController.tabBarItem = UITabBarItem(title: more, image: UIImage(named: "ic_more"), tag: 3)
        
        viewControllers = [mapViewController, navigationViewController, moreViewController]
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let mapViewController = viewControllers?.first as! MapViewController
        let timelineViewController = (viewControllers![1] as! UINavigationController).viewControllers.first as? TimelineViewController
        if item.title == map {
            mapViewController.categories = timelineViewController!.categories
        } else {
            timelineViewController!.categories = mapViewController.categories
        }
    }

}
