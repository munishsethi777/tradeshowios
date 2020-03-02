//
//  ReadOnlyTableViewCell.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 14/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//
import Foundation
import UIKit
class ReadOnlyTableViewCell: UITableViewCell, FormConformity,UITextFieldDelegate,UIPickerViewDelegate {
    var formItem: FormItem?
    
    @IBOutlet weak var captionLabelField: UILabel!
    
    @IBOutlet weak var labelField: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
// MARK: - FormUpdatable
extension ReadOnlyTableViewCell: FormUpdatable {
    func update(with formItem: FormItem,isSetCaption:Bool = false) {
        self.formItem = formItem
        if(self.formItem != nil && !self.formItem!.isPicker){
            captionLabelField.text = self.formItem?.placeholder
            self.labelField.text = self.formItem?.value
            self.labelField.tintColor = self.formItem?.uiProperties.tintColor
        }else{
            captionLabelField.text = ""
            self.labelField.text = ""
        }
    }
}
