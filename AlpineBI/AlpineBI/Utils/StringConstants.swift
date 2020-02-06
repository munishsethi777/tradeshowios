//
//  StringConstants.swift
//  AlpineBI
//
//  Created by Baljeet Gaheer on 29/01/20.
//  Copyright © 2020 Munish Sethi. All rights reserved.
//

import Foundation
struct StringConstants {
    static var PHONE_NOT_AVAILABLE = "Cell Phone number does not exists for this buyer!";
    static var EMAIL_NOT_AVAILABLE = "Email id does not exists for this buyer!";
    static var WHATS_APP_NOT_INSTALLED = "Whatsapp is not installed on this device. Please install Whatsapp and try again."
    //Actions URL
    static var ACTION_API_URL = "http://www.alpinebi.com/Actions/Mobile/"
    static let WEB_API_URL = "http://www.alpinebi.com/"
    //USER ACTION API URL
    static let LOGIN_URL = ACTION_API_URL + "UserAction.php?call=login&username={0}&password={1}&deviceid={2}"
    //Customer Action
    static let GET_CUSTOMER_NAMES = ACTION_API_URL + "CustomerAction.php?call=getAllCustomerNames&userSeq={0}"
    static let GET_CUSTOMER_DETAIL = ACTION_API_URL + "CustomerAction.php?call=getCustomerDetails&userSeq={0}&customerseq={1}"
    static let GET_BUYER_DETAIL = ACTION_API_URL + "CustomerAction.php?call=getBuyerDetail&userSeq={0}&buyerseq={1}"
    static let SUBMIT_ADD_CUSTOMER = ACTION_API_URL  + "CustomerAction.php?call=addCustomer&userSeq={0}&customer={1}"
}
