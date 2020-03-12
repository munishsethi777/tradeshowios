//
//  ShowSpringQestionsViewController.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 02/03/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import Foundation
import UIKit
class ShowSpringQestionsViewController:UIViewController,UITableViewDelegate{
    var loggedInUserSeq:Int = 0
    var customerSeq:Int = 0;
    var customerName:String = "";
    var storeName:String = "";
    var progressHUD: ProgressHUD!
    var springQuestions: [IDNamePair]!
    var selectedCategory:Int = 0
    var data:[String:Any]!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customerNameLabel: UILabel!
    @IBOutlet weak var storeNameLabel: UILabel!
    var refreshControl:UIRefreshControl!
    override func viewDidLoad() {
        customerNameLabel.text = customerName
        storeNameLabel.text = storeName
        loggedInUserSeq = PreferencesUtil.sharedInstance.getLoggedInUserSeq()
        progressHUD = ProgressHUD(text: "Processing")
        prepareSubViews()
        addNavButton()
        springQuestions = []
        //getSpringQuestionDetail()
        data = [:]
        if #available(iOS 10.0, *) {
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshView), for: .valueChanged)
            tableView.refreshControl = refreshControl
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    @objc func refreshView(control:UIRefreshControl){
        reloadData()
    }
    
    func reloadData(){
        springQuestions = []
        getSpringQuestionDetail()
    }
    
    private func prepareSubViews() {
        FormItemCellType.registerCells(for: self.tableView)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.estimatedRowHeight = 90
    }
    
    func addNavButton(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTapped))
    }
    
    @objc func addTapped(){
        selectedCategory = 0
        self.performSegue(withIdentifier: "AddSpringQuestion", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let secondController = segue.destination as? SpringQuestionViewController {
            secondController.customerName = customerNameLabel.text!
            secondController.customerSeq =  customerSeq
            secondController.selectedCategorySeq = selectedCategory
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let springQuestion = springQuestions[indexPath.row]
        selectedCategory = Int(springQuestion.id)!
        self.performSegue(withIdentifier: "AddSpringQuestion", sender: self)
    }
    
    func getSpringQuestionDetail(){
        if(self.customerSeq == 0){
            tableView.reloadData()
            return
        }
        self.view.addSubview(progressHUD)
        let args: [Int] = [self.loggedInUserSeq,self.customerSeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_SPRING_QUESTIONS_DETAILS, args: args)
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
    
    func loadFormOnEdit(response:[String:Any]){
        if let springQuestions = response["springQues"] as? [Any]{
            for j in 0..<springQuestions.count{
                let springQuestionsJson = springQuestions[j] as! [String: Any]
                let name = springQuestionsJson["id"] as! String
                let value = springQuestionsJson["category"] as! String
                var detail = IDNamePair()
                detail.id = name
                detail.value = value
                self.springQuestions.append(detail)
            }
        }
        tableView.delegate = self
        tableView.dataSource = self
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            let springQues = springQuestions[indexPath.row]
            selectedCategory = Int(springQues.id)!
            deleteConfirm()
        }
    }
    func excuteDeleteCall(){
        self.progressHUD.show()
        let args: [Int] = [self.loggedInUserSeq,self.selectedCategory]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.DELETE_SPRING_QUESTIONS_DETAILS_BY_SEQ, args: args)
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
                        self.springQuestions = []
                        self.getSpringQuestionDetail()
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
            //self.springQuestions = []
            //self.getSpringQuestionDetail()
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteConfirm(){
        let refreshAlert = UIAlertController(title: "Delete Spring Question", message: StringConstants.DELETES_SPRING_QUESTION_CONFIRM, preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.excuteDeleteCall()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
}

extension ShowSpringQestionsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return springQuestions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "ShowSpringQuestionCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ShowSpringQuestionTableViewCell
        let springQues = springQuestions[indexPath.row]
        cell.labelView.tag = Int(springQues.id)!
        cell.labelView.text = "Spring Questions For Category(s) - " + springQues.value!
        return cell
    }
}
