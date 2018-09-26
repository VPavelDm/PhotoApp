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
    var selectedCategories: [Category] = [.nature, .friends, .default_category]

    @IBOutlet var buttons: [CategoryButton]! {
        didSet {
            for button in buttons {
                button.clickedButton()
            }
            if selectedCategories.contains(.nature) {
                buttons[0].clickedButton()
            }
            if selectedCategories.contains(.friends) {
                buttons[1].clickedButton()
            }
            if selectedCategories.contains(.default_category) {
                buttons[2].clickedButton()
            }
        }
    }
    
    @IBAction func clickNatureButton(_ sender: CategoryButton) {
        sender.clickedButton()
    }
    
    @objc func clickDoneButton(_ sender: UIBarButtonItem) {
        var answer: [Category] = []
        for (index, button) in buttons.enumerated() {
            if !button.isSelected {
                answer += [Category.category(index: index)]
            }
        }
        delegate?.choosed(categories: answer)
        
        let defaults = UserDefaults.standard
        defaults.set(Category.convert(categories: answer), forKey: String(describing: Category.self))
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initNavigationBar()
    }
    
}
