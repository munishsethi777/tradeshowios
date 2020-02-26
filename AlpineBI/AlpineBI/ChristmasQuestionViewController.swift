//
//  SpringQuestionViewController.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 22/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import Foundation
import UIKit
class ChristmasQuestionViewController : UIViewController,UITableViewDelegate{
    var loggedInUserSeq:Int = 0
    var customerSeq:Int = 0;
    var customerName:String = "";
    var progressHUD: ProgressHUD!
    var editProgSeq:Int = 0
    var form = ChristmasQuestionForm()
    var isReadOnly = true;
    var editProgData:[String:Any] = [:]
    @IBOutlet weak var customerNameLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    private var dpShowYearPickerVisible = false
    private var dpShowXmasItemPickerVisible = false
    private var dpShowMeetingDatePickerVisible = false
    private var dpShowInvitedXmassShowroomDatePickerVisible = false
    private var dpShowXmassShowroomReminderDatePickerVisible = false
    private var dpShowChristmas2020DatePickerVisible = false
    private var dpShowQuoteChristmasDatePickerVisible = false
    var emums:[String:Any] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareSubViews()
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
    private func prepareSubViews() {
        FormItemCellType.registerCells(for: self.tableView)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.allowsSelection = false
        self.tableView.estimatedRowHeight = 90
    }
    override func viewWillAppear(_ animated: Bool) {
        isReadOnly = true
        super.viewWillAppear(animated)
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
    func addEditButton(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
    }
    @objc func editTapped(){
        isReadOnly = false
        tableView.reloadData()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveChritmasQuestion))
    }
    @objc func saveChritmasQuestion(){
        var arr = self.form.toArray();
        arr["customerseq"] = self.customerSeq
        let jsonString = JsonUtil.toJsonString(jsonObject: arr);
        excecuteSaveCall(jsonstring: jsonString)
    }
    
    private func excecuteSaveCall(jsonstring: String!){
        self.progressHUD.show()
        let json = jsonstring.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let args: [Any] = [self.loggedInUserSeq,json]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.SAVE_CHRISTMAS_QUESTION_DETAILS, args: args)
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
                    GlobalData.showAlert(view: self, message: message!)
                }
            } catch let parseError as NSError {
                GlobalData.showAlert(view: self, message: parseError.description)
            }
        })
    }
    
    private func resetPickerState(){
        dpShowYearPickerVisible = false
        dpShowXmasItemPickerVisible = false
        dpShowMeetingDatePickerVisible = false
        dpShowInvitedXmassShowroomDatePickerVisible = false
        dpShowXmassShowroomReminderDatePickerVisible = false
        dpShowChristmas2020DatePickerVisible = false
        dpShowQuoteChristmasDatePickerVisible = false
    }
    func getPickerViewData(formItem:FormItem)->[String:String]{
        if(formItem.isPicker || formItem.isLabel){
            var name = formItem.name!
            if(name.contains("picker")){
                name.removeLast(6)
            }
            if let pickerData = emums[name]{
                return pickerData as! [String : String]
            }
        }
        return [:]
    }
    
    
    
    func getPickerViewSelectedValue(formItem:FormItem)->String?{
        var name = formItem.name!
        if(name.contains("picker")){
            name.removeLast(6)
        }
        return editProgData[name] as? String
    }
    
    func buttonTappedCallBack(fieldName:String?){
        if(fieldName == "year"){
            dpShowYearPickerVisible = !dpShowYearPickerVisible
            //dpShowXmasItemPickerVisible = false
        }
        if(fieldName == "customerselectxmasitemsfrom"){
            dpShowXmasItemPickerVisible = !dpShowXmasItemPickerVisible
            //dpShowYearPickerVisible = false
        }
        if(fieldName == "strategicplanningmeetdate"){
            dpShowMeetingDatePickerVisible = !dpShowMeetingDatePickerVisible
        }
        if(fieldName == "invitedtoxmasshowroomdate"){
            dpShowInvitedXmassShowroomDatePickerVisible = !dpShowInvitedXmassShowroomDatePickerVisible
        }
        if(fieldName == "invitedtoxmasshowroomreminderdate"){
            dpShowXmassShowroomReminderDatePickerVisible = !dpShowXmassShowroomReminderDatePickerVisible
        }
        if(fieldName == "christmas2020reviewingdate"){
            dpShowChristmas2020DatePickerVisible = !dpShowChristmas2020DatePickerVisible
        }
        if(fieldName == "christmasquotebydate"){
            dpShowQuoteChristmasDatePickerVisible = !dpShowQuoteChristmasDatePickerVisible
        }
        tableView.reloadData()
        //let indexPath = IndexPath(row: 19, section: 0)
        //self.tableView.reloadRows(at:[indexPath], with: .none)
    }
    
    func UpdateCallback(selectedValue:String,indexPath:IndexPath) //add this extra method
    {
        form.formItems[indexPath.row].value = selectedValue
        if(form.formItems[indexPath.row].name == "year"){
            form.year = selectedValue
            editProgData["year"] = selectedValue
        }
        if(form.formItems[indexPath.row].name == "customerselectxmasitemsfrom"){
            form.customerselectxmasitemsfrom = selectedValue
            editProgData["customerselectxmasitemsfrom"] = selectedValue
        }
        if(form.formItems[indexPath.row].name == "strategicplanningmeetdate"){
            form.strategicplanningmeetdate = selectedValue
            editProgData["strategicplanningmeetdate"] = selectedValue
        }
        if(form.formItems[indexPath.row].name == "invitedtoxmasshowroomdate"){
            form.invitedtoxmasshowroomdate = selectedValue
            editProgData["invitedtoxmasshowroomdate"] = selectedValue
        }
        if(form.formItems[indexPath.row].name == "invitedtoxmasshowroomreminderdate"){
            form.invitedtoxmasshowroomreminderdate = selectedValue
            editProgData["invitedtoxmasshowroomreminderdate"] = selectedValue
        }
        if(form.formItems[indexPath.row].name == "christmas2020reviewingdate"){
            form.christmas2020reviewingdate = selectedValue
            editProgData["christmas2020reviewingdate"] = selectedValue
        }
        if(form.formItems[indexPath.row].name == "christmasquotebydate"){
            form.christmasquotebydate = selectedValue
            editProgData["christmasquotebydate"] = selectedValue
        }
        editProgData[form.formItems[indexPath.row].name!] = selectedValue
        self.tableView.reloadRows(at:[indexPath], with: .none)
        //reloadTable()
    }
    
    private func isHiddenCell(row:Int)->Bool{
        var isHidden:Bool = false
        if(row == 1 && !dpShowYearPickerVisible){
            isHidden = true
        }
        if(row == 8 && !dpShowMeetingDatePickerVisible){
            isHidden = true
        }
        if(row == 11 && !dpShowInvitedXmassShowroomDatePickerVisible){
            isHidden = true
        }
        if(row == 13 && !dpShowXmassShowroomReminderDatePickerVisible){
            isHidden = true
        }
        if(row == 17 && !dpShowChristmas2020DatePickerVisible){
            isHidden = true
        }
        if(row == 19 && !dpShowXmasItemPickerVisible){
            isHidden = true
        }
        if(row == 27 && !dpShowQuoteChristmasDatePickerVisible){
            isHidden = true
        }
        return isHidden
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
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_ENUMS_FOR_QUESTIONNARIE, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.emums["year"] = json["year"] as! [String:String]
                        self.emums["customerselectxmasitemsfrom"] = json["customerselectxmasitemsfrom"] as! [String:String]
                        self.prepareSubViews()
                        self.tableView.dataSource = self
                        self.tableView.delegate = self
                        self.getChristmasQuestionDetails()
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
    func getChristmasQuestionDetails(){
        if(self.customerSeq == 0){
            reloadTable()
            return
        }
        self.view.addSubview(progressHUD)
        let args: [Int] = [self.loggedInUserSeq,self.customerSeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_CHRISTMAS_QUESTIONS_DETAILS, args: args)
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
    func getDateString(dateStr:String?)->String?{
        return DateUtil.convertToFormat(dateString:dateStr, fromFomat: DateUtil.dateFormat1, toFormat: DateUtil.dateFormat2)
    }
    func loadFormOnEdit(response:[String:Any]){
        if let editProgData = response["christmasQuestionDetails"] as? [String:Any]{
            self.editProgData = editProgData
            self.form.cataloglinksentnotes = editProgData["cataloglinksentnotes"] as? String
            self.form.christmas2020reviewingdate = editProgData["defectivepercent"] as? String
            let christmas2020ReviewingDate = editProgData["christmas2020reviewingdate"] as? String
            self.form.christmas2020reviewingdate = getDateString(dateStr: christmas2020ReviewingDate)
            self.editProgData["christmas2020reviewingdate"] =  self.form.christmas2020reviewingdate
            
            let christmasQuoteByDate = editProgData["christmasquotebydate"] as? String
            self.form.christmasquotebydate = getDateString(dateStr: christmasQuoteByDate)
            self.editProgData["christmasquotebydate"] =  self.form.christmasquotebydate
            
            self.form.customerselectxmasitemsfrom = editProgData["customerselectxmasitemsfrom"] as? String
            
            let invitedToXmasShowroomDate = editProgData["invitedtoxmasshowroomdate"] as? String
            self.form.invitedtoxmasshowroomdate = getDateString(dateStr: invitedToXmasShowroomDate)
            self.editProgData["invitedtoxmasshowroomdate"] =  self.form.invitedtoxmasshowroomdate
            
            let invitedToXmasShowroomRemiderDate = editProgData["invitedtoxmasshowroomreminderdate"] as? String
            self.form.invitedtoxmasshowroomreminderdate = getDateString(dateStr: invitedToXmasShowroomRemiderDate)
            self.editProgData["invitedtoxmasshowroomreminderdate"] =  self.form.invitedtoxmasshowroomreminderdate
            
            self.form.iscataloglinksent = editProgData["iscataloglinksent"] as? String
            
            self.form.isholidayshopcompleted = editProgData["isholidayshopcompleted"] as? String
            self.form.isholidayshopcomsummaryemailsent = editProgData["isholidayshopcomsummaryemailsent"] as? String
            self.form.isinterested = editProgData["isinterested"] as? String
            self.form.isinvitedtoxmasshowroom = editProgData["isinvitedtoxmasshowroom"] as? String
            self.form.ismainvendor = editProgData["ismainvendor"] as? String
            self.form.isreceivingsellthru = editProgData["isreceivingsellthru"] as? String
            self.form.isrobbyreviewedsellthrough = editProgData["isrobbyreviewedsellthrough"] as? String
            self.form.isstrategicplanningmeetingappointment = editProgData["isstrategicplanningmeetingappointment"] as? String
            self.form.isvisitcustomerin4qtr = editProgData["isvisitcustomerin4qtr"] as? String
            self.form.isxmasbuylastyear = editProgData["isxmasbuylastyear"] as? String
            self.form.isxmassamplessent = editProgData["isxmassamplessent"] as? String
            self.form.mainvendornotes = editProgData["mainvendornotes"] as? String
            
            let strategicPlanningMeetDate = editProgData["strategicplanningmeetdate"] as? String
            self.form.strategicplanningmeetdate = getDateString(dateStr: strategicPlanningMeetDate)
            self.editProgData["strategicplanningmeetdate"] =  self.form.strategicplanningmeetdate
            self.form.xmasbuylastyearamount = editProgData["xmasbuylastyearamount"] as? String
            self.form.year = editProgData["year"] as? String
        }
       reloadTable()
    }
    func reloadTable(){
        let contentOffset = self.tableView.contentOffset
        self.tableView.reloadData()
        self.tableView.layoutIfNeeded()
        self.tableView.setContentOffset(contentOffset, animated: false)
    }
}

extension ChristmasQuestionViewController: UITableViewDataSource {
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
            
            if let pickerViewCell = cell as? YesNoViewTableViewCell {
                pickerViewCell.labelFieldCellIndex = IndexPath(row: indexPath.row, section: indexPath.section)
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
