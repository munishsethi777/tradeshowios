//
//  FormTextFieldTableViewCell.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 03/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import Foundation
import UIKit
class FormTextFieldTableViewCell: UITableViewCell, FormConformity,UITextFieldDelegate,UIPickerViewDelegate {
    
    var formItem: FormItem?
    
    @IBOutlet weak var labelField: UILabel!
    
    @IBOutlet weak var ibTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.ibTextField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
    }
    @objc func textFieldDidChanged(_ textField: UITextField) {
        self.formItem?.valueCompletion?(textField.text)
    }
}

// MARK: - FormUpdatable
extension FormTextFieldTableViewCell: FormUpdatable {
    func update(with formItem: FormItem,isSetCaption:Bool = false) {
        self.formItem = formItem
        if(self.ibTextField != nil){
            self.ibTextField.text = self.formItem?.value
            self.labelField.text = self.formItem?.placeholder
            let bgColor: UIColor = self.formItem?.isValid  == false ? .red : .white
            self.ibTextField.layer.backgroundColor = bgColor.cgColor
           // self.ibTextField.placeholder = self.formItem?.placeholder
            self.ibTextField.keyboardType = self.formItem?.uiProperties.keyboardType ?? .default
            self.ibTextField.tintColor = self.formItem?.uiProperties.tintColor
            //ibTextField.bindToKeyboard()
        }
    }
}
