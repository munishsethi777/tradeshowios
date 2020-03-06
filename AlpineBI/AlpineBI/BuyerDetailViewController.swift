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
import CropViewController
class BuyerDetailViewController : UIViewController,UITableViewDelegate,CNContactViewControllerDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,CallBackProtocol,UIImagePickerControllerDelegate,UINavigationControllerDelegate,CropViewControllerDelegate{
    var selectedBuyerSeq:Int = 0;
    var selectedCustomerSeq:Int = 0;
    var isNew:Bool = false
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
    private var form = BuyerForm()
    @IBOutlet weak var buyerNameLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var buyerActionView: UIView!
    @IBOutlet weak var buyerDetailTableView: UITableView!
    var enums:[String:Any] = [:]
    var editBuyerData:[String:Any] = [:]
    var refreshControl:UIRefreshControl!
    var isReadOnly:Bool!
    var isImageSet:Bool!
    var uiImage:UIImage! = UIImage()
    var picker:UIImagePickerController?=UIImagePickerController()
    var tapGestureRecognizer:UITapGestureRecognizer!
    override func viewDidLoad() {
        super.viewDidLoad()
        loggedInUserSeq = PreferencesUtil.sharedInstance.getLoggedInUserSeq();
        progressHUD = ProgressHUD(text: "Loading")
        buyerDetailSt = []
        //getBuyerDetail()
        if #available(iOS 10.0, *) {
            refreshControl = UIRefreshControl()
            refreshControl.addTarget(self, action: #selector(refreshView), for: .valueChanged)
            scrollView.refreshControl = refreshControl
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        prepareSubViews()
        isReadOnly = true
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(connected(_:)))
        if(!isNew){
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
        }else{
            isReadOnly = false
            imageView.addGestureRecognizer(tapGestureRecognizer)
            addDoneButton()
        }
        self.view.addSubview(progressHUD)
        imageView.layer.cornerRadius = (imageView.frame.height) / 2
        imageView.clipsToBounds = true
        picker?.delegate = self
        loadEnumData()
        imageView.isUserInteractionEnabled = true
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    @objc func connected(_ sender:AnyObject){
        editImage()
    }
    
    func cancel(){
        print("Cancel Clicked")
    }
    
    func editImage(){
        let alert:UIAlertController = UIAlertController(title: "Profile Picture Options", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        let gallaryAction = UIAlertAction(title: "Open Gallery", style: UIAlertAction.Style.default) {
            UIAlertAction in self.openGallary()
        }
        let cameraAction = UIAlertAction(title: "Open Camera", style: UIAlertAction.Style.default) {
            UIAlertAction in self.openCamera()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) {
            UIAlertAction in self.cancel()
        }
        alert.addAction(gallaryAction)
        alert.addAction(cameraAction)
        alert.addAction(cancelAction)
        if let popoverPresentationController = alert.popoverPresentationController {
            popoverPresentationController.permittedArrowDirections = .down
            popoverPresentationController.sourceView = self.view
            popoverPresentationController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func tapGesture(gesture: UIGestureRecognizer) {
        editImage()
    }
    
    func openGallary() {
        picker!.allowsEditing = false
        picker!.sourceType = UIImagePickerController.SourceType.photoLibrary
        present(picker!, animated: true, completion: nil)
    }
    func openCamera() {
        picker!.allowsEditing = false
        picker!.delegate = self
        picker!.sourceType = .camera
        present(picker!, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            uiImage = pickedImage
            dismiss(animated: true)
            presentCropViewController()
        }else{
            dismiss(animated: true, completion: nil)
        }
    }
    func presentCropViewController() {
        let cropViewController = CropViewController(image: uiImage)
        cropViewController.delegate = self
        self.present(cropViewController, animated: true, completion: nil)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        imageView.image = image
        isImageSet = true
        dismiss(animated: true,completion: nil)
        buyerDetailTableView.reloadData()
    }
    
    func addEditButton(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
    }
    @objc func editTapped(){
        isReadOnly = false
        addDoneButton()
        addButtons()
        imageView.addGestureRecognizer(tapGestureRecognizer)
        buyerDetailTableView.reloadData()
        let scrollViewHeight = buyerActionView.frame.height + buyerDetailTableView.frame.height + 20;
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: scrollViewHeight)
    }
    
    func addDoneButton(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveBuyer))
    }
    
    @objc private func saveBuyer(){
        var arr = self.form.toArray(swiftClass: self.form);
        arr["seq"] = self.selectedBuyerSeq
        arr["customerseq"] = self.selectedCustomerSeq
        arr["createdby"] = self.loggedInUserSeq
        arr["category"] = getSelectedNameForMenu(fieldName: "category",value:form.category)
        let jsonString = JsonUtil.toJsonString(jsonObject: arr);
        excecuteSaveBuyerCall(jsonstring: jsonString)
    }
    
    private func excecuteSaveBuyerCall(jsonstring: String!){
        self.progressHUD.show()
        let json = jsonstring.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        let args: [Any] = [self.loggedInUserSeq,json]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.SUBMIT_ADD_BUYER, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICallImage(url: apiUrl, method: HttpMethod.POST,chosenImage:imageView.image!, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.progressHUD.hide()
                    if(success == 1){
                        self.selectedBuyerSeq = Int(json["buyerseq"] as! Int)
                        self.isReadOnly = true
                        self.isNew = false
                        self.addEditButton()
                        self.imageView.removeGestureRecognizer(self.tapGestureRecognizer)
                        self.form.reload()
                        self.buyerDetailTableView.reloadData()
                    }
                    GlobalData.showAlert(view: self, message: message!)
                }
            } catch let parseError as NSError {
                GlobalData.showAlert(view: self, message: parseError.description)
            }
        })
    }
    
    private func prepareSubViews(){
        FormItemCellType.registerCells(for: self.buyerDetailTableView)
        self.buyerDetailTableView.tableFooterView = UIView(frame: CGRect.zero)
        self.buyerDetailTableView.allowsSelection = false
        self.buyerDetailTableView.estimatedRowHeight = 10
        //buyerDetailTableView.estimatedRowHeight = 0
        buyerDetailTableView.estimatedSectionHeaderHeight = 0
        buyerDetailTableView.estimatedSectionFooterHeight = 0
        self.buyerDetailTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
       
    }
    @IBOutlet weak var imageView: UIImageView!
    
    @objc func refreshView(control:UIRefreshControl){
        reloadData()
    }
    func reloadData(){
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
    func updateValue(valueSent: String, indexPath: IndexPath) {}
    func buttonTapped(indexPath: IndexPath) {
        if(indexPath.row == 7){
            saveInContacts()
        }else if(indexPath.row == 8){
            deleteConfirm()
        }
    }
    
    func makeAPhoneCall()  {
        if(form.cellphone != nil && form.cellphone != ""){
            var contactNumber = form.cellphone!.replacingOccurrences(of: "-", with: "")
            contactNumber = contactNumber.replacingOccurrences(of: "+", with: "")
            contactNumber = contactNumber.replacingOccurrences(of: "(", with: "")
            contactNumber = contactNumber.replacingOccurrences(of: ")", with: "")
            contactNumber = contactNumber.trimmingCharacters(in: .whitespaces)
            contactNumber = contactNumber.replacingOccurrences(of: " ", with: "")
            guard contactNumber.count >= 10 else {
                dismiss(animated: true) {
                       GlobalData.showAlert(view: self, message: "Selected contact does not have a valid number")
                }
                return
            }
            let url: NSURL = URL(string: "TEL://" + contactNumber)! as NSURL
            UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        }else{
            GlobalData.showAlert(view: self, message: StringConstants.PHONE_NOT_AVAILABLE)
        }
    }
    
    func sendEmail(){
        if(form.email != nil && form.email != ""){
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([form.email!])
                present(mail, animated: true)
            } else {
                let email = form.email!
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
        if(form.cellphone != nil && form.cellphone != ""){
            if (MFMessageComposeViewController.canSendText()) {
                let controller = MFMessageComposeViewController()
                controller.recipients = [form.cellphone!]
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
            let urlWhats = "whatsapp://send?phone="+form.cellphone!+"&abid=12354&text="
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
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return buyerDetailSt.count
//    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedBuyer = buyerDetailSt[indexPath.row]
//        if(selectedBuyer.value == DELETE_BUYER && lastIndexOfBuyerArr == indexPath.row){
//            deleteBuyerConfirm()
//        }
//        if(selectedBuyer.value == SAVE_IN_CONTACTS && secondLastIndexOfBuyerArr == indexPath.row){
//            saveInContacts()
//        }
//    }
    
    func loadEnumData(){
        let args: [Int] = [self.loggedInUserSeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_CATEGORY_TYPES, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.enums["category"] = json["categoryTypes"] as! [String:String]
                        self.prepareSubViews()
                        self.buyerDetailTableView.dataSource = self
                        self.buyerDetailTableView.delegate = self
                        self.getBuyer()
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
    
    func getBuyer(){
        if(self.selectedBuyerSeq == 0){
            self.buyerDetailTableView.reloadData()
            return
        }
        self.view.addSubview(progressHUD)
        self.progressHUD.show()
        let args: [Int] = [self.loggedInUserSeq,self.selectedBuyerSeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_BUYER_BY_SEQ, args: args)
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
    
    func loadFormOnEdit(response:[String:Any]){
        editBuyerData = response["buyer"] as! [String:Any]
        self.form.firstname = editBuyerData["firstname"] as? String
        self.form.lastname = editBuyerData["lastname"] as? String
        self.form.email = editBuyerData["email"] as? String
        self.form.cellphone = editBuyerData["cellphone"] as? String
        self.form.officephone = editBuyerData["officephone"] as? String
        self.form.category = getSelectedValueForMenu(fieldName: "category")
        self.form.notes = editBuyerData["notes"] as? String
        let buyerImageName = editBuyerData["imageextension"] as? String
        if(buyerImageName != nil){
            let userImageUrl = StringConstants.BUYER_IMAGE_URL + buyerImageName!
            if let url = NSURL(string: userImageUrl) {
                if let data = NSData(contentsOf: url as URL) {
                    let img = UIImage(data: data as Data)
                    imageView.image = img
                    imageView.layer.cornerRadius = (imageView.frame.height) / 2
                    imageView.clipsToBounds = true
                }
            }
       }
       form.reload()
       buyerDetailTableView.reloadData()
       let scrollViewHeight = buyerActionView.frame.height + buyerDetailTableView.frame.height + 18;
       scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: scrollViewHeight)
    }
    
    func saveInContacts(){
        let con = CNMutableContact()
        con.givenName = form.firstname ??  ""
        con.familyName = form.lastname ?? ""
        con.phoneNumbers.append(CNLabeledValue(
            label: "Cell Phone", value: CNPhoneNumber(stringValue: form.cellphone ??  "")))
        con.emailAddresses.append(CNLabeledValue(label: "Email",value:(form.email ?? "") as NSString))
        let unkvc = CNContactViewController(forUnknownContact: con)
        unkvc.contactStore = CNContactStore()
        unkvc.delegate = self
        unkvc.allowsActions = false
        self.navigationController?.pushViewController(unkvc, animated: true)
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cellIdentifier = "BuyerDetailTableViewCell"
//        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! BuyerDetailTableViewCell
//        let buyer = buyerDetailSt[indexPath.row]
//        cell.fieldNameLabel.text = buyer.id
//        cell.fieldValueLabel.text = buyer.value
//        cell.fieldValueLabel.textColor = cell.hiddenLabel.textColor
//        cell.fieldValueLabel.font = cell.hiddenLabel.font
//        if(buyer.value == SAVE_IN_CONTACTS && secondLastIndexOfBuyerArr == indexPath.row){
//            cell.fieldNameLabel.text = ""
//        }
//        if(buyer.value == DELETE_BUYER && lastIndexOfBuyerArr == indexPath.row){
//            cell.fieldNameLabel.text = ""
//            cell.fieldValueLabel.font = UIFont(name:"Helvetica",size: 15.0)
//            cell.fieldValueLabel.textColor = .red
//        }
//        return cell
//    }
    
    func getBuyerDetail(){
        self.view.addSubview(progressHUD)
        let args: [Int] = [self.loggedInUserSeq,self.selectedBuyerSeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.GET_BUYER_BY_SEQ, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: apiUrl, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        self.buyerDetailTableView.delegate = self
                        self.buyerDetailTableView.dataSource = self
                        self.buyerDetailTableView.reloadData()
                        let scrollViewHeight = self.buyerActionView.frame.height + self.buyerDetailTableView.frame.height + 12;
                        self.scrollView.contentSize = CGSize(width: self.scrollView.frame.size.width, height: scrollViewHeight)
                        //self.loadBuyerDetail(jsonResponse: json)
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
    
//    func loadBuyerDetail(jsonResponse: [String: Any]){
//        let buyer = jsonResponse["buyer"] as! [Any]
//        let buyerName = jsonResponse["buyername"] as! String
//        let buyerImage = jsonResponse["buyerimage"] as? String
//        selectedBuyerFName = jsonResponse["buyerfirstname"] as? String
//        selectedBuyerLName = jsonResponse["buyerlastname"] as? String
//        selectedBuyerPhone = jsonResponse["buyercellphone"] as? String
//        selectedBuyerEmail = jsonResponse["buyeremail"] as? String
//        for j in 0..<buyer.count{
//            let buyerJson = buyer[j] as! [String: Any]
//            let name = buyerJson["name"] as! String
//            let value = buyerJson["value"] as? String
//            var detail = IDNamePair()
//            detail.id = name
//            detail.value = value
//            buyerDetailSt.append(detail)
//        }
//        buyerNameLabel.text = buyerName
//        if(buyer.count > 0){
//            addSaveInContactButtonLink()
//            addDeleteButtonLink()
//            lastIndexOfBuyerArr = buyerDetailSt.count - 1
//            secondLastIndexOfBuyerArr = lastIndexOfBuyerArr - 1
//        }
//        if #available(iOS 10.0, *) {
//            self.refreshControl.endRefreshing()
//        }
//        buyerDetailTableView.reloadData()
//        let scrollViewHeight = buyerActionView.frame.height + buyerDetailTableView.frame.height + 12;
//        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: scrollViewHeight)
//        if(buyerImage != nil){
//            let userImageUrl = StringConstants.BUYER_IMAGE_URL + buyerImage!
//            if let url = NSURL(string: userImageUrl) {
//                if let data = NSData(contentsOf: url as URL) {
//                    let img = UIImage(data: data as Data)
//                    imageView.image = img
//                    imageView.layer.cornerRadius = (imageView.frame.height) / 2
//                    imageView.clipsToBounds = true
//                }
//            }
//        }
//    }
    
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
    
    func addButtons(){
        let saveFromContactItem = FormItem(placeholder: "Save In Contacts")
        saveFromContactItem.uiProperties.cellType = FormItemCellType.buttonView
        saveFromContactItem.value = ""
        saveFromContactItem.isButtonOnly = true
        saveFromContactItem.name = "saveFromContact"
        
        
        let deleteCustomerItem = FormItem(placeholder: "Delete Buyer")
        deleteCustomerItem.uiProperties.cellType = FormItemCellType.buttonView
        deleteCustomerItem.value = ""
        deleteCustomerItem.isButtonOnly = true
        deleteCustomerItem.name = "deletebuyer"
        deleteCustomerItem.color = UIColor.red
        form.formItems.append(saveFromContactItem)
        form.formItems.append(deleteCustomerItem)
    }
    
    func deleteConfirm (){
        let refreshAlert = UIAlertController(title: DELETE_BUYER, message: StringConstants.DELETE_BUYER_CONFIRM, preferredStyle: UIAlertController.Style.alert)
        
        refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
            self.excuteDeleteBuyerCall()
        }))
        
        refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
  
    func excuteDeleteBuyerCall(){
        self.view.addSubview(progressHUD)
        let args: [Int] = [self.loggedInUserSeq,self.selectedBuyerSeq]
        let apiUrl: String = MessageFormat.format(pattern: StringConstants.DELETE_BUYER, args: args)
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
            self.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let secondController = segue.destination as? AddBuyerViewController {
            secondController.editBuyerSeq =  selectedBuyerSeq
            secondController.customerSeq = selectedCustomerSeq
        }
    }
    func getPickerViewData(formItem:FormItem)->[String:String]{
       // if(formItem.isPicker || formItem.isLabel){
            let name = formItem.name!
            if let pickerData = enums[name]{
                return pickerData as! [String : String]
            }
        //}
        return [:]
    }
    func getSelectedValueForMenu(fieldName:String)->String?{
        if let selectedValueStr = editBuyerData[fieldName] as? String{
            let selctedValuesArr = selectedValueStr.components(separatedBy: ",")
            var selectedValues:[String] = []
            let enumData = enums[fieldName] as! [String:String];
            for value in selctedValuesArr {
                selectedValues.append(enumData[value]!)
            }
            let valueStr = selectedValues.joined(separator: ", ")
            self.editBuyerData[fieldName] = valueStr
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
}
extension BuyerDetailViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.form.formItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var isSetCaption = true
        let item = self.form.formItems[indexPath.row]
        var cell: UITableViewCell
        let pickerViewData:[String:String] = getPickerViewData(formItem: item)
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
