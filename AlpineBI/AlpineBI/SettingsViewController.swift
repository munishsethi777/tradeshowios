//
//  SettingsViewController.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 12/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController ,UITableViewDelegate,CallBackProtocol{
    
   
    @IBAction func updateTapped(_ sender: UIBarButtonItem) {
        updateUser()
    }
    
    @IBOutlet weak var updateTapped: UIBarButtonItem!
    
    var loggedInUserSeq:Int = 0
    var progressHUD: ProgressHUD!
    private var form = SettingForm()
    private var editSettingsData:[String:Any] = [:]
    private var timeZones:[String:String] = [:]
    private var dpShowTimeZoneVisible = false
    private var selectedIndex = 0;
    var refreshControl:UIRefreshControl!
    var enums:[String:Any] = [:]
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loggedInUserSeq = PreferencesUtil.sharedInstance.getLoggedInUserSeq()
        progressHUD = ProgressHUD(text: "Processing")
        self.view.addSubview(progressHUD)
        hideKeyboardWhenTappedAround()
        if #available(iOS 10.0, *) {
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshView), for: .valueChanged)
            tableView.refreshControl = refreshControl
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        loadEnumData()
    }
    @objc func refreshView(control:UIRefreshControl){
        reloadData()
    }
    func reloadData(){
        loadEnumData()
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
    
    private func prepareSubViews() {
        FormItemCellType.registerCells(for: self.tableView)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.allowsSelection = false
        self.tableView.estimatedRowHeight = 90
        initPickerViewData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // loadEnumData()
    }
    
    func initPickerViewData(){
        timeZones["Asia/Yekaterinburg"] = "(GMT+05:00) Ekaterinburg"
        timeZones["Asia/Tashkent"] = "(GMT+05:00) Tashkent"
        timeZones["Asia/Kolkata"] = "(GMT+05:30) Chennai, Kolkata, Mumbai, New Delhi"
        timeZones["Asia/Katmandu"] = "(GMT+05:45) Kathmandu"
    }
    func UpdateCallback(selectedValue:String,indexPath:IndexPath) //add this extra method
    {
        form.formItems[indexPath.row].value = selectedValue
        if(form.formItems[indexPath.row].name == "usertimezone"){
            form.usertimezone = selectedValue
            editSettingsData["usertimezone"] = selectedValue
        }
        self.tableView.reloadRows(at:[indexPath], with: .none)
    }
    func buttonTappedCallBack(fieldName:String?){
        if(fieldName == "usertimezone"){
            dpShowTimeZoneVisible = !dpShowTimeZoneVisible
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    private func toggleShowDateDatepicker (selectedIndex:Int) {
        if(selectedIndex == 3){
            dpShowTimeZoneVisible = !dpShowTimeZoneVisible
        }else{
            dpShowTimeZoneVisible = false
        }
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    var isSelectRow = false;
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            selectedIndex = indexPath.row
            toggleShowDateDatepicker(selectedIndex:indexPath.row)
        }
        isSelectRow = true
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ((!dpShowTimeZoneVisible && indexPath.row == 4)) {
            return 0.0
        } else {
            return 60
        }
    }
    
    private func updateUser(){
        var buyerArr:[String: Any] = [:]
        buyerArr["fullname"] = self.form.fullname
        buyerArr["email"] = self.form.email
        buyerArr["mobile"] = self.form.mobile
        buyerArr["usertimezone"] = getSelectedNameForMenu(fieldName: "usertimezone", value: self.form.usertimezone)
        let jsonString = JsonUtil.toJsonString(jsonObject: buyerArr);
        excecuteUpdateUserCall(jsonstring: jsonString)
    }
    
    private func excecuteUpdateUserCall(jsonstring: String!){
        self.progressHUD.show()
        let json = jsonstring.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let args: [Any] = [self.loggedInUserSeq,json]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.SUBMIT_UPDATE_USER, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.progressHUD.hide()
                    }
                    GlobalData.showAlert(view: self, message: message!,success: success)
                }
            } catch let parseError as NSError {
                GlobalData.showAlert(view: self, message: parseError.description)
            }
        })
    }
    
    func loadEnumData(){
        let args: [Int] = [self.loggedInUserSeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_TIMEZONES, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.enums["usertimezone"] = json["timezones"] as! [String:String]
                        self.prepareSubViews()
                        self.tableView.dataSource = self
                        self.tableView.delegate = self
                        self.getUserDetail()
                        self.progressHUD.hide()
                        if #available(iOS 10.0, *) {
                            self.refreshControl.endRefreshing()
                        }
                    }else{
                        GlobalData.showAlert(view: self, message: message!)
                    }
                }
            } catch let parseError as NSError {
                GlobalData.showAlert(view: self, message: parseError.description)
            }
        })
    }
    
    func getUserDetail(){
        self.progressHUD.show()
        let args: [Int] = [self.loggedInUserSeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_USER_DETAIL, args: args)
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
        editSettingsData = response["user"] as! [String:Any]
        self.form.fullname = editSettingsData["fullname"] as? String
        self.form.email = editSettingsData["email"] as? String
        self.form.mobile = editSettingsData["mobile"] as? String
        self.form.usertimezone = getSelectedValueForMenu(fieldName: "usertimezone")
        self.form.reload()
        self.tableView.reloadData()
    }
    func getSelectedValueForMenu(fieldName:String)->String?{
        if let selectedValueStr = editSettingsData[fieldName] as? String{
            let selctedValuesArr = selectedValueStr.components(separatedBy: ",")
            var selectedValues:[String] = []
            let enumData = enums[fieldName] as! [String:String];
            for value in selctedValuesArr {
                selectedValues.append(enumData[value]!)
            }
            let valueStr = selectedValues.joined(separator: ", ")
            self.editSettingsData[fieldName] = valueStr
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
    func updateValue(valueSent: String, indexPath: IndexPath) {
        self.form.formItems[indexPath.row].value = valueSent;
    }
    func buttonTapped(indexPath: IndexPath) {}
    func getPickerViewData(formItem:FormItem)->[String:String]{
        // if(formItem.isPicker || formItem.isLabel){
        let name = formItem.name!
        if let pickerData = enums[name]{
            return pickerData as! [String : String]
        }
        //}
        return [:]
    }
}
extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.form.formItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var isSetCaption = true
        let item = self.form.formItems[indexPath.row]
        var cell: UITableViewCell
        let pickerViewData:[String:String] = getPickerViewData(formItem: item)
        if let cellType = self.form.formItems[indexPath.row].uiProperties.cellType {
            cell = cellType.dequeueCell(for: tableView, at: indexPath,pickerViewData: pickerViewData,isReadOnlyView: false)
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
