//
//  CategoryTableViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/11/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {

    private var cellButtons: [UIButton] = []
    private let categoryNames = ["NATURE", "FRIENDS", "DEFAULT"]
    private let categoryColors = ["NATURE" : UIColor(red: CGFloat(87/255.0), green: CGFloat(142/255.0), blue: CGFloat(24/255.0), alpha: 1),
                                   "FRIENDS" : UIColor(red: CGFloat(244/255.0), green: CGFloat(165/255.0), blue: CGFloat(35/255.0), alpha: 1),
                                   "DEFAULT" : UIColor(red: CGFloat(54/255.0), green: CGFloat(142/255.0), blue: CGFloat(233/255.0), alpha: 1)]

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed(String(describing: CategoryTableViewCell.self), owner: self, options: nil)?.last as! CategoryTableViewCell
        cell.categoryLabel.text = categoryNames[indexPath.row]
        let color = categoryColors[categoryNames[indexPath.row]]!.cgColor
        cell.categoryButton.layer.backgroundColor = color
        print(cell.categoryButton.frame.size)
        cell.categoryButton.layer.borderWidth = 2
        let radius = cell.categoryButton.frame.size.height / 2 - 3
        cell.categoryButton.layer.cornerRadius = radius
        cell.categoryButton.layer.borderColor = categoryColors[categoryNames[indexPath.row]]!.cgColor
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
