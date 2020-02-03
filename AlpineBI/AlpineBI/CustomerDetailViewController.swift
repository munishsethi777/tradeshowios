//
//  CustomerDetailViewController.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 30/01/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import Foundation
import UIKit
class CustomerDetailViewController : UIViewController , UITableViewDataSource, UITableViewDelegate{
    
    var selectedCustomerSeq:Int = 0;
    var loggedInUserSeq:Int = 0;
    var progressHUD: ProgressHUD!
    var customerDetailSt: [IDNamePair]!
    var buyerDetailSt: [IDNamePair]!
    var selectedBuyerSeq:Int = 0
    @IBOutlet weak var detailTableView: UITableView!

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var innerView: UIView!

    @IBOutlet weak var buyerTableView: UITableView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var buyerTableHeight: NSLayoutConstraint!
    @IBOutlet weak var customerNameLabel: UILabel!
    var lastIndexOfBuyerArr:Int = 0
    let DELETE_CUSTOMER = "Delete Customer"
    override func viewDidLoad() {
        super.viewDidLoad()
        loggedInUserSeq = PreferencesUtil.sharedInstance.getLoggedInUserSeq();
        progressHUD = ProgressHUD(text: "Loading")
        getCustomerDetail();
        customerDetailSt = []
        buyerDetailSt = []
        detailTableView.dataSource = self
        detailTableView.delegate = self
        detailTableView.tableFooterView = UIView()
        buyerTableView.dataSource = self
        buyerTableView.delegate = self
        buyerTableView.tableFooterView = UIView()
        self.view.addSubview(progressHUD)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(tableView == detailTableView){
            return customerDetailSt.count
        }else{
            return buyerDetailSt.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBuyer = buyerDetailSt[indexPath.row]
        if(selectedBuyer.value == DELETE_CUSTOMER && lastIndexOfBuyerArr == indexPath.row){
            deleteCustomerConfirm()
        }else{
            selectedBuyerSeq = Int(selectedBuyer.id)!
            self.performSegue(withIdentifier: "BuyerDetailViewController", sender: self)
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         if(tableView == detailTableView){
            let cellIdentifier = "CustomerDetailTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomerDetailTableViewCell
            let customer = customerDetailSt[indexPath.row]
            cell.fieldNameLabel.text = customer.id
            cell.fieldValueLabel.text = customer.value
            return cell
         }else{
            let cellIdentifier = "BuyerTableViewCell"
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BuyerTableViewCell
            cell.buyerNameLabel.text = ""
            let buyer = buyerDetailSt[indexPath.row]
            cell.buyerNameLabel.text = buyer.value
            cell.buyerNameLabel.textColor = .black
            cell.buyerNameLabel.font = UIFont(name:"Helvetica",size: 13.0)
            let lastIndex = buyerDetailSt.count - 1;
            if(buyer.value == DELETE_CUSTOMER && lastIndex == indexPath.row){
                cell.buyerNameLabel.font = UIFont(name:"Helvetica",size: 15.0)
                cell.buyerNameLabel.textColor = .red
            }
            return cell
          }
    }
    
    func getCustomerDetail(){
        let args: [Int] = [self.loggedInUserSeq,self.selectedCustomerSeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_CUSTOMER_DETAIL, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.loadCustomerDetail(jsonReponse: json)
                        self.loadBuyers(jsonReponse: json)
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
    
    func loadCustomerDetail(jsonReponse:[String:Any]){
        let customerDetail = jsonReponse["customerDetail"] as! [Any]
        let cutomername = jsonReponse["customername"] as! String
        let storename = jsonReponse["storename"] as? String
        for j in 0..<customerDetail.count{
            let customerJson = customerDetail[j] as! [String: Any]
            let name = customerJson["name"] as! String
            let value = customerJson["value"] as! String
            var detail = IDNamePair()
            detail.id = name
            detail.value = value
            customerDetailSt.append(detail)
        }
        customerNameLabel.text = cutomername
        storeNameLabel.text = storename
        detailTableView.reloadData()
    }
    
    func loadBuyers(jsonReponse:[String:Any]){
        let buyers = jsonReponse["buyers"] as! [Any]
        for j in 0..<buyers.count{
            let buyerJson = buyers[j] as! [String: Any]
            let name = buyerJson["id"] as! String
            let value = buyerJson["value"] as! String
            var detail = IDNamePair()
            detail.id = name
            detail.value = value
            buyerDetailSt.append(detail)
        }
        if(buyers.count > 0){
            addDeleteButtonLink()
            lastIndexOfBuyerArr = buyerDetailSt.count - 1
        }
        buyerTableView.reloadData()
        buyerTableHeight.constant = CGFloat(38 * buyerDetailSt.count)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let secondController = segue.destination as? BuyerDetailViewController {
            secondController.selectedBuyerSeq =  selectedBuyerSeq
        }
    }
    
    func addDeleteButtonLink(){
        var detail = IDNamePair()
        detail.id = String(selectedCustomerSeq)
        detail.value = DELETE_CUSTOMER
        buyerDetailSt.append(detail)
    }
    
    func deleteCustomerConfirm(){
        let refreshAlert = UIAlertController(title: "Delete Customer", message: "Do you realy want to delete customer.", preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.perfomDeleteCustomer()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    
    func perfomDeleteCustomer(){
        
    }
}
