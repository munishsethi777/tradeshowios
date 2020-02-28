//
//  GlobalData.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 29/01/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import Foundation
import UIKit
class GlobalData : NSObject{
    static func showAlert(view:UIViewController,message:String,nextViewControllerSegueId:String? = nil){
        let alert = UIAlertController(title: "Validation", message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            if(nextViewControllerSegueId != nil){
                let viewControllerYouWantToPresent = view.storyboard?.instantiateViewController(withIdentifier: nextViewControllerSegueId!)
                view.present(viewControllerYouWantToPresent!, animated: true, completion: nil)
                //view.performSegue(withIdentifier: nextViewControllerSegueId!, sender: nil)
            }
        }
        alert.addAction(action)
        view.present(alert, animated: true, completion: nil)
    }
    static func showAlert(view:UIViewController,message:String,success:Int,nextViewControllerSegueId:String? = nil){
        var title = "Error";
        if(success == 1){
            title = "Success";
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
            if(nextViewControllerSegueId != nil){
                let viewControllerYouWantToPresent = view.storyboard?.instantiateViewController(withIdentifier: nextViewControllerSegueId!)
                view.present(viewControllerYouWantToPresent!, animated: true, completion: nil)
                //view.performSegue(withIdentifier: nextViewControllerSegueId!, sender: nil)
            }
        }
        alert.addAction(action)
        view.present(alert, animated: true, completion: nil)
    }
    static func showAlertWithDismiss(view:UIViewController,title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) -> Void in
             view.dismiss(animated: true, completion: nil)
        }
        alert.addAction(action)
        view.present(alert, animated: true, completion: nil)
    }
}
