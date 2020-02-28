//
//  ObjectConvertor.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 27/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//
class ObjectConvertor{
    func toArray(swiftClass:Any) -> [String:Any]{
        let mirrored_object = Mirror(reflecting: swiftClass)
        var arr:[String:Any] = [:]
        for (_, attr) in mirrored_object.children.enumerated() {
            if let property_name = attr.label {
                var value = attr.value as? String
                if(property_name == "formItems"){
                    continue
                }
                if(property_name.hasSuffix("date")){
                    let dateStr = DateUtil.convertToFormat(dateString: value, fromFomat: DateUtil.dateFormat2, toFormat: DateUtil.dateFormat3)
                    value = dateStr
                }
                if(property_name.hasPrefix("is")){
                    let boolVal = value == "Yes" ? "1" : "0"
                    value = boolVal
                }
                arr[property_name] = value
            }
        }
        return arr
    }
}
