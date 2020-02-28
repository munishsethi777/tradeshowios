//
//  DatePickerViewTableViewCell.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 14/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//
import UIKit
class DatePickerViewTableViewCell: UITableViewCell, FormConformity {
    var formItem: FormItem?
    var labelFieldCellIndex: IndexPath!
    var updateCallback : ((_ selectedValue: String,_ indexPath: IndexPath)-> Void)?
    @IBOutlet weak var datePickerView: UIDatePicker!
    override func awakeFromNib() {
        super.awakeFromNib()
        //datePickerView.isHidden = true
         datePickerView.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
    }
    @objc func handleDatePicker(_ datePicker: UIDatePicker) {
        let dateString = DateUtil.dateToString(date: datePicker.date, toFormat: DateUtil.dateFormat2)
        updateCallback?(dateString,labelFieldCellIndex)
        self.formItem?.valueCompletion?(dateString)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

extension DatePickerViewTableViewCell: FormUpdatable {
    func update(with formItem: FormItem,isSetCaption:Bool = false) {
        self.formItem = formItem
        if let value = formItem.value{
            if(value != ""){
                    let date = DateUtil.stringToDate(dateString: value, dateFormat: DateUtil.dateFormat2);
                datePickerView.date = date!
            }
        }
    }
}
