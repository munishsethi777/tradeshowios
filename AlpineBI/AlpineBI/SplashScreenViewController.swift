//
//  SplashScreenViewController.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 12/03/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import UIKit

class SplashScreenViewController: UIViewController {
    var gradientLayer: CAGradientLayer!
    
    override func viewDidLoad() {
        setGradientBackground()
        super.viewDidLoad()
    }
    
    @IBOutlet weak var labelview: UILabel!
    
    override func viewDidAppear(_ animated: Bool) {
        let loggedInUserSeq = PreferencesUtil.sharedInstance.getLoggedInUserSeq()
        UIApplication.shared.applicationIconBadgeNumber = 0
        if(loggedInUserSeq > 0){
            self.performSegue(withIdentifier: "showDashboardController", sender: nil)
        }else{
            self.performSegue(withIdentifier: "showLoginViewController", sender: nil)
        }
    }
    
    func setGradientBackground() {
        let colorBottom =  UIColor(red: 0.0/255.0, green: 123.0/255.0, blue: 127.0/255.0, alpha: 1.0).cgColor
        let colorTop = UIColor(red: 0.0/255.0, green: 229.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.frame = self.view.bounds
        self.view.layer.insertSublayer(gradientLayer, at:0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = self.view.bounds
    }
}
