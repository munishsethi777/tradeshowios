//
//  StringConstants.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 29/01/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import Foundation
struct StringConstants {
    static var ACTION_API_URL = "http://www.alpinebi.com/Actions/Mobile/"
    static let WEB_API_URL = "http://www.alpinebi.com/"
    //USER ACTION API URL
    static let LOGIN_URL = ACTION_API_URL + "UserAction.php?call=login&username={0}&password={1}&deviceid={2}"
    static let GET_CUSTOMER_NAMES = ACTION_API_URL + "CustomerAction.php?call=getAllCustomerNames&userSeq={0}"
    
}
