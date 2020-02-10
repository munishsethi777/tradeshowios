//
//  AddBuyerViewController.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 10/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import Foundation
import UIKit
class AddBuyerViewController: UIViewController,UITableViewDelegate{
    let totalRowsCount:Int = 0
    var loggedInUserSeq:Int = 0
    var customerSeq:Int = 0;
    var progressHUD: ProgressHUD!
    var editBuyerSeq:Int = 0
    private var form = BuyerForm()
    @IBOutlet weak var addBuyerTableView: UITableView!
    var categoryTypes:[String:String] = [:]
    private var dpShowCategoryTypeVisible = false
    private var selectedIndex = 0;
    private var editBuyerData:[String:String] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        addBuyerTableView.dataSource = self
        addBuyerTableView.delegate = self
        prepareSubViews()
        initPickerViewData()
        loggedInUserSeq = PreferencesUtil.sharedInstance.getLoggedInUserSeq();
        progressHUD = ProgressHUD(text: "Processing")
    }
    
    private func initPickerViewData(){
        categoryTypes[""] = "Select Any"
        categoryTypes["fountains"] = "Fountains"
        categoryTypes["bird_bath"] = "Bird Bath"
        categoryTypes["furniture"] = "Furniture"
        categoryTypes["other"] = "Other"
        categoryTypes["christmas_lighted"] = "Christmas Lighted"
        categoryTypes["outdoor_lighted"] = "Outdoor Lighted"
        categoryTypes["christmas"] = "Christmas"
        categoryTypes["outdoor_decor"] = "Outdoor Decor"
        categoryTypes["patriotic"] = "Patriotic"
    }
    
    private func prepareSubViews() {
        FormItemCellType.registerCells(for: self.addBuyerTableView)
        self.addBuyerTableView.tableFooterView = UIView(frame: CGRect.zero)
    }
    
    private func saveBuyer(){
        var buyerArr:[String: Any] = [:]
        buyerArr["firstname"] = self.form.firstname
        buyerArr["lastname"] = self.form.lastname
        buyerArr["email"] = self.form.email
        buyerArr["cellphone"] = self.form.cellphone
        buyerArr["officephone"] = self.form.phone
        buyerArr["category"] = self.form.category
        buyerArr["seq"] = editBuyerSeq
        buyerArr["customerseq"] = customerSeq
        buyerArr["notes"] = self.form.notes
        buyerArr["createdby"] = self.loggedInUserSeq
        let jsonString = JsonUtil.toJsonString(jsonObject: buyerArr);
        excecuteSaveBuyerCall(jsonstring: jsonString)
    }
    
    private func excecuteSaveBuyerCall(jsonstring: String!){
        self.view.addSubview(progressHUD)
        let json = jsonstring.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let args: [Any] = [self.loggedInUserSeq,json]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.SUBMIT_ADD_BUYER, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.customerSeq = Int(json["buyerseq"] as! Int)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    @IBAction func cancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doneTapped(_ sender: Any) {
        saveBuyer()
    }
    private func toggleShowDateDatepicker (selectedIndex:Int) {
        if(selectedIndex == 5){
            dpShowCategoryTypeVisible = !dpShowCategoryTypeVisible
        }else{
            dpShowCategoryTypeVisible = false
        }
        addBuyerTableView.beginUpdates()
        addBuyerTableView.endUpdates()
    }
    var isSelectRow = false;
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 5 {
            selectedIndex = indexPath.row
            toggleShowDateDatepicker(selectedIndex:indexPath.row)
        }
        isSelectRow = true
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ((!dpShowCategoryTypeVisible && indexPath.row == 6)) {
            return 0.0
        } else {
            if(indexPath.row == 7){
               //return 60
               return UITableView.automaticDimension
            }else{
               return UITableView.automaticDimension
            }
            
        }
    }
    
    func UpdateCallback(selectedValue:String,indexPath:IndexPath) //add this extra method
    {
        form.formItems[indexPath.row].value = selectedValue
        if(form.formItems[indexPath.row].name == "category"){
            form.category = selectedValue
            editBuyerData["category"] = selectedValue
        }
        self.addBuyerTableView.reloadRows(at:[indexPath], with: .none)
    }
}
extension AddBuyerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.form.formItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.form.formItems[indexPath.row]
        var cell: UITableViewCell
        let pickerViewData:[String:String] = categoryTypes
        if let cellType = self.form.formItems[indexPath.row].uiProperties.cellType {
           cell = cellType.dequeueCell(for: tableView, at: indexPath,pickerViewData: pickerViewData)
        }else{
           cell = UITableViewCell()
        }
        if let pickerViewCell = cell as? FormPickerViewTableViewCell {
            pickerViewCell.labelFieldCellIndex = IndexPath(row: indexPath.row-1, section: indexPath.section)
            pickerViewCell.updateCallback = self.UpdateCallback
            cell = pickerViewCell
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
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        view.present(alert, animated: true, completion: nil)
    }
    
    
    
}
