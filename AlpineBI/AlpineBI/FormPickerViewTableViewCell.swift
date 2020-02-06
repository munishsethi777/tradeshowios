//
//  FormPickerViewTableViewCell.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 05/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//
import Foundation
import UIKit
class FormPickerViewTableViewCell :UITableViewCell, FormConformity,UITextFieldDelegate {
    var formItem: FormItem?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @objc func textFieldDidChanged(_ textField: UITextField) {
        self.formItem?.valueCompletion?(textField.text)
    }
}

// MARK: - FormUpdatable
extension FormPickerViewTableViewCell: FormUpdatable {
    func update(with formItem: FormItem) {
       
    }
}
