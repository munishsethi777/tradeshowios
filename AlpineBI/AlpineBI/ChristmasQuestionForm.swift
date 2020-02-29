//
//  SpecialProgramForm.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 13/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//
import Foundation
class ChristmasQuestionForm {
    var formItems = [FormItem]()
    var year: String?
    var isinterested: String?
    var iscataloglinksent: String?
    var cataloglinksentnotes: String?
    var isxmassamplessent: String?
    var isstrategicplanningmeetingappointment: String?
    var strategicplanningmeetdate: String?
    var isinvitedtoxmasshowroom: String?
    var invitedtoxmasshowroomdate: String?
    var invitedtoxmasshowroomreminderdate: String?
    var isholidayshopcompleted: String?
    var isholidayshopcomsummaryemailsent: String?
    var christmas2020reviewingdate: String?
    var customerselectxmasitemsfrom: String?
    var ismainvendor: String?
    var mainvendornotes: String?
    var isxmasbuylastyear: String?
    var xmasbuylastyearamount: String?
    var isreceivingsellthru: String?
    var isrobbyreviewedsellthrough: String?
    var isvisitcustomerin4qtr: String?
    var christmasquotebydate: String?
    init() {
        self.configureItems()
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
        let yearLabelItem = FormItem(placeholder: "Data Saving for Year")
        yearLabelItem.uiProperties.cellType = FormItemCellType.selectionView
        yearLabelItem.value = self.year
        yearLabelItem.name = "year"
        yearLabelItem.isLabel = true
        yearLabelItem.valueCompletion = { [weak self, weak yearLabelItem] value in
            self?.year = value
            yearLabelItem?.value = value
        }
    
        
        let isIntrestedtem = FormItem(placeholder: "Are you Interested in Christmas?")
        isIntrestedtem.uiProperties.cellType = FormItemCellType.yesNoView
        isIntrestedtem.value = self.isinterested
        isIntrestedtem.name = "isinterested"
        isIntrestedtem.valueCompletion = { [weak self, weak isIntrestedtem] value in
            self?.isinterested = value
            isIntrestedtem?.value = value
        }

        let catelogLinkSentItem = FormItem(placeholder: "Have you sent them xmas catalog link?")
        catelogLinkSentItem.uiProperties.cellType = FormItemCellType.yesNoView
        catelogLinkSentItem.value = self.iscataloglinksent
        catelogLinkSentItem.name = "iscataloglinksent"
        catelogLinkSentItem.valueCompletion = { [weak self, weak catelogLinkSentItem] value in
            self?.iscataloglinksent = value
            catelogLinkSentItem?.value = value
        }
        
        let catalogLinkSentNotesItem = FormItem(placeholder: "Notes")
        catalogLinkSentNotesItem.uiProperties.cellType = FormItemCellType.textField
        catalogLinkSentNotesItem.value = self.cataloglinksentnotes
        catalogLinkSentNotesItem.name = "cataloglinksentnotes"
        catalogLinkSentNotesItem.valueCompletion = { [weak self, weak catalogLinkSentNotesItem] value in
            self?.cataloglinksentnotes = value
            catalogLinkSentNotesItem?.value = value
        }
        
        let isXmassamplessentItem = FormItem(placeholder: "Have we sent them Any xmas sample")
        isXmassamplessentItem.uiProperties.cellType = FormItemCellType.yesNoView
        isXmassamplessentItem.value = self.isxmassamplessent
        isXmassamplessentItem.name = "isxmassamplessent"
        isXmassamplessentItem.valueCompletion = { [weak self, weak isXmassamplessentItem] value in
            self?.isxmassamplessent = value
            isXmassamplessentItem?.value = value
        }
        
        let isStrategicPlanningMeetingAppointmentItem = FormItem(placeholder: "Have we made an appt for a stragetic planning meeting")
        isStrategicPlanningMeetingAppointmentItem.uiProperties.cellType = FormItemCellType.yesNoView
        isStrategicPlanningMeetingAppointmentItem.value = self.isstrategicplanningmeetingappointment
        isStrategicPlanningMeetingAppointmentItem.name = "isstrategicplanningmeetingappointment"
        isStrategicPlanningMeetingAppointmentItem.valueCompletion = { [weak self, weak isStrategicPlanningMeetingAppointmentItem] value in
            self?.isstrategicplanningmeetingappointment = value
            isStrategicPlanningMeetingAppointmentItem?.value = value
        }
      
        let strategicPlanningMeetDateLabel = FormItem(placeholder: "If Yes, Date?")
        strategicPlanningMeetDateLabel.uiProperties.cellType = FormItemCellType.selectionView
        strategicPlanningMeetDateLabel.value = self.strategicplanningmeetdate
        strategicPlanningMeetDateLabel.name = "strategicplanningmeetdate"
        strategicPlanningMeetDateLabel.isLabel = true
        strategicPlanningMeetDateLabel.isDatePickerView = true
        strategicPlanningMeetDateLabel.valueCompletion = { [weak self, weak strategicPlanningMeetDateLabel] value in
            self?.strategicplanningmeetdate = value
            strategicPlanningMeetDateLabel?.value = value
        }
        
        let isInvitedtoXmasShowroomItem = FormItem(placeholder: "Have we invited them to xmas showroom?")
        isInvitedtoXmasShowroomItem.uiProperties.cellType = FormItemCellType.yesNoView
        isInvitedtoXmasShowroomItem.value = self.isinvitedtoxmasshowroom
        isInvitedtoXmasShowroomItem.name = "isinvitedtoxmasshowroom"
        isInvitedtoXmasShowroomItem.valueCompletion = { [weak self, weak isInvitedtoXmasShowroomItem] value in
            self?.isinvitedtoxmasshowroom = value
            isInvitedtoXmasShowroomItem?.value = value
        }
        
        let invitedToXmasShowroomDateLabelItem = FormItem(placeholder: "If Yes, Date?")
        invitedToXmasShowroomDateLabelItem.uiProperties.cellType = FormItemCellType.selectionView
        invitedToXmasShowroomDateLabelItem.value = self.invitedtoxmasshowroomdate
        invitedToXmasShowroomDateLabelItem.name = "invitedtoxmasshowroomdate"
        invitedToXmasShowroomDateLabelItem.isLabel = true
        invitedToXmasShowroomDateLabelItem.isDatePickerView = true
        invitedToXmasShowroomDateLabelItem.valueCompletion = {[weak self, weak invitedToXmasShowroomDateLabelItem] value in
            self?.invitedtoxmasshowroomdate = value
            invitedToXmasShowroomDateLabelItem?.value = value
        }
        
        
        let invitedToXmasShowroomReminderDateLabelItem = FormItem(placeholder: "No, Reminder Date?")
        invitedToXmasShowroomReminderDateLabelItem.uiProperties.cellType = FormItemCellType.selectionView
        invitedToXmasShowroomReminderDateLabelItem.value = self.invitedtoxmasshowroomreminderdate
        invitedToXmasShowroomReminderDateLabelItem.name = "invitedtoxmasshowroomreminderdate"
        invitedToXmasShowroomReminderDateLabelItem.isLabel = true
        invitedToXmasShowroomReminderDateLabelItem.isDatePickerView = true
        invitedToXmasShowroomReminderDateLabelItem.valueCompletion = { [weak self, weak invitedToXmasShowroomReminderDateLabelItem] value in
            self?.invitedtoxmasshowroomreminderdate = value
            invitedToXmasShowroomReminderDateLabelItem?.value = value
        }
        
        let isHolidayShopCompletedItem = FormItem(placeholder: "Holiday 2019 Comp Shop Completed?")
        isHolidayShopCompletedItem.uiProperties.cellType = FormItemCellType.yesNoView
        isHolidayShopCompletedItem.value = self.isholidayshopcompleted
        isHolidayShopCompletedItem.name = "isholidayshopcompleted"
        isHolidayShopCompletedItem.valueCompletion = { [weak self, weak isHolidayShopCompletedItem] value in
            self?.isholidayshopcompleted = value
            isHolidayShopCompletedItem?.value = value
        }
        
        let isHolidayShopcomSummaryEmailSentItem = FormItem(placeholder: "Holiday 2019 Comp Shop Summary Email sent to SA Team and Robby?")
        isHolidayShopcomSummaryEmailSentItem.uiProperties.cellType = FormItemCellType.yesNoView
        isHolidayShopcomSummaryEmailSentItem.value = self.isholidayshopcomsummaryemailsent
        isHolidayShopcomSummaryEmailSentItem.name = "isholidayshopcomsummaryemailsent"
        isHolidayShopcomSummaryEmailSentItem.valueCompletion = { [weak self, weak isHolidayShopcomSummaryEmailSentItem] value in
            self?.isholidayshopcomsummaryemailsent = value
            isHolidayShopcomSummaryEmailSentItem?.value = value
        }
        
        
        let christmas2020ReviewingDateLabelItem = FormItem(placeholder: "When are you reviewing christmas 2020")
        christmas2020ReviewingDateLabelItem.uiProperties.cellType = FormItemCellType.selectionView
        christmas2020ReviewingDateLabelItem.value = self.christmas2020reviewingdate
        christmas2020ReviewingDateLabelItem.name = "christmas2020reviewingdate"
        christmas2020ReviewingDateLabelItem.isDatePickerView = true
        christmas2020ReviewingDateLabelItem.isLabel = true
        christmas2020ReviewingDateLabelItem.valueCompletion = { [weak self, weak christmas2020ReviewingDateLabelItem] value in
            self?.christmas2020reviewingdate = value
            christmas2020ReviewingDateLabelItem?.value = value
        }
        
        let customerSelectXmasItemsFromLabelItem = FormItem(placeholder: "Where is the customer going to select the xmas items?")
        customerSelectXmasItemsFromLabelItem.uiProperties.cellType = FormItemCellType.selectionView
        customerSelectXmasItemsFromLabelItem.value = self.customerselectxmasitemsfrom
        customerSelectXmasItemsFromLabelItem.name = "customerselectxmasitemsfrom"
        customerSelectXmasItemsFromLabelItem.isLabel = true
        customerSelectXmasItemsFromLabelItem.valueCompletion = { [weak self, weak customerSelectXmasItemsFromLabelItem] value in
            self?.customerselectxmasitemsfrom = value
            customerSelectXmasItemsFromLabelItem?.value = value
        }
        
       

        let isMainVendorItem = FormItem(placeholder: "Did we pitch that we want to be your main vendor of Holiday and Décor? And my customers are vendor consolidating?")
        isMainVendorItem.uiProperties.cellType = FormItemCellType.yesNoView
        isMainVendorItem.value = self.ismainvendor
        isMainVendorItem.name = "ismainvendor"
        isMainVendorItem.valueCompletion = { [weak self, weak isMainVendorItem] value in
            self?.ismainvendor = value
            isMainVendorItem?.value = value
        }
        
        let mainVendorNotesItem = FormItem(placeholder: "Notes")
        mainVendorNotesItem.uiProperties.cellType = FormItemCellType.textField
        mainVendorNotesItem.value = self.mainvendornotes
        mainVendorNotesItem.name = "mainvendornotes"
        mainVendorNotesItem.valueCompletion = { [weak self, weak mainVendorNotesItem] value in
            self?.mainvendornotes = value
            mainVendorNotesItem?.value = value
        }
        
        let isXmasBuyLastYearItem = FormItem(placeholder: "Did they buy xmas last year?")
        isXmasBuyLastYearItem.uiProperties.cellType = FormItemCellType.yesNoView
        isXmasBuyLastYearItem.value = self.isxmasbuylastyear
        isXmasBuyLastYearItem.name = "isxmasbuylastyear"
        isXmasBuyLastYearItem.valueCompletion = { [weak self, weak isXmasBuyLastYearItem] value in
            self?.isxmasbuylastyear = value
            isXmasBuyLastYearItem?.value = value
        }
        
        let xmasbuylastyearamountItem = FormItem(placeholder: "If Yes, How Much?")
        xmasbuylastyearamountItem.uiProperties.cellType = FormItemCellType.textField
        xmasbuylastyearamountItem.value = self.xmasbuylastyearamount
        xmasbuylastyearamountItem.name = "xmasbuylastyearamount"
        xmasbuylastyearamountItem.valueCompletion = { [weak self, weak xmasbuylastyearamountItem] value in
            self?.xmasbuylastyearamount = value
            xmasbuylastyearamountItem?.value = value
        }
        
        let isReceivingSellThruItem  = FormItem(placeholder: "Are we receiving sell thru if they bought last year?")
        isReceivingSellThruItem.uiProperties.cellType = FormItemCellType.yesNoView
        isReceivingSellThruItem.value = self.isreceivingsellthru
        isReceivingSellThruItem.name = "isreceivingsellthru"
        isReceivingSellThruItem.valueCompletion = { [weak self, weak isReceivingSellThruItem] value in
            self?.isreceivingsellthru = value
            isReceivingSellThruItem?.value = value
        }
        
        let isrobbyreviewedsellthroughItem  = FormItem(placeholder: "Have Robby Reviewed Sell through?")
        isrobbyreviewedsellthroughItem.uiProperties.cellType = FormItemCellType.yesNoView
        isrobbyreviewedsellthroughItem.value = self.isrobbyreviewedsellthrough
        isrobbyreviewedsellthroughItem.name = "isrobbyreviewedsellthrough"
        isrobbyreviewedsellthroughItem.valueCompletion = { [weak self, weak isrobbyreviewedsellthroughItem] value in
            self?.isrobbyreviewedsellthrough = value
            isrobbyreviewedsellthroughItem?.value = value
        }
        
        let isvisitcustomerin4qtrItem  = FormItem(placeholder: "Should i visit this customer during the 4th qtr to comp shop their xmas items?")
        isvisitcustomerin4qtrItem.uiProperties.cellType = FormItemCellType.yesNoView
        isvisitcustomerin4qtrItem.value = self.isvisitcustomerin4qtr
        isvisitcustomerin4qtrItem.name = "isvisitcustomerin4qtr"
        isvisitcustomerin4qtrItem.valueCompletion = { [weak self, weak isvisitcustomerin4qtrItem] value in
            self?.isvisitcustomerin4qtr = value
            isvisitcustomerin4qtrItem?.value = value
        }
        let christmasquotebydateLabelItem  = FormItem(placeholder: "When do we need to quote you christmas by?")
        christmasquotebydateLabelItem.uiProperties.cellType = FormItemCellType.buttonView
        christmasquotebydateLabelItem.value = self.christmasquotebydate
        christmasquotebydateLabelItem.isLabel = true
        christmasquotebydateLabelItem.isDatePickerView = true
        christmasquotebydateLabelItem.name = "christmasquotebydate"
        christmasquotebydateLabelItem.valueCompletion = { [weak self, weak christmasquotebydateLabelItem] value in
            self?.christmasquotebydate = value
            christmasquotebydateLabelItem?.value = value
        }
        
        self.formItems = [yearLabelItem,isIntrestedtem,catelogLinkSentItem,catalogLinkSentNotesItem,isXmassamplessentItem,isStrategicPlanningMeetingAppointmentItem,strategicPlanningMeetDateLabel,isInvitedtoXmasShowroomItem,invitedToXmasShowroomDateLabelItem,invitedToXmasShowroomReminderDateLabelItem,isHolidayShopCompletedItem,isHolidayShopcomSummaryEmailSentItem,christmas2020ReviewingDateLabelItem,customerSelectXmasItemsFromLabelItem,isMainVendorItem,mainVendorNotesItem,isXmasBuyLastYearItem,xmasbuylastyearamountItem,isReceivingSellThruItem,isrobbyreviewedsellthroughItem,christmasquotebydateLabelItem,isvisitcustomerin4qtrItem]
    }
    
