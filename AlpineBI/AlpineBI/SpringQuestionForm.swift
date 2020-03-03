//
//  SpecialProgramForm.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 13/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//
import Foundation
class SpringQuestionForm: ObjectConvertor {
    var formItems = [FormItem]()
    
    var title: String?
    
    var isallcategoriesselected: String?
    var category: String?
    var year: String?
    var issentcataloglink: String?
    var sentcataloglinknotes: String?
    var issentsample: String?
    var isstrategicplanningmeeting: String?
    var strategicplanningmeetingdate: String?
    var isinvitedtospringshowroom: String?
    var invitedtospringshowroomdate: String?
    var invitedtospringshowroomreminderdate: String?
    var iscomposhopcompleted: String?
    var iscompshopsummaryemailsent: String?
    var springreviewingdate: String?
    var customerselectingspringitemsfrom: String?
    var ispitchmainvendor: String?
    var pitchmainvendornotes: String?
    var categoriesshouldsellthem: String?
    var issellthrough: String?
    var isrobbyreviewedsellthrough: String?
    var isvisitcustomer2qtr: String?
    var christmasquotebydate: String?
    var isvisitcustomerduring2ndqtr: String?
    var quotespringbydate: String?
    override init() {
        super.init()
        self.configureItems()
    }
    func reload(){
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
//        let isAllCategoriesSelectedItem = FormItem(placeholder: "All")
//        catalogLinkSentNotesItem.uiProperties.cellType = FormItemCellType.textField
//        catalogLinkSentNotesItem.value = self.isallcategoriesselected
//        catalogLinkSentNotesItem.name = "cataloglinksentnotes"
//        catalogLinkSentNotesItem.valueCompletion = { [weak self, weak catalogLinkSentNotesItem] value in
//            self?.cataloglinksentnotes = value
//            catalogLinkSentNotesItem?.value = value
//        }
        
        let categoryItem = FormItem(placeholder: "Select Category")
        categoryItem.uiProperties.cellType = FormItemCellType.selectionView
        categoryItem.value = self.category
        categoryItem.isMultiSelect = true
        categoryItem.name = "category"
        categoryItem.valueCompletion = { [weak self, weak categoryItem] value in
            self?.category = value
            categoryItem?.value = value
        }
        
        let yearItem = FormItem(placeholder: "Data Saving For Year")
        yearItem.uiProperties.cellType = FormItemCellType.selectionView
        yearItem.value = self.year
        yearItem.name = "year"
        yearItem.valueCompletion = { [weak self, weak yearItem] value in
            self?.year = value
            yearItem?.value = value
        }
        
        let isSentCatalogLinkItem = FormItem(placeholder: "Have you sent them Spring catalog link?")
        isSentCatalogLinkItem.uiProperties.cellType = FormItemCellType.yesNoView
        isSentCatalogLinkItem.value = self.issentcataloglink
        isSentCatalogLinkItem.name = "issentcataloglink"
        isSentCatalogLinkItem.valueCompletion = { [weak self, weak isSentCatalogLinkItem] value in
            self?.issentcataloglink = value
            isSentCatalogLinkItem?.value = value
        }
        
        let sentCatalogLinkNotesItem = FormItem(placeholder: "Notes")
        sentCatalogLinkNotesItem.uiProperties.cellType = FormItemCellType.textField
        sentCatalogLinkNotesItem.value = self.sentcataloglinknotes
        sentCatalogLinkNotesItem.name = "sentcataloglinknotes"
        sentCatalogLinkNotesItem.valueCompletion = { [weak self, weak sentCatalogLinkNotesItem] value in
            self?.sentcataloglinknotes = value
            sentCatalogLinkNotesItem?.value = value
        }
        
        let isSentSampleItem = FormItem(placeholder: "Have we sent them any Spring sample?")
        isSentSampleItem.uiProperties.cellType = FormItemCellType.yesNoView
        isSentSampleItem.value = self.issentsample
        isSentSampleItem.name = "issentsample"
        isSentSampleItem.valueCompletion = { [weak self, weak isSentSampleItem] value in
            self?.issentsample = value
            isSentSampleItem?.value = value
        }
        
        let isStrategicPlanningMeetingItem = FormItem(placeholder: "Have we made an appointment for a stragetic planning meeting?")
        isStrategicPlanningMeetingItem.uiProperties.cellType = FormItemCellType.yesNoView
        isStrategicPlanningMeetingItem.value = self.isstrategicplanningmeeting
        isStrategicPlanningMeetingItem.name = "isstrategicplanningmeeting"
        isStrategicPlanningMeetingItem.valueCompletion = { [weak self, weak isStrategicPlanningMeetingItem] value in
            self?.isstrategicplanningmeeting = value
            isStrategicPlanningMeetingItem?.value = value
        }
        
        let strategicPlanningMeetingDateItem = FormItem(placeholder: "If Yes, Date?")
        strategicPlanningMeetingDateItem.uiProperties.cellType = FormItemCellType.selectionView
        strategicPlanningMeetingDateItem.value = self.strategicplanningmeetingdate
        strategicPlanningMeetingDateItem.name = "strategicplanningmeetingdate"
        strategicPlanningMeetingDateItem.isDatePickerView = true
        isStrategicPlanningMeetingItem.valueCompletion = { [weak self, weak strategicPlanningMeetingDateItem] value in
            self?.strategicplanningmeetingdate = value
            strategicPlanningMeetingDateItem?.value = value
        }
        
        let isInvitedToSpringshowroomItem = FormItem(placeholder: "Have we invited them to Spring showroom?")
        isInvitedToSpringshowroomItem.uiProperties.cellType = FormItemCellType.yesNoView
        isInvitedToSpringshowroomItem.value = self.isinvitedtospringshowroom
        isInvitedToSpringshowroomItem.name = "isinvitedtospringshowroom"
        isInvitedToSpringshowroomItem.valueCompletion = { [weak self, weak isInvitedToSpringshowroomItem] value in
            self?.isinvitedtospringshowroom = value
            isInvitedToSpringshowroomItem?.value = value
        }
        
        let invitedToSpringShowroomDateItem = FormItem(placeholder: "If Yes, Date?")
        invitedToSpringShowroomDateItem.uiProperties.cellType = FormItemCellType.selectionView
        invitedToSpringShowroomDateItem.value = self.invitedtospringshowroomdate
        invitedToSpringShowroomDateItem.name = "invitedtospringshowroomdate"
        invitedToSpringShowroomDateItem.isDatePickerView = true
        invitedToSpringShowroomDateItem.valueCompletion = { [weak self, weak invitedToSpringShowroomDateItem] value in
            self?.invitedtospringshowroomdate = value
            invitedToSpringShowroomDateItem?.value = value
        }
        
        let invitedToSpringShowroomReminderDateItem = FormItem(placeholder: "If No, Reminder Date?")
        invitedToSpringShowroomReminderDateItem.uiProperties.cellType = FormItemCellType.selectionView
        invitedToSpringShowroomReminderDateItem.value = self.invitedtospringshowroomreminderdate
        invitedToSpringShowroomReminderDateItem.name = "invitedtospringshowroomreminderdate"
        invitedToSpringShowroomReminderDateItem.isDatePickerView = true
        invitedToSpringShowroomReminderDateItem.valueCompletion = { [weak self, weak invitedToSpringShowroomReminderDateItem] value in
            self?.invitedtospringshowroomreminderdate = value
            invitedToSpringShowroomReminderDateItem?.value = value
        }
        
        let isCompoShopCompletedItem = FormItem(placeholder: "Is Spring 2020 Comp Shop Completed?")
        isCompoShopCompletedItem.uiProperties.cellType = FormItemCellType.yesNoView
        isCompoShopCompletedItem.value = self.iscomposhopcompleted
        isCompoShopCompletedItem.name = "iscomposhopcompleted"
        isCompoShopCompletedItem.valueCompletion = { [weak self, weak isCompoShopCompletedItem] value in
            self?.iscomposhopcompleted = value
            isCompoShopCompletedItem?.value = value
        }
        
        let isCompShopSummaryEmailSentItem = FormItem(placeholder: "Spring 2020 Comp Shop Summary Email sent to SA Team and Robby?")
        isCompShopSummaryEmailSentItem.uiProperties.cellType = FormItemCellType.yesNoView
        isCompShopSummaryEmailSentItem.value = self.iscompshopsummaryemailsent
        isCompShopSummaryEmailSentItem.name = "iscompshopsummaryemailsent"
        isCompShopSummaryEmailSentItem.valueCompletion = { [weak self, weak isCompShopSummaryEmailSentItem] value in
            self?.iscompshopsummaryemailsent = value
            isCompShopSummaryEmailSentItem?.value = value
        }
       
        let springReviewingDateItem = FormItem(placeholder: "When are you reviewing spring 2021?")
        springReviewingDateItem.uiProperties.cellType = FormItemCellType.selectionView
        springReviewingDateItem.value = self.springreviewingdate
        springReviewingDateItem.name = "springreviewingdate"
        springReviewingDateItem.isDatePickerView = true
        springReviewingDateItem.valueCompletion = { [weak self, weak springReviewingDateItem] value in
            self?.springreviewingdate = value
            springReviewingDateItem?.value = value
        }
        
        let customerSelectingSpringItemsfromItem = FormItem(placeholder: "Where is the customer going to select the Spring items?")
        customerSelectingSpringItemsfromItem.uiProperties.cellType = FormItemCellType.textField
        customerSelectingSpringItemsfromItem.value = self.customerselectingspringitemsfrom
        customerSelectingSpringItemsfromItem.name = "customerselectingspringitemsfrom"
        customerSelectingSpringItemsfromItem.valueCompletion = { [weak self, weak customerSelectingSpringItemsfromItem] value in
            self?.customerselectingspringitemsfrom = value
            customerSelectingSpringItemsfromItem?.value = value
        }
        
        let isPitchMainVendorItem = FormItem(placeholder: "Did we pitch that we want to be your main vendor of Holiday and Decor? And my customers are vendor consolidating?")
        isPitchMainVendorItem.uiProperties.cellType = FormItemCellType.yesNoView
        isPitchMainVendorItem.value = self.ispitchmainvendor
        isPitchMainVendorItem.name = "ispitchmainvendor"
        isPitchMainVendorItem.valueCompletion = { [weak self, weak isPitchMainVendorItem] value in
            self?.ispitchmainvendor = value
            isPitchMainVendorItem?.value = value
        }
        
        let pitchMainVendorNotesItem = FormItem(placeholder: "Notes")
        pitchMainVendorNotesItem.uiProperties.cellType = FormItemCellType.textField
        pitchMainVendorNotesItem.value = self.pitchmainvendornotes
        pitchMainVendorNotesItem.name = "pitchmainvendornotes"
        pitchMainVendorNotesItem.valueCompletion = { [weak self, weak pitchMainVendorNotesItem] value in
            self?.pitchmainvendornotes = value
            pitchMainVendorNotesItem?.value = value
        }
        let categoriesShouldSellThemItem = FormItem(placeholder: "What categories have they not bought That I should sell them? Example Bistro Sets")
        categoriesShouldSellThemItem.uiProperties.cellType = FormItemCellType.selectionView
        categoriesShouldSellThemItem.isMultiSelect = true
        categoriesShouldSellThemItem.value = self.categoriesshouldsellthem
        categoriesShouldSellThemItem.name = "categoriesshouldsellthem"
        categoriesShouldSellThemItem.valueCompletion = { [weak self, weak categoriesShouldSellThemItem] value in
            self?.categoriesshouldsellthem = value
            categoriesShouldSellThemItem?.value = value
        }
        
        let isSellThroughItem = FormItem(placeholder: "Are we receiving sell thru if they bought last year?")
        isSellThroughItem.uiProperties.cellType = FormItemCellType.yesNoView
        isSellThroughItem.value = self.issellthrough
        isSellThroughItem.name = "issellthrough"
        isSellThroughItem.valueCompletion = { [weak self, weak isSellThroughItem] value in
            self?.issellthrough = value
            isSellThroughItem?.value = value
        }
        
        let isRobbyReviewedSellThroughItem = FormItem(placeholder: "Have Robby Reviewed Sell through?")
        isRobbyReviewedSellThroughItem.uiProperties.cellType = FormItemCellType.yesNoView
        isRobbyReviewedSellThroughItem.value = self.isrobbyreviewedsellthrough
        isRobbyReviewedSellThroughItem.name = "isrobbyreviewedsellthrough"
        isRobbyReviewedSellThroughItem.valueCompletion = { [weak self, weak isRobbyReviewedSellThroughItem] value in
            self?.isrobbyreviewedsellthrough = value
            isRobbyReviewedSellThroughItem?.value = value
        }
        
        let isVisitCustomer2QtrItem = FormItem(placeholder: "Should I visit this customer during the 2ND qtr to comp shop their spring items?")
        isVisitCustomer2QtrItem.uiProperties.cellType = FormItemCellType.yesNoView
        isVisitCustomer2QtrItem.value = self.isvisitcustomer2qtr
        isVisitCustomer2QtrItem.name = "isvisitcustomer2qtr"
        isVisitCustomer2QtrItem.valueCompletion = { [weak self, weak isVisitCustomer2QtrItem] value in
            self?.isvisitcustomer2qtr = value
            isVisitCustomer2QtrItem?.value = value
        }
        
        let christmasQuoteByDateItem = FormItem(placeholder: "When do we need to quote you christmas by?")
        christmasQuoteByDateItem.uiProperties.cellType = FormItemCellType.selectionView
        christmasQuoteByDateItem.value = self.christmasquotebydate
        christmasQuoteByDateItem.isDatePickerView = true
        christmasQuoteByDateItem.name = "christmasquotebydate"
        christmasQuoteByDateItem.valueCompletion = { [weak self, weak christmasQuoteByDateItem] value in
            self?.christmasquotebydate = value
            christmasQuoteByDateItem?.value = value
        }
        
        let isVisitCustomerDuring2ndQtrItem = FormItem(placeholder: "Should I visit this customer during the 2ND qtr to comp shop their spring items?")
        isVisitCustomerDuring2ndQtrItem.uiProperties.cellType = FormItemCellType.yesNoView
        isVisitCustomerDuring2ndQtrItem.value = self.isvisitcustomerduring2ndqtr
        isVisitCustomerDuring2ndQtrItem.name = "isvisitcustomerduring2ndqtr"
        isVisitCustomerDuring2ndQtrItem.valueCompletion = { [weak self, weak isVisitCustomerDuring2ndQtrItem] value in
            self?.isvisitcustomerduring2ndqtr = value
            isVisitCustomerDuring2ndQtrItem?.value = value
        }
        
        let quoteSpringByDateItem = FormItem(placeholder: "Should I visit this customer during the 2ND qtr to comp shop their spring items?")
        quoteSpringByDateItem.uiProperties.cellType = FormItemCellType.selectionView
        quoteSpringByDateItem.isDatePickerView = true
        quoteSpringByDateItem.value = self.quotespringbydate
        quoteSpringByDateItem.name = "quotespringbydate"
        quoteSpringByDateItem.valueCompletion = { [weak self, weak quoteSpringByDateItem] value in
            self?.quotespringbydate = value
            quoteSpringByDateItem?.value = value
        }
        
        self.formItems = [categoryItem,yearItem,isSentCatalogLinkItem,sentCatalogLinkNotesItem,isSentSampleItem,isStrategicPlanningMeetingItem,strategicPlanningMeetingDateItem,isInvitedToSpringshowroomItem,invitedToSpringShowroomDateItem,invitedToSpringShowroomReminderDateItem,isCompoShopCompletedItem,isCompShopSummaryEmailSentItem,springReviewingDateItem,customerSelectingSpringItemsfromItem,isPitchMainVendorItem,pitchMainVendorNotesItem,categoriesShouldSellThemItem,isSellThroughItem,isRobbyReviewedSellThroughItem,isVisitCustomer2QtrItem,christmasQuoteByDateItem,isVisitCustomerDuring2ndQtrItem,quoteSpringByDateItem]
        
        
        
    }
}
