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
   // var selectedBuyer: IDNamePair
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var buyerTableView: UITableView!
    @IBOutlet weak var storeNameLabel: UILabel!
    @IBOutlet weak var buyerTableHeight: NSLayoutConstraint!
    @IBOutlet weak var customerNameLabel: UILabel!
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
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        selectedBuyer = buyerDetailSt[indexPath.row]
//        self.performSegue(withIdentifier: "CustomerDetailController", sender: self)
//    }
    
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
            if(buyer.value == DELETE_CUSTOMER){
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
        }
        buyerTableView.reloadData()
        buyerTableHeight.constant = CGFloat(38 * buyerDetailSt.count)
    }
    func addDeleteButtonLink(){
        var detail = IDNamePair()
        detail.id = String(selectedCustomerSeq)
        detail.value = DELETE_CUSTOMER
        buyerDetailSt.append(detail)
    }
//    func addDeleteBuyerLink(){
//        let view:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 0, height: 50))
//        view.setTitle("Delete Customer", for: .normal)
//        view.setTitleColor(.red, for: UIControl.State.normal)
//        view.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
//        buyerTableView.tableFooterView = view
//    }
    
    @objc func buttonClicked() {
        print("Button Clicked")
    }
}
struct IDNamePair{
    var id:String!
    var value:String?
}
