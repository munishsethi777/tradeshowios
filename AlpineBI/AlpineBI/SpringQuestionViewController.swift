//
//  SpringQuestionViewController.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 22/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import Foundation
import UIKit
class SpringQuestionViewController : UIViewController{
    var loggedInUserSeq:Int = 0
    var customerSeq:Int = 0;
    var customerName:String = "";
    var progressHUD: ProgressHUD!
    var editProgSeq:Int = 0
    var form = SpecialProgramForm()
    var isReadOnly = true;
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var customerNameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareSubViews()
        loggedInUserSeq = PreferencesUtil.sharedInstance.getLoggedInUserSeq()
        progressHUD = ProgressHUD(text: "Processing")
        customerNameLabel.text = customerName
        addEditButton()
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        super.viewDidLoad()
    }
    private func prepareSubViews() {
        FormItemCellType.registerCells(for: self.tableView)
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tableView.allowsSelection = false
        self.tableView.estimatedRowHeight = 90
    }
    override func viewWillAppear(_ animated: Bool) {
        isReadOnly = true
        super.viewWillAppear(animated)
        //loadEnumData()
    }
    
    @objc func keyboardWillShow(notification:NSNotification){
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.tableView.contentInset
        contentInset.bottom = keyboardFrame.size.height
        tableView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification:NSNotification){
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        tableView.contentInset = contentInset
    }
    func addEditButton(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(editTapped))
    }
    @objc func editTapped(){
        isReadOnly = false
        tableView.reloadData()
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(saveSpecialProg))
    }
}
