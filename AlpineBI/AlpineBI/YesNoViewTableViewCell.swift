//
//  YesNoViewTableViewCell.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 15/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import UIKit

class YesNoViewTableViewCell: UITableViewCell,FormConformity {
    var formItem: FormItem?
    var updateCallback : ((_ selectedValue: String,_ indexPath: IndexPath)-> Void)?
    var labelFieldCellIndex: IndexPath!
    @IBOutlet weak var switcher: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var captionLabelField: UILabel!
    @IBAction func switchChanged(_ sender: UISwitch) {
        var value = "No";
        if sender.isOn {
           value = "Yes"
        }
        self.formItem?.valueCompletion?(value)
        updateCallback?(value,labelFieldCellIndex)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
// MARK: - FormUpdatable
extension YesNoViewTableViewCell: FormUpdatable {
    func update(with formItem: FormItem,isSetCaption:Bool = false) {
        self.formItem = formItem
        if(self.formItem != nil){
            captionLabelField.text = self.formItem?.placeholder
            if let value = formItem.value{
               switcher.setOn(value == "Yes", animated: false)
            }
        }
    }
}
