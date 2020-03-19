//
//  CardTermsAndConditionsInteractor.swift
//  UCheckout
//
//  Created by 1521398 on 27/08/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import Foundation
import Alamofire

class CardTermsAndConditionsInteractor: CardTermsAndConditionsPresentorToInterectorProtocol {
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let sharedInstance = UcheckoutSingleton.shared
//        guard let guid = sharedInstance.userData?.guid else {
//            fatalError()
//        }
//
//    }
    
    func viewDidLoad()
    {
        let sharedInstance = UcheckoutSingleton.shared
                guard let guid = sharedInstance.userData?.guid else {
                    fatalError()
                }
        
    }
    
    
    
    var presenter: CardTermsAndConditionsInterectorToPresenterProtocol?
    var cardDetails: CardDetails?
    
    var accessToken: String {
        return ""
    }
    
    
   
    
    var userGuid: String {
        let sharedInstance = UcheckoutSingleton.shared
        guard let guid = sharedInstance.userData?.guid else {
            fatalError()
        }
      //  return "200-160-1540234454237"
        return guid
        
    }
    
   // "300-090-1517425278320"
    
    func registerCard(using cardDetails: CardDetails) {
        self.cardDetails = cardDetails
        apiCallForFdGetToken()
    }
}

//MARK: - API Call Method
extension CardTermsAndConditionsInteractor {
    func apiCallForFdGetToken()  {
        if OktaUtility.isOktaTokenExpired(jwtToken: accessToken) {
            print("******OKta Token Expierd*******")
            
            //Show Indicator
            self.presenter?.showActivityIndicator()
            
            Alamofire.request(SafewayWalletConstants.WebserviceAPI.oktaAccessToken, method: HTTPMethod.post, parameters: nil, encoding: JSONEncoding.default, headers: nil)
                .responseJSON { (response) in
                    //Hide progress view
                    self.presenter?.hideActiviyIndicator()
                    switch(response.result) {
                    case .success:
                        self.ApiCallForFDGetTokenServiceCall()
                        break
                    case .failure:
                        return
                    }
            }
        }
        else  {
            print("******OKta Token Not Expierd*******")
            self.ApiCallForFDGetTokenServiceCall()
        }
    }
    
