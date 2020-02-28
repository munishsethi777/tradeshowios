//
//  ButtonViewCell.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 11/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import UIKit
import ContactsUI
class FormButtonViewTableViewCell: UITableViewCell {
    var formItem: FormItem?
    @IBOutlet weak var buttonView: UIButton!
    
    @IBOutlet weak var labelField: UILabel!
    var buttonTappedCallBack : ((_ fieldName: String)-> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func buttonViewTapped(_ sender: Any) {
        buttonTappedCallBack?(formItem?.name ?? "")
    }

}
extension FormButtonViewTableViewCell: FormUpdatable {
    func update(with formItem: FormItem,isSetCaption:Bool = false) {
        self.formItem = formItem
        if(self.formItem != nil){
            if(isSetCaption){
                labelField.text = self.formItem?.placeholder
                buttonView.setTitleColor(.black, for: .normal)
                //buttonView.setTitle(self.formItem?.placeholder, for: .normal)
            }
            //if(self.formItem?.value != nil && self.formItem?.value != ""){
                buttonView.setTitle(self.formItem?.value, for: .normal)
            //}
        }
    }
}
