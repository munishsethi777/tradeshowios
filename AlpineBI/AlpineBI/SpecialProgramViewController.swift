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
    @IBOutlet weak var customerNameLabel: UILabel!
    var editProgData:[String:Any] = [:]
    var enums:[String:Any] = [:]
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
        isReadOnly = true
        loadEnumData()
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
        super.viewWillAppear(animated)
    }
    
    private func prepareSubViews() {
        FormItemCellType.registerCells(for: self.tableView)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.allowsSelection = false
        self.tableView.estimatedRowHeight = 90
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
            return UITableView.automaticDimension
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
                        self.enums["regularterms"] = json["regularterms"] as! [String:String]
                        self.enums["freight"] = json["freighttypes"] as! [String:String]
                        self.enums["howdefectiveallowancededucted"] = json["allowancedeductionstype"] as! [String:String]
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
        var arr = self.form.toArray(swiftClass: self.form);
        arr["customerseq"] = self.customerSeq
        arr["freight"] = getSelectedNameForMenu(fieldName: "freight",value:form.freight)
        arr["regularterms"] = getSelectedNameForMenu(fieldName: "regularterms",value:form.regularterms)
        arr["howdefectiveallowancededucted"] = getSelectedNameForMenu(fieldName: "howdefectiveallowancededucted",value:form.howdefectiveallowancededucted)
        let jsonString = JsonUtil.toJsonString(jsonObject: arr)
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
            self.form.freight = getSelectedValueForMenu(fieldName: "freight")
            self.form.howdefectiveallowancededucted = getSelectedValueForMenu(fieldName:"howdefectiveallowancededucted")
            self.form.howpayingbackcustomer = editProgData["howpayingbackcustomer"] as? String
            self.form.inseasonterms = editProgData["inseasonterms"] as? String
            self.form.isbackorderaccepted = editProgData["isbackorderaccepted"] as? String
            self.form.isdefectiveallowancesigned = editProgData["isdefectiveallowancesigned"] as? String
            self.form.isedicustomer = editProgData["isedicustomer"] as? String
            self.form.otherallowance = editProgData["otherallowance"] as? String
            self.form.priceprogram = editProgData["priceprogram"] as? String
            self.form.promotionalallowance = editProgData["priceprogram"] as? String
            self.form.rebateprogramandpaymentmethod = editProgData["rebateprogramandpaymentmethod"] as? String
            self.form.regularterms = getSelectedValueForMenu(fieldName:"regularterms")
            self.form.howpayingbackcustomer = editProgData["howpayingbackcustomer"] as? String
        }
        self.tableView.reloadData()
    }
    func getPickerViewData(formItem:FormItem)->[String:String]{
        if(formItem.isPicker || formItem.isLabel){
            let name = formItem.name!
            if let pickerData = enums[name]{
                return pickerData as! [String : String]
            }
        }
        return [:]
    }
    func getSelectedValueForMenu(fieldName:String)->String?{
        if let selectedValueStr = editProgData[fieldName] as? String{
            let selctedValuesArr = selectedValueStr.components(separatedBy: ",")
            var selectedValues:[String] = []
            let enumData = enums[fieldName] as! [String:String];
            for value in selctedValuesArr {
                selectedValues.append(enumData[value]!)
            }
            let valueStr = selectedValues.joined(separator: ",")
            self.editProgData[fieldName] = valueStr
            return valueStr
        }
        return nil
    }
    func getSelectedNameForMenu(fieldName:String,value:String?)->String?{
        if value != nil && !value!.isEmpty{
            let selctedValuesNameArr = value!.components(separatedBy: ",")
            var selectedValuesName:[String] = []
            let enumData = enums[fieldName] as! [String:String];
            for value in selctedValuesNameArr {
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
        }
        var cell: UITableViewCell
        if let cellType = self.form.formItems[indexPath.row].uiProperties.cellType {
            cell = cellType.dequeueCell(for: tableView, at: indexPath,pickerViewData: pickerViewData,isReadOnlyView: isReadOnly)
            if let selectionViewCell = cell as? RSSelectionMenuCellView {
                if(item.isLabel){
                    isSetCaption = true
                }else{
                    isSetCaption = false
                }
                selectionViewCell.parentViewController = self
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
extension Dictionary where Value: Equatable {
    func keysForValue(value: Value) -> [Key] {
        return compactMap { (key: Key, val: Value) -> Key? in
            value == val ? key : nil
        }
    }
}

extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}
