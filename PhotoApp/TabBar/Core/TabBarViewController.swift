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

        let mapVC = MapViewController.create(asClass: MapViewController.self)
        mapVC.tabBarItem = UITabBarItem(title: "Map", image: UIImage(named: "ic_map"), tag: 1)
        let timelineVC = TimelineViewController.create(asClass: TimelineViewController.self)
        timelineVC.tabBarItem = UITabBarItem(title: "Timeline", image: UIImage(named: "ic_timeline"), tag: 2)
        let moreVC = MoreViewController.create(asClass: MoreViewController.self)
        moreVC.tabBarItem = UITabBarItem(title: "More", image: UIImage(named: "ic_more"), tag: 3)
        
        viewControllers = [mapVC, timelineVC, moreVC]
    }

}
