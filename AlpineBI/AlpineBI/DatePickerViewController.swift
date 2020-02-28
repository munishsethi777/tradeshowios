//
//  DatePickerViewController.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 28/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import Foundation
import UIKit
protocol DatePickerProtocol {
    func setDate(valueSent: String)
}
class DatePickerViewController:UIViewController{
    var delegate:DatePickerProtocol?
    var selectedDate:String?
    var dateString:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerView.addTarget(self, action: #selector(handleDatePicker), for: .valueChanged)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(doneTapped))
        let date = DateUtil.stringToDate(dateString: selectedDate, dateFormat: DateUtil.dateFormat2);
        if(date != nil){
            datePickerView.date = date!
        }
    }
    @IBOutlet weak var datePickerView: UIDatePicker!
    @objc func handleDatePicker(_ datePicker: UIDatePicker) {
        dateString = DateUtil.dateToString(date: datePicker.date, toFormat: DateUtil.dateFormat2)
    }
    @objc func doneTapped(){
        dateString = DateUtil.dateToString(date: datePickerView.date, toFormat: DateUtil.dateFormat2)
        delegate?.setDate(valueSent: dateString)
        navigationController?.popViewController(animated: true)
    }
}
