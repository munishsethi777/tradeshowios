//
//  SpecialProgramViewController.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 14/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import Foundation
import UIKit
class SpecialProgramViewContorller: UIViewController,UITableViewDelegate {
    var loggedInUserSeq:Int = 0
    var customerSeq:Int = 0;
    var customerName:String = "";
    var progressHUD: ProgressHUD!
    var editProgSeq:Int = 0
    var form = SpecialProgramForm()
    var isReadOnly = true;
    var regularTermsTypes:[String:String]=[:]
    var freightTypes:[String:String]=[:]
    var allowanceDeductionsTypes:[String:String]=[:]
    @IBOutlet weak var customerNameLabel: UILabel!
    var editProgData:[String:Any] = [:]
    override func viewDidLoad() {
        prepareSubViews()
        loggedInUserSeq = PreferencesUtil.sharedInstance.getLoggedInUserSeq()
        progressHUD = ProgressHUD(text: "Processing")
        customerNameLabel.text = customerName
         addEditButton()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        super.viewDidLoad()
    }
    func addEditButton(){
         self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
    }
    @IBOutlet weak var tableView: UITableView!
    @objc func editTapped(){
        isReadOnly = false
        tableView.reloadData()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveSpecialProg))
    }
    override func viewWillAppear(_ animated: Bool) {
        isReadOnly = true
        super.viewWillAppear(animated)
        loadEnumData()
    }
    private func prepareSubViews() {
        FormItemCellType.registerCells(for: self.tableView)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.allowsSelection = false
        self.tableView.estimatedRowHeight = 90
    }
    private var dpShowDatePickerVisible = false
    private var dpShowEndDatePickerVisible = false
    private var dpShowRegulerItemPickerVisible = false
    private var dpFreightTypesPickerVisible = false
    private var dpAllowanceDeductionsTypesPickerVisible = false
    
    private var selectedIndex:Int = 0
    
    var isSelectRow = false;
    
    private func isHiddenCell(row:Int)->Bool{
        var isHidden:Bool = false
        if(row == 1 && !dpShowDatePickerVisible){
            isHidden = true
        }
        if(row == 3 && !dpShowEndDatePickerVisible){
            isHidden = true
        }
        if(row == 6 && !dpShowRegulerItemPickerVisible){
            isHidden = true
        }
        if(row == 9 && !dpFreightTypesPickerVisible){
            isHidden = true
        }
        if(row == 16 && !dpAllowanceDeductionsTypesPickerVisible){
            isHidden = true
        }
        return isHidden
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.tableView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        tableView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        tableView.contentInset = contentInset
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (isHiddenCell(row: indexPath.row)) {
            return 0
        } else {
            return 60
        }
    }
    func loadEnumData(){
        let args: [Int] = [self.loggedInUserSeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_ENUMS_SPECIAL_PROG, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.regularTermsTypes = json["regularterms"] as! [String:String]
                        self.freightTypes = json["freighttypes"] as! [String:String]
                        self.allowanceDeductionsTypes = json["allowancedeductionstype"] as! [String:String]
                        self.prepareSubViews()
                        self.tableView.dataSource = self
                        self.tableView.delegate = self
                        self.getSpecialProgDetail()
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
    
    func getSpecialProgDetail(){
        if(self.customerSeq == 0){
            self.tableView.reloadData()
            return
        }
        self.view.addSubview(progressHUD)
        let args: [Int] = [self.loggedInUserSeq,self.customerSeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_SPECIAL_PROGRAM_DETAILS, args: args)
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
    
    @objc func saveSpecialProg(){
        var splProgArr:[String: Any] = [:]
        splProgArr["additionalremarks"] = self.form.additionalremarks
        splProgArr["defectivepercent"] = self.form.defectivepercent
        var endDate = self.form.enddate
        endDate = DateUtil.convertToFormat(dateString: endDate, fromFomat: DateUtil.dateFormat2, toFormat: DateUtil.dateFormat3)
        splProgArr["enddate"] = endDate
        var startDate = self.form.startdate
        startDate = DateUtil.convertToFormat(dateString: startDate, fromFomat: DateUtil.dateFormat2, toFormat: DateUtil.dateFormat3)
        splProgArr["startdate"] = startDate
        splProgArr["freight"] = self.form.freight
        splProgArr["howdefectiveallowancededucted"] = self.form.howdefectiveallowancededucted
        splProgArr["howpayingbackcustomer"] = self.form.howpayingbackcustomer
        splProgArr["customerseq"] = customerSeq
        splProgArr["inseasonterms"] = self.form.inseasonterms
        splProgArr["isbackorderaccepted"] = self.form.isbackorderaccepted == "Yes" ? "1" : "0"
        splProgArr["isdefectiveallowancesigned"] = self.form.isdefectiveallowancesigned == "Yes" ? "1" : "0"
        splProgArr["isedicustomer"] = self.form.isedicustomer == "Yes" ? "1" : "0"
        splProgArr["otherallowance"] = self.form.otherallowance
        splProgArr["priceprogram"] = self.form.priceprogram
        splProgArr["promotionalallowance"] = self.form.promotionalallowance
        splProgArr["rebateprogramandpaymentmethod"] = self.form.rebateprogramandpaymentmethod
        splProgArr["regularterms"] = self.form.regularterms
        let jsonString = JsonUtil.toJsonString(jsonObject: splProgArr);
        excecuteSaveCall(jsonstring: jsonString)
    }
    
    private func excecuteSaveCall(jsonstring: String!){
        self.progressHUD.show()
        let json = jsonstring.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let args: [Any] = [self.loggedInUserSeq,json]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.SAVE_SPECIAL_PROGRAM_DETAILS, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.resetPickerState()
                        self.isReadOnly = true
                        self.loadEnumData()
                        self.addEditButton()
                    }
                    self.progressHUD.hide()
                    GlobalData.showAlert(view: self, message: message!,success: success)
                }
            } catch let parseError as NSError {
                GlobalData.showAlert(view: self, message: parseError.description)
            }
        })
    }
    private func resetPickerState(){
        dpShowDatePickerVisible = false
        dpShowEndDatePickerVisible = false
        dpShowRegulerItemPickerVisible = false
        dpFreightTypesPickerVisible = false
        dpAllowanceDeductionsTypesPickerVisible = false
    }
    func loadFormOnEdit(response:[String:Any]){
        if let editProgData = response["specialProg"] as? [String:Any]{
            self.editProgData = editProgData
            self.form.additionalremarks = editProgData["additionalremarks"] as? String
            self.form.defectivepercent = editProgData["defectivepercent"] as? String
            var endDate = editProgData["enddate"] as? String
            endDate =  DateUtil.convertToFormat(dateString:endDate, fromFomat: DateUtil.dateFormat1, toFormat: DateUtil.dateFormat2)
            self.form.enddate = endDate
            self.editProgData["enddate"] = endDate
            var startdate = editProgData["startdate"] as? String
            startdate = DateUtil.convertToFormat(dateString:startdate, fromFomat: DateUtil.dateFormat1, toFormat: DateUtil.dateFormat2)
            self.form.startdate = startdate
            self.editProgData["startdate"] = startdate
            self.form.freight = editProgData["freight"] as? String
            self.form.howdefectiveallowancededucted = editProgData["howdefectiveallowancededucted"] as? String
            self.form.howpayingbackcustomer = editProgData["howpayingbackcustomer"] as? String
            self.form.inseasonterms = editProgData["inseasonterms"] as? String
            self.form.isbackorderaccepted = editProgData["isbackorderaccepted"] as? String
            self.form.isdefectiveallowancesigned = editProgData["isdefectiveallowancesigned"] as? String
            self.form.isedicustomer = editProgData["isedicustomer"] as? String
            self.form.otherallowance = editProgData["otherallowance"] as? String
            self.form.priceprogram = editProgData["priceprogram"] as? String
            self.form.promotionalallowance = editProgData["priceprogram"] as? String
            self.form.rebateprogramandpaymentmethod = editProgData["rebateprogramandpaymentmethod"] as? String
            self.form.regularterms = editProgData["regularterms"] as? String
            self.form.howdefectiveallowancededucted = editProgData["howdefectiveallowancededucted"] as? String
            self.form.howpayingbackcustomer = editProgData["howpayingbackcustomer"] as? String
        }
        self.tableView.reloadData()
    }
    func buttonTappedCallBack(fieldName:String?){
        if(fieldName == "startdate"){
            dpShowDatePickerVisible = !dpShowDatePickerVisible
        }
        if(fieldName == "enddate"){
            dpShowEndDatePickerVisible = !dpShowEndDatePickerVisible
        }
        if(fieldName == "regularterms"){
            dpShowRegulerItemPickerVisible = !dpShowRegulerItemPickerVisible
        }
        if(fieldName == "howdefectiveallowancededucted"){
            dpAllowanceDeductionsTypesPickerVisible = !dpAllowanceDeductionsTypesPickerVisible
        }
        if(fieldName == "freight"){
            dpFreightTypesPickerVisible = !dpFreightTypesPickerVisible
        }
        tableView.reloadData()
      //  tableView.endUpdates()
    }
    func UpdateCallback(selectedValue:String,indexPath:IndexPath) //add this extra method
    {
        form.formItems[indexPath.row].value = selectedValue
        if(form.formItems[indexPath.row].name == "startdate"){
            form.startdate = selectedValue
            editProgData["startdate"] = selectedValue
        }
        if(form.formItems[indexPath.row].name == "enddate"){
            form.enddate = selectedValue
            editProgData["enddate"] = selectedValue
        }
        if(form.formItems[indexPath.row].name == "regularterms"){
            form.regularterms = selectedValue
            editProgData["regularterms"] = selectedValue
        }
        if(form.formItems[indexPath.row].name == "freight"){
            form.freight = selectedValue
            editProgData["freight"] = selectedValue
        }
        if(form.formItems[indexPath.row].name == "howdefectiveallowancededucted"){
            form.howdefectiveallowancededucted = selectedValue
            editProgData["howdefectiveallowancededucted"] = selectedValue
        }
        self.tableView.reloadRows(at:[indexPath], with: .none)
    }
    
    func getPickerViewData(formItem:FormItem)->[String:String]{
            if(formItem.name == "regularterms" || formItem.name == "regulartermspicker"){
                return regularTermsTypes
            }else  if(formItem.name == "howdefectiveallowancededucted" || formItem.name == "howdefectiveallowancedeductedpicker"){
                return allowanceDeductionsTypes
            }else  if(formItem.name == "freight" || formItem.name == "freightpicker"){
                return freightTypes
            }else{
                return [:]
            }
    }
    
    func getPickerViewSelectedValue(formItem:FormItem)->String?{
        if(formItem.name == "regulartermspicker"){
            return editProgData["regularterms"] as? String
        }else if (formItem.name == "howdefectiveallowancedeductedpicker"){
            return editProgData["howdefectiveallowancededucted"] as? String
        }else if (formItem.name == "freightpicker"){
            return editProgData["freight"] as? String
        }else if(formItem.name == "startdatepicker"){
            return editProgData["startdate"] as? String
        }else if(formItem.name == "enddatepicker"){
            return editProgData["enddate"] as? String
        }
        else{
            return nil
        }
    }
    
    
    
    
}
extension SpecialProgramViewContorller: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.form.formItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var isSetCaption = true
        let item = self.form.formItems[indexPath.row]
        let pickerViewData:[String:String] = self.getPickerViewData(formItem: item)
        let name = item.name
        if let val = editProgData[name!] as? String {
            item.value = val
            if(item.isLabel && val != ""){
                if let v = pickerViewData[val] {
                    item.value = v;
                }
            }
        }
        var cell: UITableViewCell
        if let cellType = self.form.formItems[indexPath.row].uiProperties.cellType {
            if(item.isPicker  && (cellType == FormItemCellType.pickerView || cellType == FormItemCellType.datePickerView)){
                item.value = getPickerViewSelectedValue(formItem: item)
            }
            cell = cellType.dequeueCell(for: tableView, at: indexPath,pickerViewData: pickerViewData,isReadOnlyView: isReadOnly)
            
            if let pickerViewCell = cell as? DatePickerViewTableViewCell {
                pickerViewCell.labelFieldCellIndex = IndexPath(row: indexPath.row-1, section: indexPath.section)
                pickerViewCell.updateCallback = self.UpdateCallback
                cell = pickerViewCell
            }
            if let pickerViewCell = cell as? FormPickerViewTableViewCell {
                pickerViewCell.labelFieldCellIndex = IndexPath(row: indexPath.row-1, section: indexPath.section)
                pickerViewCell.updateCallback = self.UpdateCallback
                cell = pickerViewCell
            }
            
            if let buttonViewCell = cell as? FormButtonViewTableViewCell {
                if(item.isLabel){
                    isSetCaption = true
                }else{
                    isSetCaption = false
                }
                buttonViewCell.buttonTappedCallBack = buttonTappedCallBack
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
