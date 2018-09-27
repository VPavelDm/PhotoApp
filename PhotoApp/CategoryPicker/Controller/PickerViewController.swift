//
//  PickerViewController.swift
//  PhotoApp
//
//  Created by mac-089-71 on 9/11/18.
//  Copyright © 2018 VPavelDm. All rights reserved.
//

import UIKit

class PickerViewController: ViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    private let categories = ["NATURE", "FRIENDS", "DEFAULT"]
    weak var delegate: PickerDelegate?
    
    @IBOutlet private weak var picker: UIPickerView!
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row]
    }
    
    @IBAction private func clickChooseCategory(_ sender: Any) {
        let category = categories[picker.selectedRow(inComponent: 0)]
        delegate?.chooseCategory(category: category)
        dismiss(animated: true, completion: nil)
    }
    
}
