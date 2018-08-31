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
        mapViewController.tabBarItem = UITabBarItem(title: "Map", image: UIImage(named: "ic_map"), tag: 1)
        let timelineViewController = TimelineViewController.create(asClass: TimelineViewController.self)
        timelineViewController.tabBarItem = UITabBarItem(title: "Timeline", image: UIImage(named: "ic_timeline"), tag: 2)
        let moreViewController = MoreViewController.create(asClass: MoreViewController.self)
        moreViewController.tabBarItem = UITabBarItem(title: "More", image: UIImage(named: "ic_more"), tag: 3)
        
        viewControllers = [mapViewController, timelineViewController, moreViewController]
    }

}
