//
//  SafewayWalletConstants.swift
//  UCheckout
//
//  Created by 1521398 on 25/08/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//
// Pranav : Changed for DEV implementation :

import Foundation

class SafewayWalletConstants {
    
    // Enviorment Key
    #if PROD
    static let xFunctionKey = "0Acee0i89B7aiouCdCX5MmwdNwgchI6lWUZ3l1RlrcLIA3CfCuwzCA=="
    static let subsCriptionKey = "2a5e3f1db87c43a482debdfa67dfc015"
    #elseif  QA
    static let xFunctionKey = "0Acee0i89B7aiouCdCX5MmwdNwgchI6lWUZ3l1RlrcLIA3CfCuwzCA=="
    static let subsCriptionKey = "2a5e3f1db87c43a482debdfa67dfc015"
    
    #else
    // PROD :
   // static let xFunctionKey = "0Acee0i89B7aiouCdCX5MmwdNwgchI6lWUZ3l1RlrcLIA3CfCuwzCA=="
  //  static let subsCriptionKey = "2a5e3f1db87c43a482debdfa67dfc015"

    // MARK :- DEV
   static let xFunctionKey = "odwqu8zS9TobBR4ipbBXbCABaFuC9NGFzBhcDw1zgKn9amrEcpT13Q=="
   static let subsCriptionKey = "4496e0804f1b4a19b7c5da406b1dd1bd"
    //    static let subsCriptionKey = "1cf05a0d91694d28b60d4d7f0887bddf"
    
    // MARK :- QA
    
  //  static let xFunctionKey = "MDy7Hh6hJoueFZMlodoHPaernhjsA7LbxbxF7Bt66oESgMHQfw98Bw=="
   // static let subsCriptionKey = "4496e0804f1b4a19b7c5da406b1dd1bd"

    
    
    #endif
    static let QaApiKey = "zJGTSUHwGgHsISeNP39O0LI4cGjBITV0"
    static let QaApiKeyQA = "RBTnQcmj3ttwAQZpxLOVGEki5mDRU1es"
    
    struct WebserviceAPI {
        
        // DELETE ACCOUNT API :
        
        // PROD :
      //  static let deleteAccount = "https://onetouchfuel.azure-api.net/api/deleteaccount"
        
        // DEV :
        static let deleteAccount = "https://retail-api.azure-api.net/ucommdev/deleteaccount"
        
        // QA :
      //  static let deleteAccount = "https://retail-api.azure-api.net/ucommqa/deleteaccount"
        
        // GET ALL ACCOUNTS API :
        
        // PROD :
      //  static let getAllAccounts = "https://onetouchfuel.azure-api.net/api/getallaccounts"
        
        // DEV :
        static let getAllAccounts = "https://retail-api.azure-api.net/ucommdev/getallaccounts"
        

        
        // QA :
        
       // static let getAllAccounts = "https://retail-api.azure-api.net/ucommqa/getallaccounts"
        
        static let oktaAccessToken = "https://albertsons.okta.com/oauth2/ausp6soxrIyPrm8rS2p6/v1/token"
        
        // UPDATE PROFILE API :
        // DEV :
       static let updateProfile  =  "https://retail-api.azure-api.net/ucommdev/updatepaymentprofile"
 
        //static let updateProfile  = "https://otf-api-management.azure-api.net/api/updateProfile"
       
        // PROD :
       // static let updateProfile = "https://onetouchfuel.azure-api.net/api/updateProfile"
        
        // QA :
        // static let updateProfile  =  "https://retail-api.azure-api.net/ucommqa/updatepaymentprofile"
        
        // DEV :
        //static let updateProfile  = "https://otf-api-management.azure-api.net/api/updateProfile"
       // static let updateProfile  =  "https://retail-api.azure-api.net/ucommdev/updatepaymentprofile"
        
     
        
        // PROD :
        // static let updateProfile = "https://onetouchfuel.azure-api.net/api/updateProfile"
        
        // FIRST DATA API :
        
        // PROD :
       // static let firstData = "https://api.payeezy.com/ucom/v1/account-tokens"
        
        // MARK :- DEV
       static let firstData = "https://api-int.payeezy.com/ucom/v1/account-tokens"
        
        // QA :
       // static let firstData = "https://api-int.payeezy.com/ucom/v1/account-tokens"
        
        // FD NAUNCE ENROLLMENT API :
        
        // PROD :
      //  static let naunceToken = "https://onetouchfuel.azure-api.net/api/fdnonceenrollment"
        
        //MARK :- DEV
        static let naunceToken = "https://otf-api-management.azure-api.net/api/fdnonceenrollment"
      //  static let naunceToken = "https://retail-api.azure-api.net/ucommdev/fdnonceenrollment"
        
        // QA :
       // static let naunceToken = "https://retail-api.azure-api.net/ucommqa/fdnonceenrollment"
        
        // FD GET TOKEN API :
        
        // PROD :
       // static let apiCallForFdGetToken = "https://onetouchfuel.azure-api.net/api/fdgettoken"
        
        //MARK:- DEV
        static let apiCallForFdGetToken = "https://otf-api-management.azure-api.net/api/fdgettoken"
      //  static let apiCallForFdGetToken = "https://retail-api.azure-api.net/ucommdev/fdgettoken"
        
        // QA :
       // static let apiCallForFdGetToken = "https://retail-api.azure-api.net/ucommqa/fdgettoken"
        
    }
    
    struct CardRegistration {
        static let minimumNameLength: Int = 1
        static let amexCardNumberLength: Int = 18
        static let otherCardNumberLength: Int = 19
        static let zipCodeLength:Int = 5
        static let amexCVVLength: Int = 4
        static let otherCardCvvLength = 3
        static let expirationDateLength = 5
        
        static let lightGrayColor = UIColor(red: 216/255, green: 216/255, blue: 215/255, alpha: 1)
        static let borderWidth: CGFloat = 1.0
        static let cornerRadius: CGFloat = 2.0
    }
    
    struct Messages {
        static let cardMaxCountReached = "Can’t add any more cards. Max limit reached in wallet."
        static let cardsLoadingError = "There is an issue with your wallet. Please call customer support for assistance."
        static let internetError = "Your internet signal is weak. Please try again."
        static let cardExists = "This card already exsists in your wallet. Please try adding a new card."
        static let cardAddingError = "There was an error adding a payment method. Please try again."
        static let invalidCardInfo = "Please check all the card information before adding the card."
        
        
        static let termsAndConditions = "By clicking “Accept & Continue”, you consent to and authorize:\r\r1. Your electronic acceptance of the Albertsons Companies Terms of Use, and \r\r2. Our storage of your card data (Name, Credit Card Number, Expiration Date) for purposes of future transactions using the app; (3) All transactions made via the company app using your mobile device, and (4) the company charging your selected payment method in the amount of each such transaction."
    }
    
}


