//
//  AddCustomerViewController.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 03/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import Foundation
import UIKit
class AddCustomerViewController : UIViewController{
    let totalRowsCount:Int = 0
    var loggedInUserSeq:Int = 0
    var progressHUD: ProgressHUD!
    private var form = Form()
    @IBOutlet weak var ibTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loggedInUserSeq = PreferencesUtil.sharedInstance.getLoggedInUserSeq();
        self.form = Form()
        progressHUD = ProgressHUD(text: "Processing")
        self.prepareSubViews()
        ibTableView.dataSource = self
        self.ibTableView.reloadData()
    }
    private func prepareSubViews() {
        FormItemCellType.registerCells(for: self.ibTableView)
        self.ibTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.ibTableView.allowsSelection = false
        self.ibTableView.estimatedRowHeight = 60
        self.ibTableView.rowHeight = UITableView.automaticDimension
        
    }
    @IBAction func doneAction(_ sender: UIBarButtonItem) {
        self.saveCustomer()
    }
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        
    }
    
    func saveCustomer(){
        var customerArr:[String: Any] = [:]
        customerArr["fullname"] = self.form.fullname
        customerArr["customerid"] = self.form.id
        customerArr["salespersonid"] = self.form.salespersonid
        customerArr["salespersonname"] = self.form.salesperson
        customerArr["businesstype"] = self.form.businesstype
        customerArr["createdby"] = self.loggedInUserSeq
        let jsonString = toJsonString(jsonObject: customerArr);
        self.excecuteSaveCustomerCall(jsonstring: jsonString)
    }
    
    func toJsonString(jsonObject:Any)->String{
        let jsonString: String!
        do {
            let postData : NSData = try JSONSerialization.data(withJSONObject: jsonObject, options:[]) as NSData
            jsonString = NSString(data: postData as Data, encoding: String.Encoding.utf8.rawValue)! as String
        } catch {
            jsonString = ""
        }
        return jsonString!
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
                      self.progressHUD.hide()
                    }
                    GlobalData.showAlert(view: self, message: message!)
                }
            } catch let parseError as NSError {
                GlobalData.showAlert(view: self, message: parseError.description)
            }
        })
    }
}

// MARK: - UITableViewDataSource
extension AddCustomerViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.form.formItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.form.formItems[indexPath.row]
        let cell: UITableViewCell
        
        if let cellType = self.form.formItems[indexPath.row].uiProperties.cellType {
            cell = cellType.dequeueCell(for: tableView, at: indexPath)
        } else {
            cell = UITableViewCell() //or anything you want
        }
        if let formUpdatableCell = cell as? FormUpdatable {
            item.indexPath = indexPath
            formUpdatableCell.update(with: item)
        }
        return cell
    }
}
