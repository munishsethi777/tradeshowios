//
//  LoginViewController.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 29/01/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//
import UIKit
class LoginViewController : UIViewController{
    
    @IBOutlet weak var controlView: UIView!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var userNameText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameText.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        passwordTextfield.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        loginButton.isEnabled = false
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        userNameText.text = ""
        passwordTextfield.text = ""
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)
        let loggedInUserSeq = PreferencesUtil.sharedInstance.getLoggedInUserSeq()
        UIApplication.shared.applicationIconBadgeNumber = 0
        if(loggedInUserSeq > 0){
            self.performSegue(withIdentifier: "MainTabViewController", sender: nil)
        }
    }
    
    @IBAction func loginAction(_ sender: UIButton) {
        var username: String = userNameText.text!;
        var password: String = passwordTextfield.text!;
        username = username.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        password = password.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
        var deviceId = PreferencesUtil.sharedInstance.getDeviceId()
        if(deviceId == nil){
            deviceId = ""
        }
        let args: [String] = [username,password,deviceId!]
        let url: String = MessageFormat.format(pattern: StringConstants.LOGIN_URL, args: args)
        var success : Int = 0
        var message : String? = nil
        ServiceHandler.instance().makeAPICall(url: url, method: HttpMethod.GET, completionHandler: { (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options:[]) as! [String: Any]
                success = json["success"] as! Int
                message = json["message"] as? String
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    if(success == 1){
                        UserMgr.sharedInstance.saveUser(response: json)
                        self.performSegue(withIdentifier: "MainTabViewController", sender: nil)
                    }else{
                        GlobalData.showAlert(view: self, message: message!)
                    }
                }
            } catch let parseError as NSError {
                GlobalData.showAlert(view: self, message: parseError.description)
            }
        })
    }
    
    @objc func editingChanged(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let userName = userNameText.text, !userName.isEmpty,
            let password = passwordTextfield.text, !password.isEmpty
            else {
                loginButton.isEnabled = false
                return
        }
        loginButton.isEnabled = true
    }
}
