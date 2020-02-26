//
//  SpecialProgramForm.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 13/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//
import Foundation
class SpringQuestionForm {
    var formItems = [FormItem]()
    
    var title: String?
    
    var category: String?
    var year: String?
    var issentcataloglink: String?
    var sentcataloglinknotes: String?
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
        self.title = "Spring Question"
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
       
    }
}
