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
  /// Registering methods for all forms items cell types
  ///
  /// - Parameter tableView: TableView where apply cells registration
  static func registerCells(for tableView: UITableView) {
    //tableView.register(FormPickerViewTableViewCell.self,forCellReuseIdentifier: "FormPickerViewTableViewCell")
   // tableView.register(cellType: FormTextViewTableViewCell.self)
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
            let cellIdentifier = "FormPickerViewTableViewCell"
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FormPickerViewTableViewCell
            cell.setPickerViewData(pickerViewData: pickerViewData)
            return cell
        case .textField:
             let cell:FormTextFieldTableViewCell
            let cellIdentifier = "FormTextFieldTableViewCell"
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FormTextFieldTableViewCell
             return cell
        case .labelField:
            let cell:FormLabelFieldTableViewCell
            let cellIdentifier = "FormLabelFieldTableViewCell"
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FormLabelFieldTableViewCell
            return cell
    }
   
  }
}
