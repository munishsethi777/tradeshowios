//
//  CustomerDetailViewController.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 30/01/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import Foundation
import UIKit
class CustomerDetailViewController : UIViewController , UITableViewDelegate, CallBackProtocol{
    
    
    @IBAction func addBuyerTapped(_ sender: Any) {
        self.performSegue(withIdentifier: "AddBuyer", sender: self)
    }
    
    var selectedCustomerSeq:Int = 0;
    var loggedInUserSeq:Int = 0;
    var progressHUD: ProgressHUD!
    var customerDetailSt: [IDNamePair]!
    var buyerDetailSt: [IDNamePair]!
    var selectedBuyerSeq:Int = 0
    @IBOutlet weak var detailTableView: UITableView!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var innerView: UIView!

    @IBOutlet weak var buyerTableView: UITableView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var buyerTableHeight: NSLayoutConstraint!
    @IBOutlet weak var customerNameLabel: UILabel!
    var lastIndexOfBuyerArr:Int = 0
    let DELETE_CUSTOMER = "Delete Customer"
    let SPECIAL_PROGRAM_QUESTIONNAIRE = "Special Program Questionnaire"
    let SPRING_QUESTIONNAIRE = "Spring Questionnaire"
    let CHRISTMAS_QUESTIONNAIRE = "Christmas Questionnaire"
    let OPPURTUNITY_QUESTIONNAIRE = "Oppurtunity Questionnaire"
    
