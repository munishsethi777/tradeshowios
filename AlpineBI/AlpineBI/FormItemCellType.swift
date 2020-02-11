import Foundation
import UIKit

/// Conform receiver to have data validation behavior
protocol FormValidable {
  var isValid: Bool {get set}
  var isMandatory: Bool {get set}
  func checkValidity()
}

/// Conform the view receiver to be updated with a form item
protocol FormUpdatable {
  func update(with formItem: FormItem)
}

/// Conform receiver to have a form item property
protocol FormConformity {
  var formItem: FormItem? {get set}
}

/// UI Cell Type to be displayed
enum FormItemCellType {
  case textField
  case pickerView
  case labelField
  case buttonView
  /// Registering methods for all forms items cell types
  ///
  /// - Parameter tableView: TableView where apply cells registration
  static func registerCells(for tableView: UITableView) {
    let nib = UINib.init(nibName: "MyCustomCell", bundle: nil)
    tableView.register(nib, forCellReuseIdentifier: "MyCustomCell")
    let nib1 = UINib.init(nibName: "LabelViewCell", bundle: nil)
    tableView.register(nib1, forCellReuseIdentifier: "LabelViewCell")
    let nib2 = UINib.init(nibName: "PickerViewCell", bundle: nil)
    tableView.register(nib2, forCellReuseIdentifier: "PickerViewCell")
    let nib3 = UINib.init(nibName: "ButtonViewCell", bundle: nil)
    tableView.register(nib3, forCellReuseIdentifier: "ButtonViewCell")
  }
  
  /// Correctly dequeue the UITableViewCell according to the current cell type
  ///
  /// - Parameters:
  ///   - tableView: TableView where cells previously registered
  ///   - indexPath: indexPath where dequeue
  /// - Returns: a non-nullable UITableViewCell dequeued
    func dequeueCell(for tableView: UITableView, at indexPath: IndexPath,pickerViewData:[String:String]) -> UITableViewCell {
    //let cell:UITableViewCell
    switch self {
        case .pickerView:
            let cell:FormPickerViewTableViewCell
            let cellIdentifier = "PickerViewCell"
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FormPickerViewTableViewCell
            cell.setPickerViewData(pickerViewData: pickerViewData)
            return cell
        case .textField:
             let cell:FormTextFieldTableViewCell
            let cellIdentifier = "MyCustomCell"
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FormTextFieldTableViewCell
             return cell
        case .labelField:
            let cell:FormLabelFieldTableViewCell
            let cellIdentifier = "LabelViewCell"
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FormLabelFieldTableViewCell
            return cell
        case .buttonView:
            let cell:FormButtonViewTableViewCell
            let cellIdentifier = "ButtonViewCell"
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FormButtonViewTableViewCell
            return cell
    }
   
  }
}
