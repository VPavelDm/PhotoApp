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
        let timelineVC = TimelineViewController.create(asClass: TimelineViewController.self)
        let moreVC = MoreViewController.create(asClass: MoreViewController.self)
        
        self.viewControllers = [mapVC, timelineVC, moreVC]
    }

}
