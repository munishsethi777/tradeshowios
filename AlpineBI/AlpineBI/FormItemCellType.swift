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
    func update(with formItem: FormItem,isSetCaption:Bool)
}
protocol CallBackProtocol {
    func updateValue(valueSent: String,indexPath:IndexPath)
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
  case selectionView
  case datePickerView
  case yesNoView
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
    let nib4 = UINib.init(nibName: "ReadOnlyCustomCell", bundle: nil)
    tableView.register(nib4, forCellReuseIdentifier: "ReadOnlyCustomCell")
    let nib5 = UINib.init(nibName: "DatePickerViewTableViewCell", bundle: nil)
    tableView.register(nib5, forCellReuseIdentifier: "DatePickerViewTableViewCell")
    let nib6 = UINib.init(nibName: "YesNoViewTableViewCell", bundle: nil)
    tableView.register(nib6, forCellReuseIdentifier: "YesNoViewTableViewCell")
    let nib7 = UINib.init(nibName: "RSSelectionMenuCellView", bundle: nil)
    tableView.register(nib7, forCellReuseIdentifier: "RSSelectionMenuCellView")
  }
  
  /// Correctly dequeue the UITableViewCell according to the current cell type
  ///
  /// - Parameters:
  ///   - tableView: TableView where cells previously registered
  ///   - indexPath: indexPath where dequeue
  /// - Returns: a non-nullable UITableViewCell dequeued
    func dequeueCell(for tableView: UITableView, at indexPath: IndexPath,pickerViewData:[String:String],isReadOnlyView:Bool = false) -> UITableViewCell {
        if(isReadOnlyView){
            let cell:ReadOnlyTableViewCell
            let cellIdentifier = "ReadOnlyCustomCell"
            cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ReadOnlyTableViewCell
            return cell
        }
        switch self {
            case .pickerView:
                let cell:FormPickerViewTableViewCell
                let cellIdentifier = "PickerViewCell"
                cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! FormPickerViewTableViewCell
                cell.setPickerViewData(pickerViewData: pickerViewData)
                cell.formItem = nil
                cell.labelFieldCellIndex = nil
                cell.updateCallback = nil
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
            case .selectionView:
                let cell:RSSelectionMenuCellView
                let cellIdentifier = "RSSelectionMenuCellView"
                cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! RSSelectionMenuCellView
                cell.setMenuData(menuData: pickerViewData)
                cell.indexPath = indexPath
                return cell
            case .datePickerView:
                let cell:DatePickerViewTableViewCell
                let cellIdentifier = "DatePickerViewTableViewCell"
                cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! DatePickerViewTableViewCell
                return cell
            case .yesNoView:
                let cell:YesNoViewTableViewCell
                let cellIdentifier = "YesNoViewTableViewCell"
                cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! YesNoViewTableViewCell
                cell.indexPath = indexPath
                return cell
        }
   
  }
}
