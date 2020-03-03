//
//  ButtonViewCell.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 11/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import UIKit
import ContactsUI
import RSSelectionMenu
class RSSelectionMenuCellView: UITableViewCell,DatePickerProtocol,CustomCell {
    var delegate: CallBackProtocol!
    var parent: UIViewController!
    var formItem: FormItem?
    var buttonTappedCallBack : ((_ fieldName: String)-> Void)?
    var dataArray: [String] = [String]()
    var dataKeyValueArray: [String:String] = [:]
    var indexPath: IndexPath!
    private var selectedValues:[String] = [String]()
   
    @IBOutlet weak var detailLabel: UILabel!
    @IBAction func crossButtonTapped(_ sender: UIButton) {
        detailLabel.text = nil
        self.formItem?.valueCompletion?(nil)
        crossButtonView.isHidden = true
        selectedValues = []
        self.delegate.updateValue(valueSent: "", indexPath: indexPath)
    }
    @IBOutlet weak var crossButtonView: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        parent = UIViewController()
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapFunction))
        detailLabel.isUserInteractionEnabled = true
        detailLabel.addGestureRecognizer(tap)
    }
    
    @objc
    func tapFunction(sender:UITapGestureRecognizer) {
        if(formItem?.isDatePickerView ?? false){
            loadDatePicker()
        }else{
            loadMultiSelect()
        }
    }

    @IBOutlet weak var labelField: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setDate(valueSent: String){
        detailLabel.text = valueSent
        self.formItem?.valueCompletion?(valueSent)
        self.crossButtonView.isHidden = false
    }
    
    func loadMultiSelect(){
        var selectionMenu = RSSelectionMenu(selectionStyle: .single, dataSource: dataArray) { (cell, item, indexPath) in
            cell.textLabel?.text = item
        }
        if(formItem?.isMultiSelect ?? false){
            selectionMenu = RSSelectionMenu(selectionStyle: .multiple, dataSource: dataArray) { (cell, item, indexPath) in
                cell.textLabel?.text = item
            }
        }
        selectionMenu.setSelectedItems(items: selectedValues) { [weak self] (item, index, isSelected, selectedItems) in
              self?.selectedValues = selectedItems
        }
        selectionMenu.show(style: .push, from: parent)
        selectionMenu.onDismiss = { [weak self] selectedItems in
            self?.selectedValues = selectedItems
            let selectedValue = self?.selectedValues.joined(separator: StringConstants.SEPRATOR)
            self?.detailLabel.text = selectedValue
            self?.formItem?.valueCompletion?(selectedValue)
            self!.crossButtonView.isHidden = true
            self!.delegate.updateValue(valueSent: selectedValue!, indexPath: self!.indexPath)
            if(selectedValue != nil && !selectedValue!.isEmpty){
                self!.crossButtonView.isHidden = false
            }
        }
    }
    
    func loadDatePicker(){
        let viewController:DatePickerViewController = UIStoryboard(name: "LaunchScreen", bundle: nil).instantiateViewController(withIdentifier: "datePickerControl") as! DatePickerViewController
        let selectedDateStr = self.formItem?.value
        viewController.selectedDate = selectedDateStr
        viewController.delegate = self
        parent.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func setMenuData(menuData:[String:String]){
        dataKeyValueArray = [:]
        dataKeyValueArray = menuData
        dataArray = []
        for (_, value) in menuData {
            dataArray.append(value)
        }
        dataArray = dataArray.sorted { $0.localizedCaseInsensitiveCompare($1) == ComparisonResult.orderedAscending }
    }
//    func setSelectedValue(value:String?){
//        if let selectedValueStr = value{
//            let selctedValuesArr = selectedValueStr.components(separatedBy: ",")
//            if(formItem?.isDatePickerView ?? false){
//                selectedValues = selctedValuesArr
//            }else{
//                for value in selctedValuesArr {
//                    selectedValues.append(dataKeyValueArray[value]!)
//                }
//            }
//            let valueStr = selectedValues.joined(separator: ",")
//            detailLabel.text = valueStr
//        }
//    }
}

extension RSSelectionMenuCellView: FormUpdatable {
    func update(with formItem: FormItem,isSetCaption:Bool = false) {
        self.formItem = formItem
        if(self.formItem != nil){
            labelField.text = self.formItem?.placeholder
            detailLabel.text = self.formItem?.value
            self.crossButtonView.isHidden = true
            if let value = self.formItem?.value {
                if(!value.isEmpty){
                    selectedValues = value.components(separatedBy:StringConstants.SEPRATOR)
                    //setSelectedValue(value:value)
                    self.crossButtonView.isHidden = false
                }
            }
        }
    }
}
