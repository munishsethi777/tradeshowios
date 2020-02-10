//
//  JsonUtil.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 10/02/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import Foundation
class JsonUtil{
    
    static func toJsonString(jsonObject:Any)->String{
        let jsonString: String!
        do {
            let postData : NSData = try JSONSerialization.data(withJSONObject: jsonObject, options:[]) as NSData
            jsonString = NSString(data: postData as Data, encoding: String.Encoding.utf8.rawValue)! as String
        } catch {
            jsonString = ""
        }
        return jsonString!
    }
    
}
