//
//  AddBuyerViewController.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 10/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import Foundation
import UIKit
import ContactsUI
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
    private var editBuyerData:[String:Any] = [:]
    private let contactPicker = CNContactPickerViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        addBuyerTableView.dataSource = self
        addBuyerTableView.delegate = self
        prepareSubViews()
        initPickerViewData()
        loggedInUserSeq = PreferencesUtil.sharedInstance.getLoggedInUserSeq();
        progressHUD = ProgressHUD(text: "Processing")
        getBuyer()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        addBuyerTableView.reloadData()
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
    func loadFormOnEdit(response:[String:Any]){
        editBuyerData = response["buyer"] as! [String:Any]
        self.form.lastname = editBuyerData["firstname"] as? String
        self.form.lastname = editBuyerData["lastname"] as? String
        self.form.email = editBuyerData["email"] as? String
        self.form.cellphone = editBuyerData["cellphone"] as? String
        self.form.phone = editBuyerData["officephone"] as? String
        self.form.category = editBuyerData["category"] as? String
        self.form.notes = editBuyerData["notes"] as? String
        self.addBuyerTableView.reloadData()
    }
    
    func getBuyer(){
        if(self.editBuyerSeq == 0){
            self.addBuyerTableView.reloadData()
            return
        }
        self.view.addSubview(progressHUD)
        let args: [Int] = [self.loggedInUserSeq,self.editBuyerSeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_BUYER_BY_SEQ, args: args)
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
                        GlobalData.showAlertWithDismiss(view: self, title: "Success", message: message!)
                    }else{
                        GlobalData.showAlert(view: self, message: message!)
                    }
                }
            } catch let parseError as NSError {
                GlobalData.showAlert(view: self, message: parseError.description)
            }
        })
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
    func buttonTappedCallBack(){
        openContact()
    }
    func openContact(){
        contactPicker.delegate = self
        self.present(contactPicker, animated: true, completion: nil)
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
        let name = item.name
        if let val = editBuyerData[name!] as? String {
            item.value = val
            if(name == "category" && val != ""){
                if let v = categoryTypes[val] {
                    item.value = v;
                }
            }
        }
        var cell: UITableViewCell
        let pickerViewData:[String:String] = categoryTypes
        if let cellType = self.form.formItems[indexPath.row].uiProperties.cellType {
            if(item.isPicker  && cellType == FormItemCellType.pickerView){
                item.value = editBuyerData["category"] as? String
            }
           cell = cellType.dequeueCell(for: tableView, at: indexPath,pickerViewData: pickerViewData)
           if let pickerViewCell = cell as? FormPickerViewTableViewCell {
                pickerViewCell.labelFieldCellIndex = IndexPath(row: indexPath.row-1, section: indexPath.section)
                pickerViewCell.updateCallback = self.UpdateCallback
                cell = pickerViewCell
           }
           if let buttonViewCell = cell as? FormButtonViewTableViewCell {
                buttonViewCell.buttonTappedCallBack = buttonTappedCallBack
           }
        }else{
           cell = UITableViewCell()
        }
       
        if let formUpdatableCell = cell as? FormUpdatable {
            item.indexPath = indexPath
            formUpdatableCell.update(with: item)
        }
        return cell
    }
    
}
extension AddBuyerViewController: CNContactPickerDelegate {
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let phoneNumberCount = contact.phoneNumbers.count
        
        guard phoneNumberCount > 0 else {
            dismiss(animated: true)
            //show pop up: "Selected contact does not have a number"
            return
        }
        setInfoFromContact(contact: contact)
        if phoneNumberCount == 1 {
            setNumberFromContact(contactNumber: contact.phoneNumbers[0].value.stringValue)
        } else {
            let alertController = UIAlertController(title: "Select one of the numbers", message: nil, preferredStyle: .alert)
            
            for i in 0...phoneNumberCount-1 {
                let phoneAction = UIAlertAction(title: contact.phoneNumbers[i].value.stringValue, style: .default, handler: {
                    alert -> Void in
                    self.setNumberFromContact(contactNumber: contact.phoneNumbers[i].value.stringValue)
                    self.addBuyerTableView.reloadData()
                })
                alertController.addAction(phoneAction)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: {
                alert -> Void in
                
            })
            alertController.addAction(cancelAction)
            
            dismiss(animated: true)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func setNumberFromContact(contactNumber: String) {
        
        //UPDATE YOUR NUMBER SELECTION LOGIC AND PERFORM ACTION WITH THE SELECTED NUMBER
        
        var contactNumber = contactNumber.replacingOccurrences(of: "-", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: "+", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: "(", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: ")", with: "")
        //contactNumber = contactNumber.removeWhitespacesInBetween()
        guard contactNumber.count >= 10 else {
            dismiss(animated: true) {
                   GlobalData.showAlert(view: self, message: "Selected contact does not have a valid number")
            }
            return
        }
        editBuyerData["cellphone"] = contactNumber
        self.form.cellphone = contactNumber;
    }
    
    func setInfoFromContact(contact:CNContact){
        editBuyerData["firstname"] = contact.givenName
        self.form.firstname = contact.givenName;
        editBuyerData["lastname"] = contact.familyName
        self.form.lastname = contact.familyName;
        if(contact.emailAddresses.count > 0){
            editBuyerData["email"] = contact.emailAddresses[0].value
        }
    }
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {
        
    }
}
