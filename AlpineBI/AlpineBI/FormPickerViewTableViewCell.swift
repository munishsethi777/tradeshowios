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
    
    @IBOutlet weak var pickerView: UIPickerView!
    override func awakeFromNib() {
        super.awakeFromNib()
        //pickerData = [:]
        //pickerDataLabel = []
    }
    

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
       updateCallback?(key,labelFieldCellIndex)
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
    func getSelectedPickerViewValueByKey(selectedKey:String)->String{
        for (key, value) in pickerData {
            if(key == selectedKey){
                return value
            }
        }
        return ""
    }
    
    func getIndexOfKey(selectedValue:String)->Int{
        var i = 0;
        for (value) in pickerDataLabel {
            if(value == selectedValue){
                return i
            }
            i = i + 1
        }
        return 0
    }
    
    func setPickerViewData(pickerViewData:[String:String]){
        pickerData = [:]
        pickerData = pickerViewData
        pickerDataLabel = []
        for (_, value) in pickerViewData {
            if(value != "Select Any"){
                pickerDataLabel.append(value)
            }
        }
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerDataLabel = pickerDataLabel.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
        pickerDataLabel.insert("Select Any", at: 0)
    }
}

// MARK: - FormUpdatable
extension FormPickerViewTableViewCell: FormUpdatable {
    func update(with formItem: FormItem,isSetCaption:Bool = false) {
       self.formItem = formItem
       self.pickerView.tintColor = .white
        if(formItem.value != nil){
            if let value = pickerData[formItem.value!] {
                let keyIndex = getIndexOfKey(selectedValue: value)
                pickerView.selectRow(keyIndex, inComponent: 0, animated: true)
                self.pickerView(self.pickerView, didSelectRow: keyIndex, inComponent: 0)
            }
        }
    }
}
