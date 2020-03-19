//
//  UcheckoutManager.swift
//  UCheckout
//
//  Created by i2i innovation on 19/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation
import Prestyler
import JWTDecode



struct EnvConstants {
    
    static let kDevelopment = "Development"
    static let kQA = "QA"
    static let kProduction = "Production"
    
}

class UcheckoutManager {
    class func getAtttributedStringWithString1(_ string1 : String , string2 : String) -> NSAttributedString{
        
        Prestyler.defineRule("$", 15, UIColor.black, UIFont.SNSemiBold(15))
        Prestyler.defineRule("#", 15, UIColor.red, UIFont.SNRegular(15))
        
        return "$\(string1)$: #\(string2)#".prestyled()
        
    }
    
    class func getOneAttributedString(_ string1 : String) -> NSAttributedString{
       
        Prestyler.defineRule("*", 25, GlobalColor.k87BlackColor, UIFont.SNBold(25))
        
        return "*\(string1)".prestyled()
    }
    
    class func getSecondAttributedString(_ string2 : String) -> NSAttributedString{
        Prestyler.defineRule("$", 18, UIColor.black, UIFont.SNSemiBold(18))
        
        return "\(string2)".prestyled()
    }
    
    
    
    
    class func getAtttributedStringForQuantWithString1(_ string1 : String , string2 : String) -> NSAttributedString{
        
        Prestyler.defineRule("$", 15, GlobalColor.k87BlackColor, UIFont.SNRegular(15))
        Prestyler.defineRule("#", 15, UIColor.black, UIFont.SNBold(15))
        
        return "$\(string1)$: #\(string2)#".prestyled()
        
    }
    
    class func getCompleteURl(_ url : String) -> String {
        return "\(ConfigurationManager.manager.baseURL)\(url)"
    }
    
    class func getRetailCompleteURl(_ url : String) -> String {
        return "\(RetailGeneralConfigurationManager.manager.baseURL)\(url)"
    }
    
    class func getScanAndGoDevJSCompleteURl(_ url : String) -> String {
        return "\(ScanandgodevjsConfigurationManager.manager.baseURL)\(url)"
    }
    
    class func getUcommdevCompleteURl(_ url : String) -> String {
        return "\(UcommdevConfigurationManager.manager.baseURL)\(url)"
    }
    class func getOktaCompleteURl(_ url : String) -> String {
        return "\(OktaConfigurationManager.manager.baseURL)\(url)"
    }
    
    class func getOktaAuthorizationBas64Value() -> String? {
        let clientIDAndClientSecret: String = OktaConfigurationManager.manager.clientId + ":" + OktaConfigurationManager.manager.clientSecret
        guard let data = clientIDAndClientSecret.data(using: String.Encoding.utf8) else {
            fatalError()
        }
        let base64String = data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
        return base64String
        
    }
    
    class func getUserProfileFromOktaToken(jwtToken: String, refreshToken: String) -> User {
        var user:User?
        
        
        do {
            let jwt = try decode(jwt: jwtToken)
            
            user = User(token: jwtToken,
                        hhid: jwt.body["hid"] as? String,
                        phoneNumber:  jwt.body["phn"] as? String,
                        coremaClubCard: jwt.body["aln"] as? String,
                        zipCode:  jwt.body["zip"] as? String,
                        guid: jwt.body["gid"] as? String,
                        storeId: jwt.body["str"] as? String,
                        lastUpdateTime:  Date(),
                        firstName:jwt.body["fnm"] as? String,
                        lastName:jwt.body["lnm"] as? String,
                        userId: jwt.body["sub"] as? String,
                        accessToken: jwtToken,
                        refreshToken: refreshToken
                       )
            
        } catch {
            print("Error parsing jwt token")
        }
        return user!
    }
    
    class func getEnvironment()-> String{
        guard  let environment = Bundle.main.infoDictionary?["Configuration"] as? String  else {
            return EnvConstants.kDevelopment
        }
        return environment
    }
    
    class func getDay() -> String {
        
        let now = Date()
        let nowDateFormatter = DateFormatter()
        let daysOfWeek = [
            "Sunday",
            "Monday",
            "Tuesday",
            "Wednesday",
            "Thursday",
            "Friday",
            "Saturday",
            "Saturday"
        ]
        nowDateFormatter.dateFormat = "e"
        let weekdayNumber = Int(nowDateFormatter.string(from: now)) ?? 0
        print("Day of Week: \(daysOfWeek[weekdayNumber])")
        
        return daysOfWeek[weekdayNumber]
    }
   
}
