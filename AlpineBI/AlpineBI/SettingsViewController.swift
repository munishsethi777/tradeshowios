//
//  SettingsViewController.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 12/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController ,UITableViewDelegate{
    var loggedInUserSeq:Int = 0
    var progressHUD: ProgressHUD!
    private var form = SettingForm()
    private var editSettingsData:[String:Any] = [:]
    private var timeZones:[String:String] = [:]
    private var dpShowTimeZoneVisible = false
    private var selectedIndex = 0;
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loggedInUserSeq = PreferencesUtil.sharedInstance.getLoggedInUserSeq()
        tableView.delegate = self
        tableView.dataSource = self
        progressHUD = ProgressHUD(text: "Processing")
        prepareSubViews()
        hideKeyboardWhenTappedAround()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
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
        getUserDetail()
    }
    
    @IBAction func updateTapped(_ sender: Any) {
        updateUser()
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
        buyerArr["usertimezone"] = self.form.usertimezone
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
                    GlobalData.showAlert(view: self, message: message!)
                }
            } catch let parseError as NSError {
                GlobalData.showAlert(view: self, message: parseError.description)
            }
        })
    }
    func getUserDetail(){
        self.view.addSubview(progressHUD)
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
        self.form.usertimezone = editSettingsData["usertimezone"] as? String
        self.tableView.reloadData()
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
        let isSetCaption = true
        let item = self.form.formItems[indexPath.row]
        let name = item.name
        if let val = editSettingsData[name!] as? String {
            item.value = val
            if(name == "usertimezone" && val != ""){
                if let v = timeZones[val] {
                    item.value = v;
                }
            }
        }
        var cell: UITableViewCell
        let pickerViewData:[String:String] = timeZones
        if let cellType = self.form.formItems[indexPath.row].uiProperties.cellType {
            if(item.isPicker  && cellType == FormItemCellType.pickerView){
                item.value = editSettingsData["usertimezone"] as? String
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
            formUpdatableCell.update(with: item,isSetCaption:isSetCaption)
        }
        return cell
    }
    
}
