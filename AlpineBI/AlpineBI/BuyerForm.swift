//
//  BuyerForm.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 10/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import Foundation
class BuyerForm {
    var formItems = [FormItem]()
    
    var title: String?
    
    var firstname: String?
    var lastname: String?
    var email: String?
    var cellphone: String?
    var phone: String?
    var category: String?
    var notes:String?
    
    init() {
        self.configureItems()
        self.title = "Add Buyer"
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
        let fullNameItem = FormItem(placeholder: "First Name")
        fullNameItem.uiProperties.cellType = FormItemCellType.textField
        fullNameItem.value = self.firstname
        fullNameItem.name = "firstname"
        fullNameItem.valueCompletion = { [weak self, weak fullNameItem] value in
            self?.firstname = value
            fullNameItem?.value = value
        }
        
        // Last Name
        let lastNameItem = FormItem(placeholder: "Last Name")
        lastNameItem.uiProperties.cellType = FormItemCellType.textField
        lastNameItem.value = self.lastname
        lastNameItem.name = "lastname"
        lastNameItem.valueCompletion = { [weak self, weak lastNameItem] value in
            self?.lastname = value
            lastNameItem?.value = value
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
        
        // cell Phone
        let cellPhoneitem = FormItem(placeholder: "Cell Phone")
        cellPhoneitem.uiProperties.cellType = FormItemCellType.textField
        cellPhoneitem.value = self.cellphone
        cellPhoneitem.name = "cellphone"
        cellPhoneitem.valueCompletion = { [weak self, weak cellPhoneitem] value in
            self?.cellphone = value
            cellPhoneitem?.value = value
        }
        
        // Phone
        let phoneItem = FormItem(placeholder: "Phone")
        phoneItem.uiProperties.cellType = FormItemCellType.textField
        phoneItem.value = self.phone
        phoneItem.name = "officephone"
        phoneItem.valueCompletion = { [weak self, weak phoneItem] value in
            self?.phone = value
            phoneItem?.value = value
        }
        
        // Category
        let categoryLabelItem = FormItem(placeholder: "Category")
        categoryLabelItem.uiProperties.cellType = FormItemCellType.labelField
        categoryLabelItem.value = self.category
        categoryLabelItem.name = "category"
        categoryLabelItem.valueCompletion = { [weak self, weak categoryLabelItem] value in
            self?.category = value
            categoryLabelItem?.value = value
        }
        // Category Picker
        let categoryTypePickerItem = FormItem(placeholder: "Category")
        categoryTypePickerItem.uiProperties.cellType = FormItemCellType.pickerView
        categoryTypePickerItem.value = self.category
        categoryTypePickerItem.name = "categorypicker"
        categoryTypePickerItem.isPicker = true
        categoryTypePickerItem.valueCompletion = { [weak self, weak categoryTypePickerItem] value in
            self?.category = value
            categoryTypePickerItem?.value = value
        }
        
        // Notes
        let notesItem = FormItem(placeholder: "Notes")
        notesItem.uiProperties.cellType = FormItemCellType.textField
        notesItem.value = self.notes
        notesItem.name = "notes"
        notesItem.valueCompletion = { [weak self, weak notesItem] value in
            self?.notes = value
            notesItem?.value = value
        }
        
        let saveFromContactItem = FormItem(placeholder: "Save From Contacts")
        saveFromContactItem.uiProperties.cellType = FormItemCellType.buttonView
        saveFromContactItem.value = self.notes
        saveFromContactItem.name = "saveFromContact"
        self.formItems = [fullNameItem, lastNameItem, emailItem,cellPhoneitem,phoneItem,categoryLabelItem,categoryTypePickerItem,notesItem,saveFromContactItem]
    }
}
