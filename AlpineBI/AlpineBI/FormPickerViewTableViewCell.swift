//
//  FormPickerViewTableViewCell.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 05/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//
import Foundation
import UIKit
class FormPickerViewTableViewCell :UITableViewCell, FormConformity,UIPickerViewDelegate,UIPickerViewDataSource {
    var formItem: FormItem?
    var labelFieldCellIndex: IndexPath!
    var updateCallback : ((_ selectedValue: String,_ indexPath: IndexPath)-> Void)?
    var pickerDataLabel: [String] = [String]()
    var pickerData: [String:String] = [:]
    override func awakeFromNib() {
        super.awakeFromNib()
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    @IBOutlet weak var pickerView: UIPickerView!
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1;
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       var value = pickerDataLabel[row]
       let key = getSelectedPickerViewValue(selectedValue: value)
       if(key == ""){
            value = key
       }
       updateCallback?(value,labelFieldCellIndex)
       self.formItem?.valueCompletion?(key)
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel;
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name:"Helvetica",size: 14.0)
            pickerLabel?.textAlignment = NSTextAlignment.center
        }
        pickerLabel?.text = self.pickerDataLabel[row]
        return pickerLabel!
    }
    
    func getSelectedPickerViewValue(selectedValue:String)->String{
        for (key, value) in pickerData {
            if(value == selectedValue){
                return key
            }
        }
        return ""
    }
    
    func setPickerViewData(pickerViewData:[String:String]){
        pickerData = pickerViewData
        for (_, value) in pickerViewData {
            if(value != "Select Any"){
                pickerDataLabel.append(value)
            }
        }
        pickerDataLabel = pickerDataLabel.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        pickerDataLabel.insert("Select Any", at: 0)
    }
}

// MARK: - FormUpdatable
extension FormPickerViewTableViewCell: FormUpdatable {
    func update(with formItem: FormItem) {
       self.formItem = formItem
       self.pickerView.tintColor = .white
    }
}
