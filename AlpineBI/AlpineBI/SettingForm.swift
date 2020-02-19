//
//  SettingForm.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 12/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//
//
//  BuyerForm.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 10/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import Foundation
class SettingForm {
    var formItems = [FormItem]()
    
    var title: String?
    
    var fullname: String?
    var email: String?
    var mobile: String?
    var usertimezone: String?
    
    init() {
        self.configureItems()
        self.title = "Settings"
    }
    
    // MARK: Form Validation
    @discardableResult
    func isValid() -> (Bool, String?) {
        
        var isValid = true
        for item in self.formItems {
            item.checkValidity()
            if !item.isValid {
                isValid = false
            }
        }
        return (isValid, nil)
    }
    
    /// Prepare all form Items ViewModels for the DirectStudioForm
    private func configureItems() {
        // first Name
        let fullNameItem = FormItem(placeholder: "Full Name")
        fullNameItem.uiProperties.cellType = FormItemCellType.textField
        fullNameItem.value = self.fullname
        fullNameItem.name = "fullname"
        fullNameItem.valueCompletion = { [weak self, weak fullNameItem] value in
            self?.fullname = value
            fullNameItem?.value = value
        }
        
        // Email
        let emailItem = FormItem(placeholder: "Email")
        emailItem.uiProperties.cellType = FormItemCellType.textField
        emailItem.value = self.email
        emailItem.name = "email"
        emailItem.valueCompletion = { [weak self, weak emailItem] value in
            self?.email = value
            emailItem?.value = value
        }
        
        // mobile
        let mobileitem = FormItem(placeholder: "Mobile")
        mobileitem.uiProperties.cellType = FormItemCellType.textField
        mobileitem.value = self.mobile
        mobileitem.name = "mobile"
        mobileitem.valueCompletion = { [weak self, weak mobileitem] value in
            self?.mobile = value
            mobileitem?.value = value
        }
        
        // TimeZone
        let timezoneLabelItem = FormItem(placeholder: "Time Zone")
        timezoneLabelItem.uiProperties.cellType = FormItemCellType.buttonView
        timezoneLabelItem.value = self.usertimezone
        timezoneLabelItem.name = "usertimezone"
        timezoneLabelItem.valueCompletion = { [weak self, weak timezoneLabelItem] value in
            self?.usertimezone = value
            timezoneLabelItem?.value = value
        }
        // Time Zone
        let timezoneItem = FormItem(placeholder: "Time Zone")
        timezoneItem.uiProperties.cellType = FormItemCellType.pickerView
        timezoneItem.value = self.usertimezone
        timezoneItem.name = "usertimezonepicker"
        timezoneItem.isPicker = true
        timezoneItem.valueCompletion = { [weak self, weak timezoneItem] value in
            self?.usertimezone = value
            timezoneItem?.value = value
        }
        self.formItems = [fullNameItem, emailItem, mobileitem,timezoneLabelItem,timezoneItem]
    }
}
