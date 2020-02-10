import Foundation

class Form {
  var formItems = [FormItem]()
  
  var title: String?
  
  var fullname: String?
  var id: String?
  var businesstype: String?
  var salesperson: String?
  var salespersonid: String?
  var priority: String?
  var storename:String?
  var storeid:String?
    
  init() {
    self.configureItems()
    self.title = "Add Customer"
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
    
    // Full Name
    let fullNameItem = FormItem(placeholder: "Full Name")
    fullNameItem.uiProperties.cellType = FormItemCellType.textField
    fullNameItem.value = self.fullname
    fullNameItem.name = "fullname"
    fullNameItem.valueCompletion = { [weak self, weak fullNameItem] value in
      self?.fullname = value
      fullNameItem?.value = value
    }
    
    // ID
    let idItem = FormItem(placeholder: "ID")
    idItem.uiProperties.cellType = FormItemCellType.textField
    idItem.value = self.id
    idItem.name = "customerid"
    idItem.valueCompletion = { [weak self, weak idItem] value in
        self?.id = value
        idItem?.value = value
    }
    
    // Business Type
    let businessTypeItem = FormItem(placeholder: "Business Type")
    businessTypeItem.uiProperties.cellType = FormItemCellType.labelField
    businessTypeItem.value = self.businesstype
    businessTypeItem.name = "businesstype"
    businessTypeItem.valueCompletion = { [weak self, weak businessTypeItem] value in
        self?.businesstype = value
        businessTypeItem?.value = value
    }
    
    let businessTypePickerItem = FormItem(placeholder: "Business Type picker")
    businessTypePickerItem.uiProperties.cellType = FormItemCellType.pickerView
    businessTypePickerItem.value = self.businesstype
    businessTypePickerItem.name = "businesstypepicker"
    businessTypePickerItem.valueCompletion = { [weak self, weak businessTypePickerItem] value in
        self?.businesstype = value
        businessTypePickerItem?.value = value
    }
    
    // Sales Person
    let salesPersonitem = FormItem(placeholder: "Sales Person")
    salesPersonitem.uiProperties.cellType = FormItemCellType.textField
    salesPersonitem.value = self.salesperson
    salesPersonitem.name = "salespersonname"
    salesPersonitem.valueCompletion = { [weak self, weak salesPersonitem] value in
        self?.salesperson = value
        salesPersonitem?.value = value
    }
    
    //Sale Person ID
    let salesPersonIdItem = FormItem(placeholder: "Sale Person ID")
    salesPersonIdItem.uiProperties.cellType = FormItemCellType.textField
    salesPersonIdItem.value = self.salespersonid
    salesPersonIdItem.name = "salespersonid"
    salesPersonIdItem.valueCompletion = { [weak self, weak salesPersonIdItem] value in
        self?.salespersonid = value
        salesPersonIdItem?.value = value
    }
    
    // Priority
    let priorityNameItem = FormItem(placeholder: "Priority")
    priorityNameItem.uiProperties.cellType = FormItemCellType.labelField
    priorityNameItem.value = self.priority
    priorityNameItem.name = "priority"
    priorityNameItem.valueCompletion = { [weak self, weak priorityNameItem] value in
        self?.priority = value
        priorityNameItem?.value = value
    }
    
    let priorityPickerNameItem = FormItem(placeholder: "Priority")
    priorityPickerNameItem.uiProperties.cellType = FormItemCellType.pickerView
    priorityPickerNameItem.value = self.priority
    priorityPickerNameItem.name = "prioritypicker"
    priorityPickerNameItem.valueCompletion = { [weak self, weak priorityPickerNameItem] value in
        self?.priority = value
        priorityPickerNameItem?.value = value
    }
    
    // Store Name
    let storeNameItem = FormItem(placeholder: "Store Name")
    storeNameItem.uiProperties.cellType = FormItemCellType.textField
    storeNameItem.value = self.storename
    storeNameItem.name = "storename"
    storeNameItem.valueCompletion = { [weak self, weak storeNameItem] value in
        self?.storename = value
        storeNameItem?.value = value
    }
    
    //Store ID
    let storeIdItem = FormItem(placeholder: "Store ID")
    storeIdItem.uiProperties.cellType = FormItemCellType.textField
    storeIdItem.value = self.storeid
    storeIdItem.name = "storeid"
    storeIdItem.valueCompletion = { [weak self, weak storeIdItem] value in
        self?.storeid = value
        storeIdItem?.value = value
    }
    
    self.formItems = [fullNameItem, idItem, businessTypeItem,businessTypePickerItem,salesPersonitem,salesPersonIdItem,priorityNameItem,priorityPickerNameItem,storeNameItem,storeIdItem]
  }
}
