//
//  BuyerDetailViewController.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 01/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import Foundation
import Contacts
import ContactsUI
import UIKit
import MessageUI
class BuyerDetailViewController : UIViewController,UITableViewDelegate,UITableViewDataSource,CNContactViewControllerDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate{
    var selectedBuyerSeq:Int = 0;
    var loggedInUserSeq:Int = 0;
    var progressHUD: ProgressHUD!
    var buyerDetailSt: [IDNamePair]!
    var lastIndexOfBuyerArr:Int = 0;
    var secondLastIndexOfBuyerArr:Int = 0;
    let DELETE_BUYER = "Delete Buyer"
    let SAVE_IN_CONTACTS = "Save In Contacts"
    var selectedBuyerPhone:String?
    var selectedBuyerFName:String?
    var selectedBuyerLName:String?
    var selectedBuyerEmail:String?
    @IBOutlet weak var buyerNameLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var buyerActionView: UIView!
    @IBOutlet weak var buyerDetailTableView: UITableView!
    var refreshControl:UIRefreshControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        loggedInUserSeq = PreferencesUtil.sharedInstance.getLoggedInUserSeq();
        progressHUD = ProgressHUD(text: "Loading")
        buyerDetailTableView.delegate = self
        buyerDetailTableView.dataSource = self
        buyerDetailSt = []

        getBuyerDetail()
       
        self.view.addSubview(progressHUD)
        if #available(iOS 10.0, *) {
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshView), for: .valueChanged)
            scrollView.refreshControl = refreshControl
        }
        
    }
    @objc func refreshView(control:UIRefreshControl){
        buyerDetailSt = []
        getBuyerDetail()
    }
    @IBAction func sms1Button(_ sender: Any) {
        sendSMS()
    }
    @IBAction func whatsapp1Button(_ sender: Any) {
        sendWhatsAppMessage()
    }
    @IBAction func email1Button(_ sender: Any) {
        sendEmail()
    }
    @IBAction func call1Button(_ sender: Any) {
        makeAPhoneCall()
    }
    @IBAction func smsButton(_ sender: Any) {
        sendSMS()
    }
    @IBAction func whatsappButton(_ sender: Any) {
        sendWhatsAppMessage()
    }
    @IBAction func emailButton(_ sender: Any) {
        sendEmail()
    }
    @IBAction func callButton(_ sender: Any) {
        makeAPhoneCall()
    }
    
    func makeAPhoneCall()  {
        if(selectedBuyerPhone != nil && selectedBuyerPhone != ""){
            let url: NSURL = URL(string: "TEL://" + selectedBuyerPhone!)! as NSURL
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }else{
            GlobalData.showAlert(view: self, message: StringConstants.PHONE_NOT_AVAILABLE)
        }
    }
    
    func sendEmail(){
        if(selectedBuyerEmail != nil && selectedBuyerEmail != ""){
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([selectedBuyerEmail!])
                present(mail, animated: true)
            } else {
                let email = selectedBuyerEmail!
                if let url = URL(string: "mailto:\(email)") {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        }else{
            GlobalData.showAlert(view: self, message: StringConstants.EMAIL_NOT_AVAILABLE)
        }
    }
    
    func sendSMS(){
        if(selectedBuyerPhone != nil && selectedBuyerPhone != ""){
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                controller.recipients = [selectedBuyerPhone!]
                controller.messageComposeDelegate = self
                self.present(controller, animated: true, completion: nil)
            }
        }else{
            GlobalData.showAlert(view: self, message: StringConstants.PHONE_NOT_AVAILABLE)
        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func sendWhatsAppMessage(){
        if(selectedBuyerPhone != nil && selectedBuyerPhone != ""){
            //        var str = "Hello"
            //        str = str.addingPercentEncoding(withAllowedCharacters: (NSCharacterSet.urlQueryAllowed))!
            //        let whatsappURL = NSURL(string: "whatsapp://send?text=\(str)")
            //
            //        if UIApplication.shared.canOpenURL(whatsappURL! as URL) {
            //             UIApplication.shared.open(whatsappURL! as URL, options: [:], completionHandler: nil)
            //        } else {
            //            GlobalData.showAlert(view: self, message: StringConstants.WHATS_APP_NOT_INSTALLED)
            //        }
            let urlWhats = "whatsapp://send?phone=91"+selectedBuyerPhone!+"&abid=12354&text="
            if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
                if let whatsappURL = URL(string: urlString) {
                    if UIApplication.shared.canOpenURL(whatsappURL) {
                        UIApplication.shared.open(whatsappURL as URL, options: [:], completionHandler: nil)
                    } else {
                        print("Install Whatsapp")
                    }
                }
            }
        }else{
            GlobalData.showAlert(view: self, message: StringConstants.PHONE_NOT_AVAILABLE)
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return buyerDetailSt.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedBuyer = buyerDetailSt[indexPath.row]
        if(selectedBuyer.value == DELETE_BUYER && lastIndexOfBuyerArr == indexPath.row){
            deleteBuyerConfirm()
        }
        if(selectedBuyer.value == SAVE_IN_CONTACTS && secondLastIndexOfBuyerArr == indexPath.row){
            saveInContacts()
        }
    }
    
    func saveInContacts(){
        let con = CNMutableContact()
        con.givenName = selectedBuyerFName ??  ""
        con.familyName = selectedBuyerLName ?? ""
        con.phoneNumbers.append(CNLabeledValue(
            label: "Cell Phone", value: CNPhoneNumber(stringValue: selectedBuyerPhone ??  "")))
        con.emailAddresses.append(CNLabeledValue(label: "Email",value:(selectedBuyerEmail ?? "") as NSString))
        let unkvc = CNContactViewController(forUnknownContact: con)
        unkvc.contactStore = CNContactStore()
        unkvc.delegate = self
        unkvc.allowsActions = false
        self.navigationController?.pushViewController(unkvc, animated: true)
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
                        self.buyerDetailTableView.reloadData()
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
        selectedBuyerFName = jsonResponse["buyerfirstname"] as? String
        selectedBuyerLName = jsonResponse["buyerlastname"] as? String
        selectedBuyerPhone = jsonResponse["buyercellphone"] as? String
        selectedBuyerEmail = jsonResponse["buyeremail"] as? String
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
        if #available(iOS 10.0, *) {
            self.refreshControl.endRefreshing()
        }
        buyerDetailTableView.reloadData()
        let scrollViewHeight = buyerActionView.frame.height + buyerDetailTableView.frame.height + 12;
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: scrollViewHeight)

        
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
