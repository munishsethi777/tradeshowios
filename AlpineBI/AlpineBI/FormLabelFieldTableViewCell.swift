//
//  FormLabelFieldTableViewCell.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 07/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import Foundation
import Foundation
import UIKit
class FormLabelFieldTableViewCell: UITableViewCell, FormConformity,UITextFieldDelegate,UIPickerViewDelegate {
    @IBOutlet weak var captionLabelField: UILabel!
    var formItem: FormItem?
    @IBOutlet weak var labelField: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
// MARK: - FormUpdatable
extension FormLabelFieldTableViewCell: FormUpdatable {
    func update(with formItem: FormItem,isSetCaption:Bool = false) {
        self.formItem = formItem
        if(self.formItem != nil){
            captionLabelField.text = self.formItem?.placeholder
            if(self.formItem?.value != nil && self.formItem?.value != ""){
                 self.labelField.text = self.formItem?.value
                 self.labelField.textColor = .black
            }else{
                //self.labelField.text = self.formItem?.placeholder
                self.labelField.font = UIFont(name:"Helvetica",size: 13.0)
                self.labelField.textColor = .init(white: 0.740, alpha: 1.0)
            }
            self.labelField.tintColor = self.formItem?.uiProperties.tintColor
        }
    }
}
