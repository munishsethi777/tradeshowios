//
//  OppurtunityQuestionViewController.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 27/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import UIKit
import RSSelectionMenu
class OppurtunityQuestionViewController: UIViewController {
    var loggedInUserSeq:Int = 0
    var customerSeq:Int = 0;
    var customerNameStr:String = "";
    var progressHUD: ProgressHUD!
    var editProgSeq:Int = 0
    var form = OppurtunityQuestionForm()
    var isReadOnly = true;
    var editProgData:[String:Any] = [:]
    var emums:[String:Any] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        customerName.text = customerNameStr
        prepareSubViews()
        addEditButton()
        isReadOnly = true
        self.loggedInUserSeq = PreferencesUtil.sharedInstance.getLoggedInUserSeq()
        loadEnumData()
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customerName: UILabel!
    private func prepareSubViews() {
        FormItemCellType.registerCells(for: self.tableView)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.allowsSelection = false
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        progressHUD = ProgressHUD(text: "Processing")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func addEditButton(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
    }
    
    @objc func editTapped(){
        isReadOnly = false
        tableView.reloadData()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveOppurtunityQuestion))
    }
    
    @objc func saveOppurtunityQuestion(){
        var arr = self.form.toArray(swiftClass: self.form);
        arr["customerseq"] = self.customerSeq
        let jsonString = JsonUtil.toJsonString(jsonObject: arr);
        excecuteSaveCall(jsonstring: jsonString)
    }
    func getPickerViewData(formItem:FormItem)->[String:String]{
        if(formItem.isPicker || formItem.isLabel){
            let name = formItem.name!
            if let pickerData = emums[name]{
                return pickerData as! [String : String]
            }
        }
        return [:]
    }
    func loadEnumData(){
        let args: [Int] = [self.loggedInUserSeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_ENUMS_FOR_OPPURTUNITY_QUESTION, args: args)
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
                        self.emums["tradeshowsgoingto"] = json["seasonShowNameTypes"] as! [String:String]
                        self.prepareSubViews()
                        self.tableView.dataSource = self
                        self.getChristmasQuestionDetails()
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
    func getChristmasQuestionDetails(){
        if(self.customerSeq == 0){
            tableView.reloadData()
            return
        }
        self.view.addSubview(progressHUD)
        let args: [Int] = [self.loggedInUserSeq,self.customerSeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_OPPURTUNITY_QUESTIONS_DETAILS, args: args)
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
        if let editProgData = response["oppurtunityBuysDetails"] as? [String:Any]{
            self.editProgData = editProgData
            let closeoutleftoversincedate = editProgData["closeoutleftoversincedate"] as? String
            self.form.closeoutleftoversincedate = getDateString(dateStr: closeoutleftoversincedate)
            self.editProgData["closeoutleftoversincedate"] =  self.form.closeoutleftoversincedate
            self.form.isxmascateloglinksent = editProgData["isxmascateloglinksent"] as? String
            if let selectedValueStr = editProgData["tradeshowsgoingto"] as? String{
                let selctedValuesArr = selectedValueStr.components(separatedBy: ",")
                var selectedValues:[String] = []
                let tradeShowsGoingtoTypes = emums["tradeshowsgoingto"] as! [String:String];
                for value in selctedValuesArr {
                    selectedValues.append(tradeShowsGoingtoTypes[value]!)
                }
                let valueStr = selectedValues.joined(separator: ",")
                self.form.tradeshowsgoingto = valueStr
                self.editProgData["tradeshowsgoingto"] = valueStr
            }
            self.form.year = editProgData["year"] as? String
        }
        tableView.reloadData()
    }
    
    private func excecuteSaveCall(jsonstring: String!){
        self.progressHUD.show()
        let json = jsonstring.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let args: [Any] = [self.loggedInUserSeq,json]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.SAVE_OPPURTUNITY_QUESTION_DETAILS, args: args)
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
}

extension OppurtunityQuestionViewController: UITableViewDataSource {
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
