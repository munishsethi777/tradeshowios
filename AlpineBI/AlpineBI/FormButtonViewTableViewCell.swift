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
    var buttonTappedCallBack : (()-> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func buttonViewTapped(_ sender: Any) {
       buttonTappedCallBack?()
    }

}
extension FormButtonViewTableViewCell: FormUpdatable {
    func update(with formItem: FormItem) {
        self.formItem = formItem
        if(self.formItem != nil){
            buttonView.setTitle(self.formItem?.placeholder, for: .normal)
        }
    }
}
