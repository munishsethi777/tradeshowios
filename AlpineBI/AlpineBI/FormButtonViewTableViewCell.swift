//
//  ButtonViewCell.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 11/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import UIKit
import ContactsUI
class FormButtonViewTableViewCell: UITableViewCell,CustomCell {
    var delegate: CallBackProtocol!
    var parent: UIViewController!
    var formItem: FormItem?
    @IBOutlet weak var buttonView: UIButton!
    
    @IBOutlet weak var labelbutton: UILabel!
    @IBOutlet weak var labelField: UILabel!
    var indexPath: IndexPath!
    var buttonTappedCallBack : ((_ fieldName: String)-> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        labelbutton.isUserInteractionEnabled = true
        labelbutton.addGestureRecognizer(tap)
    }
    
    @objc
    func tapFunction(sender:UITapGestureRecognizer) {
        buttonTappedCallBack?(formItem?.name ?? "")
        delegate.buttonTapped(indexPath: indexPath)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool){
        super.setSelected(selected, animated: animated)
    }

    @IBAction func buttonViewTapped(_ sender: Any){
        buttonTappedCallBack?(formItem?.name ?? "")
        delegate.buttonTapped(indexPath: indexPath)
    }
}

extension FormButtonViewTableViewCell: FormUpdatable {
    func update(with formItem: FormItem,isSetCaption:Bool = false) {
        self.formItem = formItem
        if(self.formItem != nil){
            if(isSetCaption){
                labelField.text = self.formItem?.placeholder
                //buttonView.setTitle(self.formItem?.placeholder, for: .normal)
            }
            //if(self.formItem?.value != nil && self.formItem?.value != ""){
               labelbutton.text = self.formItem?.value
            //}
            if(formItem.isButtonOnly){
                labelField.text = ""
                //buttonView.setTitleColor(.black, for: .normal)
                labelbutton.text = self.formItem?.placeholder
                if let textColor = formItem.color {
                    labelbutton.textColor = textColor
                }
            }
        }
    }
}