    func ApiCallForFDGetTokenServiceCall() {
        
        //Show Indicator
        self.presenter?.showActivityIndicator()
        
        let url = NSURL(string: SafewayWalletConstants.WebserviceAPI.apiCallForFdGetToken)!
        let json: [String: Any] = ["GUID": userGuid]
        print(json)
        let postString = json
        let request = NSMutableURLRequest(url: url as URL)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(accessToken, forHTTPHeaderField: "accessToken")
        request.addValue(SafewayWalletConstants.subsCriptionKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.addValue(SafewayWalletConstants.xFunctionKey, forHTTPHeaderField: "x-functions-key" )
        request.httpMethod = "POST"
        let jsonData = try? JSONSerialization.data(withJSONObject: postString)
        print (jsonData as Any)
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response, error in
            
            //Hide Indicator
            self.presenter?.hideActiviyIndicator()
            
            if let error = error {
                self.presenter?.showError(message: error.localizedDescription)
                return
            }
            if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {           // check for http errors
                print("statusCode should be 200, but is \(httpStatus.statusCode)")
                print("response = \(String(describing: response))")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                var ackValue:String?
                if let parseJSON = json {
                    print(parseJSON)
                    ackValue = parseJSON["ack"] as? String
                    if ackValue == "0"{
                        OperationQueue.main.addOperation {
                            if let data = parseJSON["data"] as? [String : Any] {
                                if let token = data["tokenId"] as? String {
                                    UserDefaults.standard.set(token, forKey: "FDtokenId")
                                }
                                if let publicKey = data["publicKey"] as? String {
                                    UserDefaults.standard.set(publicKey, forKey: "FDpublicKey")
                                    
                                }
                                if let fdCustomerId = data["fdCustomerId"] as? String {
                                    UserDefaults.standard.set(fdCustomerId, forKey: "FDfdCustomerId")
                                }
                                self.encyrptDetail()
                                
                            }
                        }
                    } else {
                        if let errors = parseJSON["errors"] as? [[String: Any]] {
                            if !errors.isEmpty {
                                if let type = errors[0]["type"] as? String {
                                    if type == "Safeway SSO token validation" {
                                        /*
                                        DispatchQueue.main.async {
                                            let appDel = AppDelegate().sharedInstance()
                                            appDel.getTokenRequest(completion: { (status) in
                                                if status {
                                                    DispatchQueue.main.async {
                                                        self.apiCallForFdGetToken()
                                                    }
                                                }
                                            })
                                        }
                                        return
                                        */
                                    }
                                }
                                
                                let errorObject = errors.first!
                                if let category = errorObject["category"] as? String {
                                    DispatchQueue.main.async {
                                        if category == "duplicate_card" {
                                            self.presenter?.cardRegistrationFailed(error: ErrorInfo(title: "Incorrect Information", description: SafewayWalletConstants.Messages.cardExists) )
                                        }
                                        else if category == "generic_error" || category == "client_blocked" || category == "Blocked for suspicious activity" {
                                            self.presenter?.cardRegistrationFailed(error: ErrorInfo(title: "Payment Setup Error", description: SafewayWalletConstants.Messages.cardAddingError) )
                                        }
                                        else if category == "incorrect_card_info" {
                                            self.presenter?.cardRegistrationFailed(error: ErrorInfo(title: "Card info Invalid", description: SafewayWalletConstants.Messages.invalidCardInfo) )
                                        }
                                    }
                                }
                            }
                        }
                        
                    }
                }
            } catch let error as NSError {
                print(error)
            }
            
        }
        task.resume()
        
    }
    
    
    func encyrptDetail() {
        guard let publicKey = (UserDefaults.standard.value(forKey: "FDpublicKey") as? String) else {
            return
        }
        let expiryArray = cardDetails?.expirationDate.components(separatedBy: "/")
        let expMonth = expiryArray![0]
        let expYear = expiryArray![1]
        let cardNumber = cardDetails?.cardNumber.trim()
        let cvvText = cardDetails?.cvvNumber.trim()
        
        let encExpMonthData = RSAUtils.encryptWithRSAPublicKey(expMonth.data(using: String.Encoding.utf8)!, pubkeyBase64: publicKey, keychainTag: "com.app.application")
        let encExpMonthText = encExpMonthData!.base64EncodedString(options: NSData.Base64EncodingOptions())
        
        let encExpYearData = RSAUtils.encryptWithRSAPublicKey(expYear.data(using: String.Encoding.utf8)!, pubkeyBase64: publicKey, keychainTag: "com.app.application")
        let encExpYearText = encExpYearData!.base64EncodedString(options: NSData.Base64EncodingOptions())
        
        let encCardNumberData = RSAUtils.encryptWithRSAPublicKey(cardNumber!.data(using: String.Encoding.utf8)!, pubkeyBase64: publicKey, keychainTag: "com.app.application")
        let encCardNumberText = encCardNumberData!.base64EncodedString(options: NSData.Base64EncodingOptions())
        
        let encCvvTextData = RSAUtils.encryptWithRSAPublicKey(cvvText!.data(using: String.Encoding.utf8)!, pubkeyBase64: publicKey, keychainTag: "com.app.application")
        let encCvvTextText = encCvvTextData!.base64EncodedString(options: NSData.Base64EncodingOptions())
        
        var dict = Dictionary<String, Any>()
        var accountDict = Dictionary<String, Any>()
        accountDict["type"] = "CREDIT"
        var creditDict = Dictionary<String, Any>()
        creditDict["cardNumber"] = encCardNumberText
        creditDict["nameOnCard"] = cardDetails?.name
        creditDict["cardType"] = cardDetails?.cardType.rawValue.uppercased()
        print(creditDict)
        
        var billingAddressDict = Dictionary<String, Any>()
        billingAddressDict["type"] = ""
        billingAddressDict["streetAddress"] = ""
        billingAddressDict["locality"] = ""
        billingAddressDict["region"] = ""
        billingAddressDict["postalCode"] = cardDetails?.zipCode
        billingAddressDict["country"] = ""
        billingAddressDict["primary"] = true
        billingAddressDict["formatted"] = ""
        
        creditDict["billingAddress"] = billingAddressDict
        var expiryDateDict = Dictionary<String, Any>()
        expiryDateDict["month"] = encExpMonthText
        expiryDateDict["year"] = encExpYearText
        creditDict["expiryDate"] = expiryDateDict
        
        creditDict["securityCode"] = encCvvTextText
        accountDict["credit"] = creditDict
        
        var referenceTokenDict = Dictionary<String, Any>()
        referenceTokenDict["tokenType"] = "CLAIM_CHECK_NONCE"
        
        guard let fdCustomerID = (UserDefaults.standard.value(forKey: "FDfdCustomerId") as? String) else {
            return
        }
        dict["fdCustomerId"] = fdCustomerID
        dict["referenceToken"] = referenceTokenDict
        dict["account"] = accountDict
        
        APICallForFirstData(dict)
        
    }
    func APICallForFirstData(_ requestBody : [String :Any]){
        guard let FDtokenId = (UserDefaults.standard.value(forKey: "FDtokenId") as? String) else {
            return
        }
        self.presenter?.showActivityIndicator()
        
        let createAccBody = requestBody
        let url = NSURL(string: SafewayWalletConstants.WebserviceAPI.firstData)!
        print(url)
        let request = NSMutableURLRequest(url: url as URL)
        let authToken = "Bearer \(FDtokenId)"
        request.addValue(authToken, forHTTPHeaderField: "Authorization")
        request.addValue(SafewayWalletConstants.QaApiKey, forHTTPHeaderField: "APIKey" )
        let date = NSDate()
        let currentTime = Int64(date.timeIntervalSince1970 * 1000)
        request.addValue("\(currentTime)", forHTTPHeaderField: "timestamp")
        request.addValue("\(currentTime + 1)", forHTTPHeaderField: "Client-Request-id")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = "POST"
        if let jsonData = try? JSONSerialization.data(withJSONObject: createAccBody, options: .prettyPrinted) {
            request.httpBody = jsonData
            print(request)
            print(requestBody)
            
            DispatchQueue.global(qos: .userInitiated).async {
                let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
                    self.presenter?.hideActiviyIndicator()
                    if error != nil {
                        print(error?.localizedDescription as Any)
                        return
                    }
                    
                    let p = String(data: data!, encoding: String.Encoding.utf8)
                    print(p ?? "Empty response")
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        if let parseJSON = json {
                            print(parseJSON)
                            DispatchQueue.main.async {
                                if let token = parseJSON["token"] as? [String : Any] {
                                    if let naunceToken = token["tokenId"] as? String {
                                        UserDefaults.standard.set(naunceToken, forKey: "naunceToken")
                                        self.APICallNaunceToken()
                                    }
                                }
                            }
                            
                        }
                    } catch let error as NSError {
                        print(error)
                        self.presenter?.cardRegistrationFailed(error: ErrorInfo(title: "Payment Setup Error", description: SafewayWalletConstants.Messages.cardAddingError) )
                    }
                }
                task.resume()
            }
        }
        
        
    }
    
    func APICallNaunceToken(){
        if OktaUtility.isOktaTokenExpired(jwtToken: accessToken) {
            print("******OKta Token Expierd*******")
            Alamofire.request(SafewayWalletConstants.WebserviceAPI.oktaAccessToken, method: HTTPMethod.post, parameters: nil, encoding: JSONEncoding.default, headers: nil)
                .responseJSON { (response) in
                    //Hide progress view
                    self.presenter?.hideActiviyIndicator()
                    switch(response.result) {
                    case .success:
                        self.ApiCallNaunceTokenServiceCall()
                    case .failure:
                        return
                    }
            }
        }
        else  {
            print("******OKta Token Not Expierd*******")
            self.ApiCallNaunceTokenServiceCall()
        }
    }
    
    
    func ApiCallNaunceTokenServiceCall()  {
        self.presenter?.showActivityIndicator()
        
        var requestBody = [String : Any]()
        guard let naunceToken = (UserDefaults.standard.value(forKey: "naunceToken") as? String) else {
            return
        }
        guard let FDfdCustomerId = (UserDefaults.standard.value(forKey: "FDfdCustomerId") as? String) else {
            return
        }
        guard let FDtokenId = (UserDefaults.standard.value(forKey: "FDtokenId") as? String) else {
            return
        }
        let date = NSDate()
        let currentTime = Int64(date.timeIntervalSince1970 * 1000)
        requestBody["nonceToken"] = naunceToken
        requestBody["fdCustomerId"] = FDfdCustomerId
        requestBody["OAuthToken"] = FDtokenId
        requestBody["currentTime"] = currentTime
        let createAccBody = requestBody
        let url = NSURL(string: SafewayWalletConstants.WebserviceAPI.naunceToken)!
        print(url)
        let request = NSMutableURLRequest(url: url as URL)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(SafewayWalletConstants.subsCriptionKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.addValue(SafewayWalletConstants.xFunctionKey, forHTTPHeaderField: "x-functions-key" )
        request.addValue(accessToken, forHTTPHeaderField: "accessToken")
        request.httpMethod = "POST"
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: createAccBody, options: .prettyPrinted) {
            let jsonString = String(data: jsonData, encoding: .utf8)
            print(jsonString)
            request.httpBody = jsonData
            
            DispatchQueue.global(qos: .userInitiated).async {
                let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
                    self.presenter?.hideActiviyIndicator()
                    if error != nil{
                        print(error?.localizedDescription as Any)
                        return
                    }
                    
                    let p = String(data: data!, encoding: String.Encoding.utf8)
                    
                    print(p ?? "Empty response")
                    var ackValue:String?
                    
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        if let parseJSON = json {
                            ackValue = parseJSON["ack"] as? String
                            if ackValue == "0" {
                                DispatchQueue.main.async {
                                    if let data = parseJSON["data"] as? [String : Any] {
                                        if let fdAccountId = data["fdAccountId"] as? String {
                                            UserDefaults.standard.set(fdAccountId, forKey: "fdAccountId")
                                            
                                            let cardType = self.cardDetails?.cardType.rawValue ?? ""
                                            let cardNumber = (self.cardDetails?.cardNumber ?? "").suffix(4)
                                            let message = "Your \(cardType) card \(cardNumber) was successfully added to your Safeway Wallet."
                                            
                                            //Show card success
                                            self.presenter?.cardRegistrationSuccess(message: message)
                                        }
                                    }
                                }
                                
                            }else{
                                
                                if let errorArray = parseJSON["errors"] as? [[String : Any]] , !errorArray.isEmpty {
                                    let errorObject = errorArray.first!
                                    
                                    if let message = errorObject["message"] as? String {
                                       self.presenter?.cardRegistrationFailed(error: ErrorInfo(title: "Incorrect Information", description: message) )
                                    }
                                    else if let category = errorObject["category"] as? String {
                                        DispatchQueue.main.async {
                                            if category == "duplicate_card" {
                                                self.presenter?.cardRegistrationFailed(error: ErrorInfo(title: "Incorrect Information", description: SafewayWalletConstants.Messages.cardExists) )
                                            }
                                            else if category == "generic_error" || category == "client_blocked" {
                                                self.presenter?.cardRegistrationFailed(error: ErrorInfo(title: "Payment Setup Error", description: SafewayWalletConstants.Messages.cardAddingError) )
                                            }
                                            else if category == "incorrect_card_info" {
                                                self.presenter?.cardRegistrationFailed(error: ErrorInfo(title: "Card info Invalid", description: SafewayWalletConstants.Messages.invalidCardInfo) )
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } catch let error as NSError {
                        print(error)
                    }
                }
                task.resume()
            }
        }
    }
}
