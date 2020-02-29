//
//  SpringQuestionViewController.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 22/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import Foundation
import UIKit
import RSSelectionMenu
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
    var enums:[String:Any] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.prepareSubViews()
        loggedInUserSeq = PreferencesUtil.sharedInstance.getLoggedInUserSeq()
        progressHUD = ProgressHUD(text: "Processing")
        customerNameLabel.text = customerName
        addEditButton()
        isReadOnly = true
        loadEnumData()
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
        super.viewWillAppear(animated)
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
        arr["customerselectxmasitemsfrom"] = getSelectedNameForMenu(fieldName: "customerselectxmasitemsfrom",value:form.customerselectxmasitemsfrom)
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
    
    func getPickerViewData(formItem:FormItem)->[String:String]{
        if(formItem.isPicker || formItem.isLabel){
            let name = formItem.name!
            if let pickerData = enums[name]{
                return pickerData as! [String : String]
            }
        }
        return [:]
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
                        self.enums["year"] = json["year"] as! [String:String]
                        self.enums["customerselectxmasitemsfrom"] = json["customerselectxmasitemsfrom"] as! [String:String]
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
            tableView.reloadData()
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
            
            self.form.customerselectxmasitemsfrom = getSelectedValueForMenu(fieldName: "customerselectxmasitemsfrom")
            
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
       tableView.reloadData()
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
