//
//  SpringQuestionViewController.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 22/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import Foundation
import UIKit
class SpringQuestionViewController : UIViewController,UITableViewDelegate,CallBackProtocol{
    var loggedInUserSeq:Int = 0
    var customerSeq:Int = 0;
    var customerName:String = "";
    var selectedCategorySeq:Int = 0;
    var progressHUD: ProgressHUD!
    var editProgSeq:Int = 0
    var form = SpringQuestionForm()
    var isReadOnly = true;
    var enums:[String:Any] = [:]
    var editProgData:[String:Any] = [:]
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customerNameLabel: UILabel!
    var refreshControl:UIRefreshControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareSubViews()
        loggedInUserSeq = PreferencesUtil.sharedInstance.getLoggedInUserSeq()
        progressHUD = ProgressHUD(text: "Processing")
        customerNameLabel.text = customerName
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        super.viewDidLoad()
        isReadOnly = true
        loadEnumData()
        if #available(iOS 10.0, *) {
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshView), for: .valueChanged)
            tableView.refreshControl = refreshControl
        }
    }
    @objc func refreshView(control:UIRefreshControl){
        reloadData()
    }
    
    func reloadData(){
       loadEnumData()
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
        addDoneButton()
        tableView.reloadData()
    }
    
    func addDoneButton(){
         self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveSpringQuestion))
    }
    func buttonTapped(indexPath: IndexPath) {}
    func updateValue(valueSent: String, indexPath: IndexPath) {
        form.formItems[indexPath.row].value = valueSent
        tableView?.beginUpdates()
        tableView?.endUpdates()
    }
    @objc private func saveSpringQuestion(){
        var arr = self.form.toArray(swiftClass: self.form);
        arr["seq"] = self.selectedCategorySeq
        arr["customerseq"] = self.customerSeq
        arr["year"] = getSelectedNameForMenu(fieldName: "year",value:form.year)
        arr["category"] = getSelectedNameForMenu(fieldName: "category",value:form.category)
        arr["categoriesshouldsellthem"] = getSelectedNameForMenu(fieldName: "categoriesshouldsellthem",value:form.category)
        let jsonString = JsonUtil.toJsonString(jsonObject: arr);
        excecuteSaveCall(jsonstring: jsonString)
    }
    
    func getSpringQuestionDetail(){
        if(self.customerSeq == 0){
            tableView.reloadData()
            return
        }
        self.view.addSubview(progressHUD)
        let args: [Int] = [self.loggedInUserSeq,self.selectedCategorySeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_SPRING_QUESTIONS_DETAILS_BY_SEQ, args: args)
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
        if let editProgData = response["springQues"] as? [String:Any]{
            self.editProgData = editProgData
            self.form.categoriesshouldsellthem = getSelectedValueForMenu(fieldName: "customerselectxmasitemsfrom")
            self.form.category = getSelectedValueForMenu(fieldName: "category")
            self.form.year = getSelectedValueForMenu(fieldName: "year")
            let christmasQuoteByDate = editProgData["christmasquotebydate"] as? String
            self.form.christmasquotebydate = getDateString(dateStr: christmasQuoteByDate)
            self.form.customerselectingspringitemsfrom = editProgData["editProgData"] as? String
            let invitedToSpringShowroomDate = editProgData["invitedtospringshowroomdate"] as? String
            self.form.invitedtospringshowroomdate = getDateString(dateStr: invitedToSpringShowroomDate)
            let invitedToSpringShowroomReminderDate = editProgData["invitedtospringshowroomreminderdate"] as? String
            self.form.invitedtospringshowroomreminderdate = getDateString(dateStr: invitedToSpringShowroomReminderDate)
            self.form.iscomposhopcompleted = editProgData["iscomposhopcompleted"] as? String == "1" ? "Yes" : "No"
            self.form.iscompshopsummaryemailsent = editProgData["iscompshopsummaryemailsent"] as? String == "1" ? "Yes" : "No"
            self.form.isinvitedtospringshowroom = editProgData["iscompshopsummaryemailsent"] as? String == "1" ? "Yes" : "No"
            self.form.ispitchmainvendor = editProgData["iscompshopsummaryemailsent"] as? String == "1" ? "Yes" : "No"
            self.form.isrobbyreviewedsellthrough = editProgData["isrobbyreviewedsellthrough"] as? String == "1" ? "Yes" : "No"
            self.form.issellthrough = editProgData["isrobbyreviewedsellthrough"] as? String == "1" ? "Yes" : "No"
            self.form.issentcataloglink = editProgData["isrobbyreviewedsellthrough"] as? String == "1" ? "Yes" : "No"
            self.form.issentsample = editProgData["isrobbyreviewedsellthrough"] as? String == "1" ? "Yes" : "No"
            self.form.isstrategicplanningmeeting = editProgData["isstrategicplanningmeeting"] as? String == "1" ? "Yes" : "No"
            self.form.isvisitcustomer2qtr = editProgData["isstrategicplanningmeeting"] as? String == "1" ? "Yes" : "No"
            self.form.isvisitcustomerduring2ndqtr = editProgData["isstrategicplanningmeeting"] as? String == "1" ? "Yes" : "No"
            self.form.pitchmainvendornotes = editProgData["pitchmainvendornotes"] as? String == "1" ? "Yes" : "No"
            let quoteSpringByDate = editProgData["quotespringbydate"] as? String
            self.form.quotespringbydate = getDateString(dateStr: quoteSpringByDate)
            self.form.sentcataloglinknotes = editProgData["sentcataloglinknotes"] as? String
            let springReviewingDate = editProgData["springreviewingdate"] as? String
            self.form.springreviewingdate = getDateString(dateStr: springReviewingDate)
            let strategicPlanningMeetingDate = editProgData["strategicplanningmeetingdate"] as? String
            self.form.strategicplanningmeetingdate = getDateString(dateStr: strategicPlanningMeetingDate)
            self.form.reload()
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
            let valueStr = selectedValues.joined(separator: ", ")
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
    
    private func excecuteSaveCall(jsonstring: String!){
        self.progressHUD.show()
        let json = jsonstring.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let args: [Any] = [self.loggedInUserSeq,json]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.SAVE_SPRING_QUESTION_DETAILS, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.selectedCategorySeq = Int(json["seq"] as! Int)
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
    
    private func getPickerViewData(formItem:FormItem)->[String:String]{
        let name = formItem.name!
        if let pickerData = enums[name]{
            return pickerData as! [String : String]
        }
        return [:]
    }
    func loadEnumData(){
        let args: [Int] = [self.loggedInUserSeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_ENUMS_FOR_SPRING_QUESTION, args: args)
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
                        self.enums["category"] = json["categoryTypes"] as! [String:String]
                        self.enums["categoriesshouldsellthem"] = json["categoryTypes"] as! [String:String]
                        self.prepareSubViews()
                        self.tableView.dataSource = self
                        self.tableView.delegate = self
                        if(self.selectedCategorySeq > 0){
                            self.getSpringQuestionDetail()
                            self.addEditButton()
                        }else{
                            self.isReadOnly = false
                            self.addDoneButton()
                        }
                        self.progressHUD.hide()
                        if #available(iOS 10.0, *) {
                            self.refreshControl.endRefreshing()
                        }
                        self.tableView.reloadData()
                    }else{
                        GlobalData.showAlert(view: self, message: message!)
                    }
                }
            } catch let parseError as NSError {
                GlobalData.showAlert(view: self, message: parseError.description)
            }
        })
    }
    
}

extension SpringQuestionViewController: UITableViewDataSource {
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
        var cell: UITableViewCell
        if let cellType = self.form.formItems[indexPath.row].uiProperties.cellType {
            cell = cellType.dequeueCell(for: tableView, at: indexPath,pickerViewData: pickerViewData,isReadOnlyView: isReadOnly)
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

