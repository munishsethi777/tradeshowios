//
//  SplashScreenViewController.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 12/03/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewDidAppear(_ animated: Bool) {
        let loggedInUserSeq = PreferencesUtil.sharedInstance.getLoggedInUserSeq()
        UIApplication.shared.applicationIconBadgeNumber = 0
        if(loggedInUserSeq > 0){
            self.performSegue(withIdentifier: "showDashboardController", sender: nil)
        }else{
            self.performSegue(withIdentifier: "showLoginViewController", sender: nil)
        }
    }
}
