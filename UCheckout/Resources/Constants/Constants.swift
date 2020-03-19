//
//  Constants.swift
//  UCheckout
//
//  Created by i2i innovation on 11/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation

struct APPURL {
    static let isFirstTimeLogIn = "isFirstTimeLogIn"
}

struct CommonAlertMessage {
    static let InternetNotAvailable = "Internet is not available"
    static let FetchingDataError = "Sorry Something went Wrong!"
}

struct ResponseCode {
    static let RequestOK = 200
}

struct GlobalColor {
    static let kGreyOutColor: UIColor = UIColor(red: 167.0/255.0, green: 167.0/255.0, blue: 167.0/255.0, alpha: 0.5)
    static let kSolidGreyOutColor: UIColor = UIColor(red: 167.0/255.0, green: 167.0/255.0, blue: 167.0/255.0, alpha: 1.0)
    static let kViewGreyColor: UIColor = UIColor(red: 238.0/255.0, green: 238.0/255.0, blue: 238.0/255.0, alpha: 1.0)
    static let kViewGreenColor: UIColor = UIColor(red: 0.0/255.0, green: 150.0/255.0, blue: 72.0/255.0, alpha: 1.0)
     static let k87BlackColor: UIColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.87)
    static let klightGreyColor : UIColor = UIColor(red: 167.0/255.0, green: 165.0/255.0, blue: 165.0/255.0, alpha: 1.00)
    static let kYellowColor : UIColor = UIColor(red: 240.0/255.0, green: 255.0/255.0, blue: 0.0/255.0, alpha: 1.00)
    
     static let kEsteimatedViewGreyBGColor: UIColor = UIColor(red: 267.0/255.0, green: 267.0/255.0, blue: 267.0/255.0, alpha: 1.0)
    static let AppGreenColor : UIColor = UIColor(red: 0.0/255.0, green: 150.0/255.0, blue: 72.0/255.0, alpha: 1.0)
    
     static let KLightBlackColor : UIColor = UIColor(red: 60.0/255.0, green: 60.0/255.0, blue: 60.0/255.0, alpha: 1.0)
     static let KAppRedColor : UIColor = UIColor(red: 228.0/255.0, green: 23.0/255.0, blue: 32.0/255.0, alpha: 1.0)
    
    //0 0 0 0.87
   
}

struct AppConstants {
     static let AppName = "scanandgo"
     static let Platform = "ios"
     static let Banner = "safeway"
}

struct StringConstants {
    
    static let Welcome = "Welcome"
    static let StoreOperatingHours = "App Usage Hours"
    static let ItemLimit = "Transaction Item Limit"
    static let Items = "items or Less"
    static let Item = "item"
    static let StartShoppingNow = "Start Shopping Now!"
    static let EstimatedTotal = "Estimated Total"
    static let GotoStoreNearbyToShop = "Go to a store nearby to shop!"
    static let NOAccountAvailable = "No accounts found for this user"
    
}

struct TableResuableIdenifier {
    static let CartTableViewCell = "CartTableViewCell"
    static let NoCartItemTableViewCell = "NoCartItemTableViewCell"
    static let CartEmptyBottomTableViewCell = "CartEmptyBottomTableViewCell"
    static let RecieptTableViewCell = "RecieptTableViewCell"
    static let RecieptHeaderTableViewCell = "RecieptHeaderTableViewCell"
    static let RecieptSuccessFlowTableViewCell = "RecieptSuccessFlowTableViewCell"
    static let ReciptBarCodeTableViewCell = "ReciptBarCodeTableViewCell"
    static let ReciptViewTableViewCell = "ReciptViewTableViewCell"
    static let RecieptFooterTableViewCell = "RecieptFooterTableViewCell"
    static let RecentRecieptTableViewCell = "RecentRecieptTableViewCell"
    
}

struct UserDefaultConstants {
     static let IsFirstTimeUser = "isFirstTimeUser"
    static let   IsFirstTimeCart = "isFirstTimeCart"
      static let IsTermsAndConditionClicked = "isTermsAndConditionClicked"
     static let UserName = "userName"
     static let Password = "password"
}

