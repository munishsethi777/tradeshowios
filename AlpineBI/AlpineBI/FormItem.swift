/// ViewModel to display and react to text events, to update data
import UIKit
class FormItem: FormValidable {
    
    var value: String?
    var placeholder = ""
    var indexPath: IndexPath?
    var name:String?
    var valueCompletion: ((String?) -> Void)?
    
    var isMandatory = true
    var isPicker = false
    var isLabel = false
    var isButtonOnly = false
    var color:UIColor?
    var isValid = true //FormValidable
    var isMultiSelect = false
    var isDatePickerView = false
    var uiProperties = FormItemUIProperties()
    
    // MARK: Init
    init(placeholder: String, value: String? = nil,name: String? = nil) {
        self.placeholder = placeholder
        self.value = value
        self.name = name
    }
    
    // MARK: FormValidable
    func checkValidity() {
        if self.isMandatory {
            self.isValid = self.value != nil && self.value?.isEmpty == false
        } else {
            self.isValid = true
        }
    }
}
