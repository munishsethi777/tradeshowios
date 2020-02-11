//
//  AddCustomerViewController.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 03/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import Foundation
import UIKit
class AddCustomerViewController : UIViewController,UITableViewDelegate,UIGestureRecognizerDelegate{
    let totalRowsCount:Int = 0
    var loggedInUserSeq:Int = 0
    var customerSeq:Int = 0;
    var progressHUD: ProgressHUD!
    private var form = Form()
    var businessTypes:[String:String] = [:]
    var priorityTypes:[String:String] = [:]
    var editCustomerData:[String:Any] = [:]
    var editCustomerSeq:Int = 0
    @IBOutlet weak var ibTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        editCustomerData = [:]
        loggedInUserSeq = PreferencesUtil.sharedInstance.getLoggedInUserSeq();
        self.form = Form()
        businessTypes[""] = "Select Any"
        businessTypes["direct"] = "Direct"
        businessTypes["domestic"] = "Domestic"
        businessTypes["dot_com"] = "Dot Com"
        
        priorityTypes[""] = "Select Any"
        priorityTypes["A"] = "A"
        priorityTypes["B"] = "B"
        priorityTypes["C"] = "C"
        progressHUD = ProgressHUD(text: "Processing")
        self.hideKeyboardWhenTappedAround()
        self.prepareSubViews()
        hideKeyboardWhenTappedAround()
        ibTableView.dataSource = self
        ibTableView.delegate = self
        getCustomer()
    }
    private func prepareSubViews() {
       FormItemCellType.registerCells(for: self.ibTableView)
       self.ibTableView.tableFooterView = UIView(frame: CGRect.zero)
       // self.ibTableView.allowsSelection = false
       self.ibTableView.estimatedRowHeight = 90
       self.ibTableView.rowHeight = UITableView.automaticDimension
    }
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        self.saveCustomer()
    }
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        
    }
    
    func saveCustomer(){
        var customerArr:[String: Any] = [:]
        customerArr["fullname"] = self.form.fullname
        customerArr["customerid"] = self.form.id
        customerArr["salespersonid"] = self.form.salespersonid
        customerArr["salespersonname"] = self.form.salesperson
        customerArr["businesstype"] = self.form.businesstype
        customerArr["priority"] = self.form.priority
        var isStoreEnabled = 1
        if(self.form.storename == nil && self.form.storeid == nil ){
            isStoreEnabled = 0
        }
        customerArr["seq"] = editCustomerSeq
        customerArr["storename"] = self.form.storename
        customerArr["storeid"] = self.form.storeid
        customerArr["isstore"] = isStoreEnabled
        customerArr["createdby"] = self.loggedInUserSeq
        let jsonString = toJsonString(jsonObject: customerArr);
        excecuteSaveCustomerCall(jsonstring: jsonString)
    }
    
    func toJsonString(jsonObject:Any)->String{
        let jsonString: String!
        do {
            let postData : NSData = try JSONSerialization.data(withJSONObject: jsonObject, options:[]) as NSData
            jsonString = NSString(data: postData as Data, encoding: String.Encoding.utf8.rawValue)! as String
        } catch {
            jsonString = ""
        }
        return jsonString!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let secondController = segue.destination as? CustomerDetailViewController {
            secondController.selectedCustomerSeq =  customerSeq
        }
    }
    
    func goToDetailView(){
        let nextViewController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabViewController") as! DashboardTabController
        nextViewController.selectedCustomerSeq = customerSeq
        nextViewController.isGoToDetailView = true
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    func excecuteSaveCustomerCall(jsonstring:String){
        self.view.addSubview(progressHUD)
        let json = jsonstring.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let args: [Any] = [self.loggedInUserSeq,json]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.SUBMIT_ADD_CUSTOMER, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                      self.customerSeq = Int(json["customerseq"] as! Int)
                      self.progressHUD.hide()
                      self.showAlertMessage(view: self, message: message!)
                    }else{
                        GlobalData.showAlert(view: self, message: message!)
                    }
                }
            } catch let parseError as NSError {
                GlobalData.showAlert(view: self, message: parseError.description)
            }
        })
    }
    private var dpShowBusinessTypeVisible = false
    private var dpShowPriortyVisible = false
    private var selectedIndex = 0;
    private func toggleShowDateDatepicker (selectedIndex:Int) {
        if(selectedIndex == 2){
            dpShowBusinessTypeVisible = !dpShowBusinessTypeVisible
        }else if(selectedIndex == 6){
            dpShowPriortyVisible = !dpShowPriortyVisible
        }else{
            dpShowBusinessTypeVisible = false
            dpShowPriortyVisible = false
        }
        ibTableView.beginUpdates()
        ibTableView.endUpdates()
    }
    var isSelectRow = false;
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 || indexPath.row == 6 {
           selectedIndex = indexPath.row
           toggleShowDateDatepicker(selectedIndex:indexPath.row)
        }
        isSelectRow = true
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ((!dpShowBusinessTypeVisible && indexPath.row == 3) || (!dpShowPriortyVisible && indexPath.row == 7) ) {
            return 0.0
        } else {
            return 60
        }
    }
    func UpdateCallback(selectedValue:String,indexPath:IndexPath) //add this extra method
    {
        form.formItems[indexPath.row].value = selectedValue
        if(form.formItems[indexPath.row].name == "businesstype"){
            form.businesstype = selectedValue
            editCustomerData["businesstype"] = selectedValue
        }
        if(form.formItems[indexPath.row].name == "priority"){
            form.priority = selectedValue
            editCustomerData["priority"] = selectedValue
        }
        self.ibTableView.reloadRows(at:[indexPath], with: .none)
    }
    func getCustomer(){
        if(self.editCustomerSeq == 0){
            self.ibTableView.reloadData()
            return
        }
        self.view.addSubview(progressHUD)
        let args: [Int] = [self.loggedInUserSeq,self.editCustomerSeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_CUSTOMER_BY_SEQ, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.loadFormOnEdit(response: json)
                        self.progressHUD.hide()
                    }else{
                        GlobalData.showAlert(view: self, message: message!)
                    }
                }
            } catch let parseError as NSError {
                GlobalData.showAlert(view: self, message: parseError.description)
            }
        })
    }
    func loadFormOnEdit(response:[String:Any]){
        editCustomerData = response["customer"] as! [String:Any]
        self.form.fullname = editCustomerData["fullname"] as? String
        self.form.id = editCustomerData["customerid"] as? String
        self.form.salespersonid = editCustomerData["salespersonid"] as? String
        self.form.salesperson = editCustomerData["salespersonname"] as? String
        self.form.businesstype = editCustomerData["businesstype"] as? String
        self.form.priority = editCustomerData["priority"] as? String
        self.form.storename = editCustomerData["storename"] as? String
        self.form.storeid = editCustomerData["storeid"] as? String
        self.ibTableView.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension AddCustomerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.form.formItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.form.formItems[indexPath.row]
        let name = item.name
        if let val = editCustomerData[name!] as? String {
            item.value = val
            if(name == "businesstype" && val != ""){
                if let v = businessTypes[val] {
                    item.value = v;
                }
            }
            if(name == "priorty" && val != ""){
                if let v = priorityTypes[val] {
                    item.value = v;
                }
            }
        }
        var pickerViewData:[String:String] = [:]
        var cell: UITableViewCell
        if let cellType = self.form.formItems[indexPath.row].uiProperties.cellType {
            if(item.name == "businesstypepicker" && cellType == FormItemCellType.pickerView){
                item.value = editCustomerData["businesstype"] as? String
                pickerViewData = businessTypes
            }
            if(item.name == "prioritypicker" && cellType == FormItemCellType.pickerView){
                item.value = editCustomerData["priority"] as? String
                pickerViewData = priorityTypes
            }
            cell = cellType.dequeueCell(for: tableView, at: indexPath,pickerViewData: pickerViewData)
            if let pickerViewCell = cell as? FormPickerViewTableViewCell {
                pickerViewCell.labelFieldCellIndex = IndexPath(row: indexPath.row-1, section: indexPath.section)
                pickerViewCell.updateCallback = self.UpdateCallback
                cell = pickerViewCell
            }
        } else {
            cell = UITableViewCell() //or anything you want
        }
        if let formUpdatableCell = cell as? FormUpdatable {
            item.indexPath = indexPath
            formUpdatableCell.update(with: item)
        }
        return cell
    }
    
    func showAlertMessage(view:UIViewController,message:String,nextViewControllerSegueId:String? = nil){
        let alert = UIAlertController(title: "Validation", message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            self.goToDetailView()
        }
        alert.addAction(action)
        view.present(alert, animated: true, completion: nil)
    }
    
   
    
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
