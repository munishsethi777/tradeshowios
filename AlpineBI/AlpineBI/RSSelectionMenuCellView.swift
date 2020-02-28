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
class RSSelectionMenuCellView: UITableViewCell,DatePickerProtocol {
    
    
    var formItem: FormItem?
    var parentViewController:UIViewController!
    var buttonTappedCallBack : ((_ fieldName: String)-> Void)?
    var dataArray: [String] = [String]()
    var dataKeyValueArray: [String:String] = [:]
    private var selectedValues:[String] = [String]()
    
    @IBAction func crossButtonTapped(_ sender: UIButton) {
        self.buttonView.setTitle(nil, for: .normal)
        self.formItem?.valueCompletion?(nil)
        crossButtonView.isHidden = true
        selectedValues = []
    }
    @IBOutlet weak var crossButtonView: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBOutlet weak var labelField: UILabel!
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    @IBOutlet weak var buttonView: UIButton!
    @IBAction func buttonViewTapped(_ sender: Any) {
        if(formItem?.isDatePickerView ?? false){
            loadDatePicker()
        }else{
            loadMultiSelect()
        }
    }
    
    func setDate(valueSent: String){
        self.buttonView.setTitle(valueSent, for: .normal)
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
        selectionMenu.show(style: .push, from: parentViewController)
        selectionMenu.onDismiss = { [weak self] selectedItems in
            self?.selectedValues = selectedItems
            let selectedValue = self?.selectedValues.joined(separator: ",")
            self?.buttonView.setTitle(selectedValue, for: .normal)
            self?.formItem?.valueCompletion?(selectedValue)
            self!.crossButtonView.isHidden = true
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
        parentViewController.navigationController?.pushViewController(viewController, animated: true)
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
}

extension RSSelectionMenuCellView: FormUpdatable {
    func update(with formItem: FormItem,isSetCaption:Bool = false) {
        self.formItem = formItem
        if(self.formItem != nil){
            if(isSetCaption){
                labelField.text = self.formItem?.placeholder
                buttonView.setTitleColor(.black, for: .normal)
            }
            buttonView.setTitle(self.formItem?.value, for: .normal)
            self.crossButtonView.isHidden = true
            if let value = self.formItem?.value {
                if(!value.isEmpty){
                    selectedValues = value.components(separatedBy: ",")
                    self.crossButtonView.isHidden = false
                }
            }
        }
    }
}
