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
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var customerTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        loggedInUserSeq = PreferencesUtil.sharedInstance.getLoggedInUserSeq();
        customerTableView.dataSource = self
        customerTableView.delegate = self
        searchBar.delegate = self
        customerArr = []
        filteredData = []
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
        customerTableView.reloadData()
    }
}

struct customer {
    let fullname: String
    let seq: Int
}

extension Dictionary
{
    func filteredDictionary(_ isIncluded: (Key, Value) -> Bool)  -> Dictionary<Key, Value>
    {
        return self.filter(isIncluded).toDictionary(byTransforming: { $0 })
    }
}

extension Array
{
    func toDictionary<H:Hashable, T>(byTransforming transformer: (Element) -> (H, T)) -> Dictionary<H, T>
    {
        var result = Dictionary<H,T>()
        self.forEach({ element in
            let (key,value) = transformer(element)
            result[key] = value
        })
        return result
    }
}
