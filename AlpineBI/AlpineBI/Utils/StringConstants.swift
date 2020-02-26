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
    static var DELETE_BUYER_CONFIRM = "Do you really want to delete this buyer."
    static var DELETE_CUSTOMER_CONFIRM = "Do you really want to delete this customer."
    static var LOGOUT_CONFIRM = "Do you really want to logout."
    //Actions URL
    static var ACTION_API_URL = "http://www.alpinebi.com/Actions/Mobile/"
    static let WEB_API_URL = "http://www.alpinebi.com/"
    //USER ACTION API URL
    static let LOGIN_URL = ACTION_API_URL + "UserAction.php?call=login&username={0}&password={1}&deviceid={2}"
    static let SUBMIT_UPDATE_USER = ACTION_API_URL  + "UserAction.php?call=updateUserDetail&userSeq={0}&user={1}"
    static let GET_USER_DETAIL = ACTION_API_URL  + "UserAction.php?call=getUserDetail&userSeq={0}"
    //Customer Action
    static let GET_CUSTOMER_NAMES = ACTION_API_URL + "CustomerAction.php?call=getAllCustomerNames&userSeq={0}"
    static let GET_CUSTOMER_DETAIL = ACTION_API_URL + "CustomerAction.php?call=getCustomerDetails&userSeq={0}&customerseq={1}"
    static let GET_BUYER_DETAIL = ACTION_API_URL + "CustomerAction.php?call=getBuyerDetail&userSeq={0}&buyerseq={1}"
    static let SUBMIT_ADD_CUSTOMER = ACTION_API_URL  + "CustomerAction.php?call=addCustomer&userSeq={0}&customer={1}"
    static let SUBMIT_ADD_BUYER = ACTION_API_URL  + "CustomerAction.php?call=addBuyer&userSeq={0}&buyer={1}"
    static let GET_CUSTOMER_BY_SEQ = ACTION_API_URL  + "CustomerAction.php?call=getCustomerBySeq&userSeq={0}&customerseq={1}"
    static let GET_BUYER_BY_SEQ = ACTION_API_URL  + "CustomerAction.php?call=getBuyerBySeq&userSeq={0}&buyerseq={1}"
    static let DELETE_CUSTOMER = ACTION_API_URL + "CustomerAction.php?call=deleteCustomers&userSeq={0}&customerseq={1}"
    static let DELETE_BUYER = ACTION_API_URL + "CustomerAction.php?call=deleteBuyer&userSeq={0}&buyerseq={1}"
    //Enum Action
    static let GET_BUSINESS_TYPES = ACTION_API_URL + "EnumAction.php?call=getBusinessTypes&userSeq={0}"
    static let GET_CATEGORY_TYPES = ACTION_API_URL + "EnumAction.php?call=getCategoryTypes&userSeq={0}"
    static let GET_TIMEZONES = ACTION_API_URL + "EnumAction.php?call=getTimeZones&userSeq={0}"
    static let GET_ENUMS_SPECIAL_PROG = ACTION_API_URL + "EnumAction.php?call=getEnumsForSpecialProg&userSeq={0}"
    static let GET_ENUMS_FOR_QUESTIONNARIE = ACTION_API_URL + "EnumAction.php?call=getQuestionnaireEnums&userSeq={0}"
    
    // CustomerQuestionnaireAction.php
    static let GET_SPECIAL_PROGRAM_DETAILS = ACTION_API_URL + "CustomerQuestionnaireAction.php?call=getSpecialProgramDetails&userSeq={0}&customerSeq={1}"
     static let SAVE_SPECIAL_PROGRAM_DETAILS = ACTION_API_URL  + "CustomerQuestionnaireAction.php?call=saveAlpineProg&userSeq={0}&specialProg={1}"
    static let SAVE_CHRISTMAS_QUESTION_DETAILS = ACTION_API_URL  + "CustomerQuestionnaireAction.php?call=saveChristmasQuestionDetail&userSeq={0}&christmasQues={1}"
    
    static let GET_CHRISTMAS_QUESTIONS_DETAILS = ACTION_API_URL + "CustomerQuestionnaireAction.php?call=getChristmasQuestionDetails&userSeq={0}&customerSeq={1}"
}
