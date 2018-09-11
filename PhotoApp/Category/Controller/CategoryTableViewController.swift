//
//  CategoryTableViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/11/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    
    weak var delegate: CategoryDelegate?
    @IBOutlet var buttons: [CategoryButton]! {
        didSet {
            for button in buttons {
                button.clickedButton()
            }
            if selectedCategories.contains("NATURE") {
                buttons[0].clickedButton()
            }
            if selectedCategories.contains("FRIENDS") {
                buttons[1].clickedButton()
            }
            if selectedCategories.contains("DEFAULT") {
                buttons[2].clickedButton()
            }
        }
    }
    var selectedCategories: [String] = ["NATURE", "FRIENDS", "DEFAULT"]
    
    @IBAction func clickNatureButton(_ sender: CategoryButton) {
        sender.clickedButton()
    }
    
    @IBAction func clickDoneButton(_ sender: UIBarButtonItem) {
        var answer: [String] = []
        for (index, button) in buttons.enumerated() {
            if !button.isSelected {
                answer += [category(index: index)]
            }
        }
        delegate?.choosed(categories: answer)
        dismiss(animated: true, completion: nil)
    }
    
    private func category(index: Int) -> String {
        switch index {
        case 0:
            return "NATURE"
        case 1:
            return "FRIENDS"
        default:
            return "DEFAULT"
        }
    }
    
}
