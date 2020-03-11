//
//  DashboardTabController.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 29/01/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import Foundation
import UIKit
class DashboardTabController : UITabBarController,UITabBarControllerDelegate{
    var selectedCustomerSeq:Int = 0
    var isGoToDetailView = false
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        if(self.selectedIndex == 0 && isGoToDetailView){
            let viewController1 = self.selectedViewController as! UINavigationController
            if let viewController = viewController1.visibleViewController as? CustomerTableViewController {
                viewController.selectedCustomerSeq = selectedCustomerSeq
                viewController.isGoToDetailView = isGoToDetailView
                isGoToDetailView = false
            }
        }
        if(self.selectedIndex == 1){
            let viewController1 = self.selectedViewController as! CustomerDetailViewController
            viewController1.isNew = true
            viewController1.selectedCustomerSeq = 0;
        }
    }
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController is SignOutViewController {
            let refreshAlert = UIAlertController(title: "Logout", message: StringConstants.LOGOUT_CONFIRM, preferredStyle: UIAlertController.Style.alert)
            
            refreshAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action: UIAlertAction!) in
                PreferencesUtil.sharedInstance.resetDefaults()
                //self.performSegue(withIdentifier: "showLoginViewController", sender: nil)
                self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
            }))
            
            refreshAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            present(refreshAlert, animated: true, completion: nil)
            return false;
        }
        return true;
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let navController  = viewController as? UINavigationController{
            if let controller = navController.visibleViewController as? CustomerDetailViewController{
                if(tabBarController.selectedIndex == 0){
                    controller.isNew = false
                }else{
                    controller.isNew = true
                    controller.selectedCustomerSeq = 0
                }
            }
        }
    }

}
