//
//  SpecialProgramForm.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 13/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//
import Foundation
class SpecialProgramForm {
    var formItems = [FormItem]()
    var title: String?
    var startdate: String?
    var enddate: String?
    var priceprogram: String?
    var regularterms: String?
    var inseasonterms: String?
    var freight: String?
    var isedicustomer: String?
    var isdefectiveallowancesigned: String?
    var defectivepercent: String?
    var howdefectiveallowancededucted: String?
    var rebateprogramandpaymentmethod: String?
    var howpayingbackcustomer: String?
    var promotionalallowance: String?
    var otherallowance: String?
    var additionalremarks: String?
    var isbackorderaccepted: String?
    init() {
        self.configureItems()
        self.title = "Alpine Special Program"
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
        // Start Date
        let startDateLabelItem = FormItem(placeholder: "Start Date")
        startDateLabelItem.uiProperties.cellType = FormItemCellType.buttonView
        startDateLabelItem.value = self.startdate
        startDateLabelItem.name = "startdate"
        startDateLabelItem.isLabel = true
        startDateLabelItem.valueCompletion = { [weak self, weak startDateLabelItem] value in
            self?.startdate = value
            startDateLabelItem?.value = value
        }
        let startDateItem = FormItem(placeholder: "Start Date")
        startDateItem.uiProperties.cellType = FormItemCellType.datePickerView
        startDateItem.value = self.startdate
        startDateItem.isPicker = true
        startDateItem.name = "startdatepicker"
        startDateItem.valueCompletion = { [weak self, weak startDateItem] value in
            self?.startdate = value
            startDateItem?.value = value
        }
        
        // End Date
        let endDateLabelItem = FormItem(placeholder: "End Date")
        endDateLabelItem.uiProperties.cellType = FormItemCellType.buttonView
        endDateLabelItem.value = self.enddate
        endDateLabelItem.isLabel = true
        endDateLabelItem.name = "enddate"
        endDateLabelItem.valueCompletion = { [weak self, weak endDateLabelItem] value in
            self?.enddate = value
            endDateLabelItem?.value = value
        }
        
        let endDateItem = FormItem(placeholder: "")
        endDateItem.uiProperties.cellType = FormItemCellType.datePickerView
        endDateItem.value = self.enddate
        endDateItem.name = "enddatepicker"
        endDateItem.isPicker = true
        endDateItem.valueCompletion = { [weak self, weak endDateItem] value in
            self?.enddate = value
            endDateItem?.value = value
        }

        // price Program Item
        let priceProgramItem = FormItem(placeholder: "Price Program")
        priceProgramItem.uiProperties.cellType = FormItemCellType.textField
        priceProgramItem.value = self.priceprogram
        priceProgramItem.name = "priceprogram"
        priceProgramItem.valueCompletion = { [weak self, weak priceProgramItem] value in
            self?.priceprogram = value
            priceProgramItem?.value = value
        }
        
        // Regular Terms Label
        let regularTermsLabelItem = FormItem(placeholder: "Regular Terms")
        regularTermsLabelItem.uiProperties.cellType = FormItemCellType.buttonView
        regularTermsLabelItem.value = self.regularterms
        regularTermsLabelItem.name = "regularterms"
        regularTermsLabelItem.isLabel = true
        regularTermsLabelItem.valueCompletion = { [weak self, weak regularTermsLabelItem] value in
            self?.regularterms = value
            regularTermsLabelItem?.value = value
        }
        
        // Regular Terms
        let regularTermsItem = FormItem(placeholder: "")
        regularTermsItem.uiProperties.cellType = FormItemCellType.pickerView
        regularTermsItem.value = self.regularterms
        regularTermsItem.name = "regulartermspicker"
        regularTermsItem.isPicker = true
        regularTermsItem.valueCompletion = { [weak self, weak regularTermsItem] value in
            self?.regularterms = value
            regularTermsItem?.value = value
        }
        
        // InSeason Terms
        let inseasonTerms = FormItem(placeholder: "InSeason Terms")
        inseasonTerms.uiProperties.cellType = FormItemCellType.textField
        inseasonTerms.value = self.inseasonterms
        inseasonTerms.name = "inseasonterms"
        inseasonTerms.valueCompletion = { [weak self, weak inseasonTerms] value in
            self?.inseasonterms = value
            inseasonTerms?.value = value
        }
        
        // Freight Label
        let freightLabelTerms = FormItem(placeholder: "Freight")
        freightLabelTerms.uiProperties.cellType = FormItemCellType.buttonView
        freightLabelTerms.value = self.inseasonterms
        freightLabelTerms.name = "freight"
        freightLabelTerms.isLabel = true
        freightLabelTerms.valueCompletion = { [weak self, weak freightLabelTerms] value in
            self?.freight = value
            freightLabelTerms?.value = value
        }
        // Freight
        let freightTerms = FormItem(placeholder: "")
        freightTerms.uiProperties.cellType = FormItemCellType.pickerView
        freightTerms.value = self.inseasonterms
        freightTerms.name = "freightpicker"
        freightTerms.isPicker = true
        freightTerms.valueCompletion = { [weak self, weak freightTerms] value in
            self?.freight = value
            freightTerms?.value = value
        }
        
        // EDI Customer
        let isEDICustomer = FormItem(placeholder: "EDI Customer")
        isEDICustomer.uiProperties.cellType = FormItemCellType.yesNoView
        isEDICustomer.value = self.isedicustomer
        isEDICustomer.name = "isedicustomer"
        isEDICustomer.valueCompletion = { [weak self, weak isEDICustomer] value in
            self?.isedicustomer = value
            isEDICustomer?.value = value
        }
        
        // Defective Allowance
        let isDefectiveAllowance = FormItem(placeholder: "Defective Allowance")
        isDefectiveAllowance.uiProperties.cellType = FormItemCellType.yesNoView
        isDefectiveAllowance.value = self.isedicustomer
        isDefectiveAllowance.name = "isdefectiveallowancesigned"
        isDefectiveAllowance.valueCompletion = { [weak self, weak isDefectiveAllowance] value in
            self?.isdefectiveallowancesigned = value
            isDefectiveAllowance?.value = value
        }
        
        // Defective %
        let defectivePercent = FormItem(placeholder: "Defective %")
        defectivePercent.uiProperties.cellType = FormItemCellType.textField
        defectivePercent.value = self.defectivepercent
        defectivePercent.name = "defectivepercent"
        defectivePercent.valueCompletion = { [weak self, weak defectivePercent] value in
            self?.defectivepercent = value
            defectivePercent?.value = value
        }
        
       
        let rebateProgramandPaymentMethod = FormItem(placeholder: "Rebate Program and Payment method")
        rebateProgramandPaymentMethod.uiProperties.cellType = FormItemCellType.textField
        rebateProgramandPaymentMethod.value = self.rebateprogramandpaymentmethod
        rebateProgramandPaymentMethod.name = "rebateprogramandpaymentmethod"
        rebateProgramandPaymentMethod.valueCompletion = { [weak self, weak rebateProgramandPaymentMethod] value in
            self?.rebateprogramandpaymentmethod = value
            rebateProgramandPaymentMethod?.value = value
        }
        
        let howPayingBackBustomer = FormItem(placeholder: "Paying back to customer")
        howPayingBackBustomer.uiProperties.cellType = FormItemCellType.textField
        howPayingBackBustomer.value = self.howpayingbackcustomer
        howPayingBackBustomer.name = "howpayingbackcustomer"
        howPayingBackBustomer.valueCompletion = { [weak self, weak howPayingBackBustomer] value in
            self?.howpayingbackcustomer = value
            howPayingBackBustomer?.value = value
        }
        
        
        let defectiveAllowanceLabel = FormItem(placeholder: "Defective Allowance Deductions")
        defectiveAllowanceLabel.uiProperties.cellType = FormItemCellType.buttonView
        defectiveAllowanceLabel.value = self.howdefectiveallowancededucted
        defectiveAllowanceLabel.name = "howdefectiveallowancededucted"
        defectiveAllowanceLabel.isLabel = true
        defectiveAllowanceLabel.valueCompletion = { [weak self, weak defectiveAllowanceLabel] value in
            self?.howdefectiveallowancededucted = value
            defectiveAllowanceLabel?.value = value
        }
        
        let defectiveAllowance = FormItem(placeholder: "")
        defectiveAllowance.uiProperties.cellType = FormItemCellType.pickerView
        defectiveAllowance.value = self.howdefectiveallowancededucted
        defectiveAllowance.name = "howdefectiveallowancedeductedpicker"
        defectiveAllowance.isPicker = true
        defectiveAllowance.valueCompletion = { [weak self, weak defectiveAllowance] value in
            self?.howdefectiveallowancededucted = value
            defectiveAllowance?.value = value
        }
        
        
        let promotionalAllowance = FormItem(placeholder: "Promotional Allowance")
        promotionalAllowance.uiProperties.cellType = FormItemCellType.textField
        promotionalAllowance.value = self.promotionalallowance
        promotionalAllowance.name = "promotionalallowance"
        promotionalAllowance.valueCompletion = { [weak self, weak promotionalAllowance] value in
            self?.promotionalallowance = value
            promotionalAllowance?.value = value
        }
        
        let otherAllowance = FormItem(placeholder: "Other Allowance")
        otherAllowance.uiProperties.cellType = FormItemCellType.textField
        otherAllowance.value = self.otherallowance
        otherAllowance.name = "otherallowance"
        otherAllowance.valueCompletion = { [weak self, weak otherAllowance] value in
            self?.otherallowance = value
            otherAllowance?.value = value
        }
        
        let additionalRemarks = FormItem(placeholder: "Additional Remarks")
        additionalRemarks.uiProperties.cellType = FormItemCellType.textField
        additionalRemarks.value = self.additionalremarks
        additionalRemarks.name = "additionalremarks"
        additionalRemarks.valueCompletion = { [weak self, weak additionalRemarks] value in
            self?.additionalremarks = value
            additionalRemarks?.value = value
        }
        
        let isbackorderAcceptedItem = FormItem(placeholder: "Is back Order Accepted?")
        isbackorderAcceptedItem.uiProperties.cellType = FormItemCellType.yesNoView
        isbackorderAcceptedItem.value = self.isbackorderaccepted
        isbackorderAcceptedItem.name = "isbackorderaccepted"
        isbackorderAcceptedItem.valueCompletion = {[weak self, weak isbackorderAcceptedItem] value in
            self?.isbackorderaccepted = value
            isbackorderAcceptedItem?.value = value
        }
        
        self.formItems = [startDateLabelItem,startDateItem,endDateLabelItem,endDateItem, priceProgramItem,regularTermsLabelItem,regularTermsItem,inseasonTerms,freightLabelTerms,freightTerms,isEDICustomer,isDefectiveAllowance,defectivePercent,rebateProgramandPaymentMethod,howPayingBackBustomer,defectiveAllowanceLabel,defectiveAllowance,promotionalAllowance,otherAllowance,additionalRemarks,isbackorderAcceptedItem]
    }
}
