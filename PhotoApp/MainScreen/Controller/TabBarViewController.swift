//
//  TabBarViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 8/30/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let mapViewController = MapViewController.create(asClass: MapViewController.self)
        mapViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("Map", comment: "Map label"), image: UIImage(named: "ic_map"), tag: 1)
        let timelineViewController = TimelineViewController.create(asClass: TimelineViewController.self)
        timelineViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("Timeline", comment: "Timeline label"), image: UIImage(named: "ic_timeline"), tag: 2)
        let moreViewController = MoreViewController.create(asClass: MoreViewController.self)
        moreViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("More", comment: "More label"), image: UIImage(named: "ic_more"), tag: 3)
        
        viewControllers = [mapViewController, timelineViewController, moreViewController]
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        for viewController in viewControllers! {
            if let timelineViewController = viewController as? TimelineViewController {
                if timelineViewController.tabBarItem.title == item.title {
                    for viewController in viewControllers! {
                        if let mapViewController = viewController as? MapViewController {
                            timelineViewController.categories = mapViewController.categories
                        }
                    }
                }
            }
        }
    }

}
