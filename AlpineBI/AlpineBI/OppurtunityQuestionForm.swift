//
//  OppurtunityQuestionForm.swift
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
class OppurtunityQuestionForm:ObjectConvertor{
    var formItems = [FormItem]()
    var year: String?
    var tradeshowsgoingto: String?
    var isxmascateloglinksent: String?
    var closeoutleftoversincedate: String?
    
    override init() {
        super.init()
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
        let yearItem = FormItem(placeholder: "Data Saving for Year")
        yearItem.uiProperties.cellType = FormItemCellType.selectionView
        yearItem.value = self.year
        yearItem.isLabel = true
        yearItem.name = "year"
        yearItem.valueCompletion = { [weak self, weak yearItem] value in
            self?.year = value
            yearItem?.value = value
        }
        
        let tradeShowsGoInTtoItem = FormItem(placeholder: "What trade shows are they going to in 2021?")
        tradeShowsGoInTtoItem.uiProperties.cellType = FormItemCellType.selectionView
        tradeShowsGoInTtoItem.value = self.tradeshowsgoingto
        tradeShowsGoInTtoItem.name = "tradeshowsgoingto"
        tradeShowsGoInTtoItem.isMultiSelect = true
        tradeShowsGoInTtoItem.isLabel = true
        tradeShowsGoInTtoItem.valueCompletion = { [weak self, weak tradeShowsGoInTtoItem] value in
            self?.tradeshowsgoingto = value
            tradeShowsGoInTtoItem?.value = value
        }
        
        let iscatelogLinkSentitem = FormItem(placeholder: "Have you sent them xmas catalog link?")
        iscatelogLinkSentitem.uiProperties.cellType = FormItemCellType.yesNoView
        iscatelogLinkSentitem.value = self.isxmascateloglinksent
        iscatelogLinkSentitem.name = "isxmascateloglinksent"
        iscatelogLinkSentitem.valueCompletion = { [weak self, weak iscatelogLinkSentitem] value in
            self?.isxmascateloglinksent = value
            iscatelogLinkSentitem?.value = value
        }
        
        let closeOutleftOverSinceDateItem = FormItem(placeholder: "Closeout and left over List Sent Date")
        closeOutleftOverSinceDateItem.uiProperties.cellType = FormItemCellType.selectionView
        closeOutleftOverSinceDateItem.value = self.closeoutleftoversincedate
        closeOutleftOverSinceDateItem.isLabel = true
        closeOutleftOverSinceDateItem.isDatePickerView = true
        closeOutleftOverSinceDateItem.name = "closeoutleftoversincedate"
        closeOutleftOverSinceDateItem.valueCompletion = { [weak self, weak closeOutleftOverSinceDateItem] value in
            self?.closeoutleftoversincedate = value
            closeOutleftOverSinceDateItem?.value = value
        }
        self.formItems = [yearItem, tradeShowsGoInTtoItem, iscatelogLinkSentitem,closeOutleftOverSinceDateItem]
    }
}
