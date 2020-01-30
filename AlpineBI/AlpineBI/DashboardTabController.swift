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
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let selectedItem = item.title
        if(selectedItem == "Signout"){
           GlobalData.showAlert(view: self, message: "Signout")
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if let firstVC = viewController as? FirstViewController {
            GlobalData.showAlert(view: self, message: "Signout")
        }
        
        if viewController is FirstViewController {
            print("First tab")
        } else if viewController is SecondViewController {
            print("Second tab")
        }
    }
}