    func toArray() -> [String:Any]{
        let mirrored_object = Mirror(reflecting: self)
        var arr:[String:Any] = [:]
        for (_, attr) in mirrored_object.children.enumerated() {
            if let property_name = attr.label {
                var value = attr.value as? String
                if(property_name == "formItems"){
                    continue
                }
                if(property_name.hasSuffix("date")){
                    let dateStr = DateUtil.convertToFormat(dateString: value, fromFomat: DateUtil.dateFormat2, toFormat: DateUtil.dateFormat3)
                    value = dateStr
                }
                if(property_name.hasPrefix("is")){
                    let boolVal = value == "Yes" ? "1" : "0"
                    value = boolVal
                }
                arr[property_name] = value
            }
        }
        return arr
    }
    
//    func toObject(dataArr:[String:Any]){
//        let mirrored_object = Mirror(reflecting: self)
//        var arr:[String:Any] = [:]
//        for (_, attr) in mirrored_object.children.enumerated() {
//            if let property_name = attr.label {
//                var value = attr.value as? String
//                if(property_name == "formItems"){
//                    continue
//                }
//                if(property_name.hasSuffix("date")){
//                    let dateStr = DateUtil.convertToFormat(dateString: value, fromFomat: DateUtil.dateFormat2, toFormat: DateUtil.dateFormat3)
//                    value = dateStr
//                }
//                if(property_name.hasPrefix("is")){
//                    let boolVal = value == "Yes" ? "1" : "0"
//                    value = boolVal
//                }
//                arr[property_name] = value
//            }
//        }
//        return arr
//    }
}