    var refreshControl:UIRefreshControl!
    var customerForm = Form()
    var enums:[String:Any] = [:]
    var editCustomerData:[String:Any] = [:]
    var isReadOnly = true;
    override func viewDidLoad(){
        super.viewDidLoad()
        prepareSubViews()
        loggedInUserSeq = PreferencesUtil.sharedInstance.getLoggedInUserSeq();
        progressHUD = ProgressHUD(text: "Loading")
        customerDetailSt = []
        buyerDetailSt = []
        detailTableView.dataSource = self
        detailTableView.delegate = self
        detailTableView.tableFooterView = UIView()
        buyerTableView.tableFooterView = UIView()
        if #available(iOS 10.0, *) {
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshView), for: .valueChanged)
            scrollView.refreshControl = refreshControl
        }
        self.view.addSubview(progressHUD)
        loadEnumData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        customerDetailSt = []
        buyerDetailSt = []
    }

    @objc func editTapped(){
        isReadOnly = false
        self.detailTableView.reloadData()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveCustomer))
    }
    func addEditButton(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
    }
    
    @objc func refreshView(control:UIRefreshControl){
        customerDetailSt = []
        buyerDetailSt = []
        getCustomerDetail()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBuyer = buyerDetailSt[indexPath.row]
        if(selectedBuyer.value == DELETE_CUSTOMER && lastIndexOfBuyerArr == indexPath.row){
            deleteCustomerConfirm()
        }else if(selectedBuyer.value == SPECIAL_PROGRAM_QUESTIONNAIRE){
            self.performSegue(withIdentifier: "SpecialProgramViewController", sender: self)
        }else if(selectedBuyer.value == CHRISTMAS_QUESTIONNAIRE){
            self.performSegue(withIdentifier: "ChristmasQuestionViewController", sender: self)
        }
        else if(selectedBuyer.value == SPRING_QUESTIONNAIRE){
            self.performSegue(withIdentifier: "ShowSpringQuestionViewController", sender: self)
        }
        else if(selectedBuyer.value == OPPURTUNITY_QUESTIONNAIRE){
            self.performSegue(withIdentifier: "OppurtunityQuestionViewController", sender: self)
        }
        else{
            selectedBuyerSeq = Int(selectedBuyer.id)!
            self.performSegue(withIdentifier: "BuyerDetailViewController", sender: self)
        }
    }
    
    @objc func saveCustomer(){
        var customerArr = self.customerForm.toArray(swiftClass: self.customerForm);
        customerArr["businesstype"] = getSelectedNameForMenu(fieldName: "businesstype",value:customerForm.businesstype)
        customerArr["priority"] = getSelectedNameForMenu(fieldName: "priority", value: customerForm.priority)
        var isStoreEnabled = 1
        if(self.customerForm.storename == nil && self.customerForm.storeid == nil ){
            isStoreEnabled = 0
        }
        customerArr["seq"] = self.selectedCustomerSeq
        customerArr["isstore"] = isStoreEnabled
        customerArr["createdby"] = self.loggedInUserSeq
        let jsonString = JsonUtil.toJsonString(jsonObject: customerArr)
        excecuteSaveCustomerCall(jsonstring: jsonString)
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
                        self.selectedCustomerSeq = Int(json["customerseq"] as! Int)
                        self.isReadOnly = true
                        self.loadEnumData()
                        self.addEditButton()
                    }
                    self.progressHUD.hide()
                    GlobalData.showAlert(view: self, message: message!)
                }
            } catch let parseError as NSError {
                GlobalData.showAlert(view: self, message: parseError.description)
            }
        })
    }
    private func prepareSubViews() {
        FormItemCellType.registerCells(for: self.detailTableView)
        self.detailTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.detailTableView.allowsSelection = false
        self.detailTableView.estimatedRowHeight = 90
    }
    
    func getCustomerDetail(){
        self.view.addSubview(progressHUD)
        let args: [Int] = [self.loggedInUserSeq,self.selectedCustomerSeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_CUSTOMER_DETAIL_AND_BUYERS, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.loadCustomerDetail(jsonReponse: json)
                        self.loadBuyers(jsonReponse: json)
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
    
    func loadCustomerDetail(jsonReponse:[String:Any]){
        if let editData = jsonReponse["customer"] as? [String:Any]{
            self.editCustomerData = editData
            self.customerForm.businesstype = getSelectedValueForMenu(fieldName: "businesstype")
            self.customerForm.fullname = editCustomerData["fullname"] as? String
            self.customerForm.customerid = editCustomerData["customerid"] as? String
            self.customerForm.priority = getSelectedValueForMenu(fieldName: "priority")
            self.customerForm.salespersonname = editCustomerData["salespersonname"] as? String
            self.customerForm.salespersonid = editCustomerData["salespersonid"] as? String
            self.customerForm.storename = editCustomerData["storename"] as? String
            self.customerForm.reload()
            customerNameLabel.text = editCustomerData["fullname"] as? String
            storeNameLabel.text = editCustomerData["storename"] as? String
        }
        self.detailTableView.reloadData()
    }
    
    func loadBuyers(jsonReponse:[String:Any]){
        let buyers = jsonReponse["buyers"] as! [Any]
        for j in 0..<buyers.count{
            let buyerJson = buyers[j] as! [String: Any]
            let name = buyerJson["id"] as! String
            let value = buyerJson["value"] as! String
            var detail = IDNamePair()
            detail.id = name
            detail.value = value
            buyerDetailSt.append(detail)
        }
        addFormButtonsLinks()
        if(buyers.count > 0){
            addDeleteButtonLink()
            lastIndexOfBuyerArr = buyerDetailSt.count - 1
        }
        buyerTableView.dataSource = self
        buyerTableView.delegate = self
        buyerTableView.reloadData()
        buyerTableHeight.constant = CGFloat(38 * buyerDetailSt.count)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let secondController = segue.destination as? BuyerDetailViewController {
            secondController.selectedBuyerSeq =  selectedBuyerSeq
            secondController.selectedCustomerSeq = selectedCustomerSeq
        }
        if let secondController = segue.destination as? AddCustomerViewController {
            secondController.editCustomerSeq =  selectedCustomerSeq
        }
        if let secondController = segue.destination as? AddBuyerViewController {
            secondController.customerSeq =  selectedCustomerSeq
        }
        if let secondController = segue.destination as? ChristmasQuestionViewController {
            secondController.customerName = customerNameLabel.text!
            secondController.customerSeq =  selectedCustomerSeq
        }
        if let secondController = segue.destination as? SpecialProgramViewContorller {
            secondController.customerName = customerNameLabel.text!
            secondController.customerSeq =  selectedCustomerSeq
        }
        if let secondController = segue.destination as? OppurtunityQuestionViewController {
            secondController.customerNameStr = customerNameLabel.text!
            secondController.customerSeq =  selectedCustomerSeq
        }
        if let secondController = segue.destination as? ShowSpringQestionsViewController {
            secondController.customerName = customerNameLabel.text!
            secondController.customerSeq =  selectedCustomerSeq
        }
    
    }
    
    func addDeleteButtonLink(){
        var detail = IDNamePair()
        detail.id = String(selectedCustomerSeq)
        detail.value = DELETE_CUSTOMER
        buyerDetailSt.append(detail)
    }
    
    func addFormButtonsLinks(){
        var detail = IDNamePair()
        detail.id = String(selectedCustomerSeq)
        detail.value = SPECIAL_PROGRAM_QUESTIONNAIRE
        buyerDetailSt.append(detail)
        
        detail.id = String(selectedCustomerSeq)
        detail.value = SPRING_QUESTIONNAIRE
        buyerDetailSt.append(detail)
        
        detail.id = String(selectedCustomerSeq)
        detail.value = OPPURTUNITY_QUESTIONNAIRE
        buyerDetailSt.append(detail)
        
        detail.id = String(selectedCustomerSeq)
        detail.value = CHRISTMAS_QUESTIONNAIRE
        buyerDetailSt.append(detail)
        
        
    }
    func loadEnumData(){
        let args: [Int] = [self.loggedInUserSeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_BUSINESS_TYPES, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.enums["businesstype"] = json["businessTypes"] as! [String:String]
                        self.enums["priority"] = json["priorityTypes"] as! [String:String]
                        self.prepareSubViews()
                        self.detailTableView.dataSource = self
                        self.detailTableView.delegate = self
                        self.getCustomerDetail()
                        self.addEditButton()
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
    func deleteCustomerConfirm(){
        let refreshAlert = UIAlertController(title: "Delete Customer", message: StringConstants.DELETE_CUSTOMER_CONFIRM, preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
             self.excuteDeleteCustomerCall()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func excuteDeleteCustomerCall(){
        self.progressHUD.show()
        let args: [Int] = [self.loggedInUserSeq,self.selectedCustomerSeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.DELETE_CUSTOMER, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.showAlert(title: "Delete Success", message: message!)
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
    func showAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            self.navigationController?.popToRootViewController(animated: true)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    func getPickerViewData(formItem:FormItem)->[String:String]{
        let name = formItem.name!
        if let pickerData = enums[name]{
            return pickerData as! [String : String]
        }
        return [:]
    }
    func updateValue(valueSent: String, indexPath: IndexPath) {
        self.customerForm.formItems[indexPath.row].value = valueSent;
        detailTableView?.beginUpdates()
        detailTableView?.endUpdates()
    }
    func getSelectedValueForMenu(fieldName:String)->String?{
        if let selectedValueStr = editCustomerData[fieldName] as? String{
            let selctedValuesArr = selectedValueStr.components(separatedBy: ",")
            var selectedValues:[String] = []
            let enumData = enums[fieldName] as! [String:String];
            for value in selctedValuesArr {
                selectedValues.append(enumData[value]!)
            }
            let valueStr = selectedValues.joined(separator: ", ")
            self.editCustomerData[fieldName] = valueStr
            return valueStr
        }
        return nil
    }
    func getSelectedNameForMenu(fieldName:String,value:String?)->String?{
        if value != nil && !value!.isEmpty{
            let selctedValuesNameArr = value!.components(separatedBy: ",")
            var selectedValuesName:[String] = []
            let enumData = enums[fieldName] as! [String:String];
            for var value in selctedValuesNameArr {
                value = value.trimmingCharacters(in: .whitespacesAndNewlines)
                let selectedValueName =  enumData.keysForValue(value:value).first
                selectedValuesName.append(selectedValueName!)
            }
            let nameStr = selectedValuesName.joined(separator: ",")
            //self.editProgData[fieldName] = nameStr
            return nameStr
        }
        return nil
    }
}
extension CustomerDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == detailTableView){
            return self.customerForm.formItems.count
        }else{
            return buyerDetailSt.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(tableView == buyerTableView){
            let cellIdentifier = "BuyerTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BuyerTableViewCell
            cell.buyerNameLabel.text = ""
            let buyer = buyerDetailSt[indexPath.row]
            cell.buyerNameLabel.text = buyer.value
            cell.buyerNameLabel.textColor = .black
            cell.buyerNameLabel.font = UIFont(name:"Helvetica",size: 13.0)
            let lastIndex = buyerDetailSt.count - 1;
            if(buyer.value == DELETE_CUSTOMER && lastIndex == indexPath.row){
                cell.buyerNameLabel.font = UIFont(name:"Helvetica",size: 15.0)
                cell.buyerNameLabel.textColor = .red
            }
            if(buyer.value == SPECIAL_PROGRAM_QUESTIONNAIRE
                || buyer.value == OPPURTUNITY_QUESTIONNAIRE
                || buyer.value == CHRISTMAS_QUESTIONNAIRE
                || buyer.value == SPRING_QUESTIONNAIRE){
                cell.buyerNameLabel.font = UIFont(name:"Helvetica",size: 15.0)
                cell.buyerNameLabel.textColor = UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
            }
            return cell
        }
        var isSetCaption = true
        let item = self.customerForm.formItems[indexPath.row]
        let pickerViewData:[String:String] = self.getPickerViewData(formItem: item)
        var cell: UITableViewCell
        if let cellType = self.customerForm.formItems[indexPath.row].uiProperties.cellType {
            cell = cellType.dequeueCell(for: tableView, at: indexPath, pickerViewData: pickerViewData,isReadOnlyView: isReadOnly)
            if var selectionViewCell = cell as? CustomCell {
                if(item.isLabel){
                    isSetCaption = true
                }else{
                    isSetCaption = false
                }
                selectionViewCell.parent = self
                selectionViewCell.delegate = self
            }
        }else{
            cell = UITableViewCell()
        }
        if let formUpdatableCell = cell as? FormUpdatable {
            item.indexPath = indexPath
            formUpdatableCell.update(with: item,isSetCaption:isSetCaption)
        }
        return cell
    }
    
}
