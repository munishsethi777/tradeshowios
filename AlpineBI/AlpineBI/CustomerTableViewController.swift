//
//  CustomerTableViewController.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 29/01/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import Foundation
import UIKit
class CustomerTableViewController : UIViewController, UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate{
    var loggedInUserSeq:Int!
    var customerArr:[Any]!
    var filteredData:[Any]!
    var selectedCustomer:[String:Any]!
    var selectedCustomerSeq:Int = 0
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var customerTableView: UITableView!
    var refreshControl:UIRefreshControl!
    var progressHUD: ProgressHUD!
    var isGoToDetailView = false
    override func viewDidLoad() {
        super.viewDidLoad()
        loggedInUserSeq = PreferencesUtil.sharedInstance.getLoggedInUserSeq();
        customerTableView.dataSource = self
        customerTableView.delegate = self
        searchBar.delegate = self
        customerArr = []
        filteredData = []
        selectedCustomer = [:]
        progressHUD = ProgressHUD(text: "Loading")
        self.hideKeyboardWhenTappedAround()
        if #available(iOS 10.0, *) {
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshView), for: .valueChanged)
            customerTableView.refreshControl = refreshControl
        }
        self.view.addSubview(progressHUD)
        getCustomers()
    }
    @objc func refreshView(control:UIRefreshControl){
        searchBar.text = ""
        getCustomers()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData = searchText.isEmpty ? customerArr : customerArr.filter() {
            if let type = ($0 as! [String:Any])["fullname"] as? String {
                return type.range(of: searchText, options: .caseInsensitive) != nil
            } else {
                return false
            }
        }
        customerTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCustomer = filteredData[indexPath.row] as! [String: Any]
        selectedCustomerSeq = Int(selectedCustomer["seq"] as! String)!
        self.performSegue(withIdentifier: "CustomerDetailController", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "CustomerTableViewCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! CustomerTableViewCell
        let customer = filteredData[indexPath.row] as! [String: Any]
        let customerName = customer["fullname"] as! String
        cell.customerNameLabel.text = customerName
        return cell;
    }
    
    func getCustomers(){
        let args: [Int] = [self.loggedInUserSeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_CUSTOMER_NAMES, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.loadCustomers(response: json)
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
    
    func loadCustomers(response: [String: Any]) {
        customerArr = response["customers"] as! [Any]
        filteredData =  customerArr
        if #available(iOS 10.0, *) {
            self.refreshControl.endRefreshing()
        }
        customerTableView.reloadData()
        if(isGoToDetailView){
            isGoToDetailView = false
            goToDetail()
        }
    }
    func goToDetail(){
        self.performSegue(withIdentifier: "CustomerDetailController", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let secondController = segue.destination as? CustomerDetailViewController {
            secondController.selectedCustomerSeq =  selectedCustomerSeq
        }
    }
}

