//
//  BuyerDetailViewController.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 01/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import Foundation
import UIKit
class BuyerDetailViewController : UIViewController,UITableViewDelegate,UITableViewDataSource{
    var selectedBuyerSeq:Int = 0;
    var loggedInUserSeq:Int = 0;
    var progressHUD: ProgressHUD!
    var buyerDetailSt: [IDNamePair]!
    var lastIndexOfBuyerArr:Int = 0;
    var secondLastIndexOfBuyerArr:Int = 0;
    let DELETE_BUYER = "Delete Buyer"
    let SAVE_IN_CONTACTS = "Save In Contacts"
    @IBOutlet weak var buyerNameLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var buyerDetailTableView: UITableView!
    @IBAction func callButtonAction(_ sender: Any) {
        GlobalData.showAlert(view: self, message: "Clicked")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        loggedInUserSeq = PreferencesUtil.sharedInstance.getLoggedInUserSeq();
        progressHUD = ProgressHUD(text: "Loading")
        buyerDetailTableView.delegate = self
        buyerDetailTableView.dataSource = self
        getBuyerDetail()
        buyerDetailSt = []
        self.view.addSubview(progressHUD)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buyerDetailSt.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBuyer = buyerDetailSt[indexPath.row]
        if(selectedBuyer.value == DELETE_BUYER && lastIndexOfBuyerArr == indexPath.row){
            deleteBuyerConfirm()
        }else{
            selectedBuyerSeq = Int(selectedBuyer.id)!
            self.performSegue(withIdentifier: "BuyerDetailViewController", sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "BuyerDetailTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BuyerDetailTableViewCell
        let buyer = buyerDetailSt[indexPath.row]
        cell.fieldNameLabel.text = buyer.id
        cell.fieldValueLabel.text = buyer.value
        cell.fieldValueLabel.textColor = cell.hiddenLabel.textColor
        cell.fieldValueLabel.font = cell.hiddenLabel.font
        if(buyer.value == SAVE_IN_CONTACTS && secondLastIndexOfBuyerArr == indexPath.row){
            cell.fieldNameLabel.text = ""
        }
        if(buyer.value == DELETE_BUYER && lastIndexOfBuyerArr == indexPath.row){
            cell.fieldNameLabel.text = ""
            cell.fieldValueLabel.font = UIFont(name:"Helvetica",size: 15.0)
            cell.fieldValueLabel.textColor = .red
        }
        return cell
    }
    
    func getBuyerDetail(){
        let args: [Int] = [self.loggedInUserSeq,self.selectedBuyerSeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_BUYER_DETAIL, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.loadBuyerDetail(jsonResponse: json)
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
    
    func loadBuyerDetail(jsonResponse: [String: Any]){
        let buyer = jsonResponse["buyer"] as! [Any]
        let buyerName = jsonResponse["buyername"] as! String
        for j in 0..<buyer.count{
            let buyerJson = buyer[j] as! [String: Any]
            let name = buyerJson["name"] as! String
            let value = buyerJson["value"] as! String
            var detail = IDNamePair()
            detail.id = name
            detail.value = value
            buyerDetailSt.append(detail)
        }
        buyerNameLabel.text = buyerName
        if(buyer.count > 0){
            addSaveInContactButtonLink()
            addDeleteButtonLink()
            lastIndexOfBuyerArr = buyerDetailSt.count - 1
            secondLastIndexOfBuyerArr = lastIndexOfBuyerArr - 1
        }
        buyerDetailTableView.reloadData()
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: 1200.00)
    }
    
    func addSaveInContactButtonLink(){
        var detail = IDNamePair()
        detail.id = String(selectedBuyerSeq)
        detail.value = SAVE_IN_CONTACTS
        buyerDetailSt.append(detail)
    }
    
    func addDeleteButtonLink(){
        var detail = IDNamePair()
        detail.id = String(selectedBuyerSeq)
        detail.value = DELETE_BUYER
        buyerDetailSt.append(detail)
    }
    
    func deleteBuyerConfirm(){
        let refreshAlert = UIAlertController(title: DELETE_BUYER, message: "Are you realy want to delete buyer.", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.perfomDeleteBuyer()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func perfomDeleteBuyer(){
        
    }
    
    
}
