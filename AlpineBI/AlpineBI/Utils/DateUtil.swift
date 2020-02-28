//
//  DateUtil.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 15/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import Foundation
class DateUtil{
    static var dateFormat1 = "yyyy-MM-dd"
    static var dateFormat2 = "dd-MMM-yyyy"
    static var dateFormat3 = "MM-dd-yyyy"
    
    static func stringToDate(dateString:String?,dateFormat:String)->Date?{
        if(dateString != nil && !dateString!.isEmpty){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            let date = dateFormatter.date(from:dateString!)!
            return date;
        }
        return nil;
    }
    
    static func dateToString(date:Date,toFormat:String)->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = toFormat
        let dateStr = dateFormatter.string(from: date)
        return dateStr;
    }
    
    static func convertToFormat(dateString:String?,fromFomat:String,toFormat:String)->String{
        var dateStr = "";
        if(dateString != nil && !dateString!.isEmpty){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = fromFomat
            let date = dateFormatter.date(from:dateString!)!
            dateFormatter.dateFormat = toFormat
            dateStr = dateFormatter.string(from: date)
        }
        return dateStr;
    }
}
