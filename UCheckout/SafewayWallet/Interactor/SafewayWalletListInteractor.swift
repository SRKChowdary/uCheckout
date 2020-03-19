//
//  SafewayWalletListInteractor.swift
//  UCheckout
//
//  Created by 1521398 on 25/08/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import Foundation
import Alamofire

class SafewayWalletListInteractor: WalletListPresentorToInterectorProtocol{
    
    var presenter: WalletListInterectorToPresenterProtocol?
    
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
        //return "200-160-1540234454237"
    }
    
    func fetchWallets() {
        getAllAccounts()
    }
}

//MARK: - API Service Call
extension SafewayWalletListInteractor {
    func getAllAccounts() {
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
                        self.GetAllAccountsDetailsApiServiceCall()
                        break
                    case .failure:
                        return
                    }
            }
        }
        else  {
            print("******OKta Token Not Expierd*******")
            self.GetAllAccountsDetailsApiServiceCall()
        }
    }
    
    func GetAllAccountsDetailsApiServiceCall() {
        //Show Indicator
        self.presenter?.showActivityIndicator()
        let currentTime = Int64(NSDate().timeIntervalSince1970 * 1000)
        let guid = ["GUID": userGuid ,"currentTime" : currentTime ] as [String : Any]
        let url = NSURL(string: SafewayWalletConstants.WebserviceAPI.getAllAccounts)!
        let request = NSMutableURLRequest(url: url as URL)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(accessToken, forHTTPHeaderField: "accessToken")
        request.addValue(SafewayWalletConstants.subsCriptionKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.addValue(SafewayWalletConstants.xFunctionKey, forHTTPHeaderField: "x-functions-key" )
        request.httpMethod = "POST"
        if let jsonData = try? JSONSerialization.data(withJSONObject: guid, options: .prettyPrinted) {
            request.httpBody = jsonData
            DispatchQueue.global(qos: .userInitiated).async {
                let task = URLSession.shared.dataTask(with: request as URLRequest){ data, response, error in
                    DispatchQueue.main.async {
                        //Hide progress
                        self.presenter?.hideActiviyIndicator()
                        if let error = error {
                            self.presenter?.showError(message: error.localizedDescription)
                        }
                        else if let data = data {
                            do {
                                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String :Any]
                                if let parseJson = json {
                                    print("parseJson is ----->",parseJson)
                                    
                                    let walletDetails = WalletDetails(responseDict: parseJson)
                                    self.presenter?.show(walletDetails: walletDetails)
                                    if let value = parseJson["applePayFlag"] as? Bool {
                                        
                                        if value == true {
                                            
                                            UserDefaults.standard.set("ApplePay", forKey: "cardSelected")
                                        }
                                        else {
                                            
                                            UserDefaults.standard.set(nil, forKey: "cardSelected")
                                        }
                                    }
                                    
                                }
                            } catch let error as NSError {
                                print(error)
                            }
                        }
                    }
                }
                task.resume()
            }
        }
    }
    
    func deleteAccount(fdAccountId: String)  {
        presenter?.showActivityIndicator()
        
        let dict = ["GUID": userGuid, "fdAccountId": fdAccountId]
        let url = NSURL(string: SafewayWalletConstants.WebserviceAPI.deleteAccount)!
        let request = NSMutableURLRequest(url: url as URL)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(accessToken, forHTTPHeaderField: "accessToken")
        request.addValue(SafewayWalletConstants.subsCriptionKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.addValue(SafewayWalletConstants.xFunctionKey, forHTTPHeaderField: "x-functions-key" )
        request.httpMethod = "POST"
        if let jsonData = try? JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) {
            request.httpBody = jsonData
            DispatchQueue.global(qos: .userInitiated).async {
                let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
                    
                    self.presenter?.hideActiviyIndicator()
                    self.presenter?.cardDeletedSuccessfully()
                    
                    if error != nil {
                        print(error?.localizedDescription as Any)
                        return
                    }
                    let p = String(data: data!, encoding: String.Encoding.utf8)
                    print(p ?? "Empty response")
                    var errMessage:String?
                    var ackValue:String?
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                        if let parseJSON = json {
                            ackValue = parseJSON["ack"] as? String
                            if ackValue == "0" {
                                self.getAllAccounts()
                            } else {
                                let dictionary = parseJSON
                                errMessage = dictionary.value(forKey: "message") as? String
                                print(errMessage ?? "")
                                self.getAllAccounts()
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
    
    func updateAllCardData(fdAccountId: String, applePayEnabled : Bool) {
        presenter?.showActivityIndicator()
        
        let updatedeatils = ["defaultCard" : fdAccountId , "applePayFlag" : applePayEnabled ] as [String :Any]
        let guid = ["GUID": userGuid, "updates": updatedeatils ] as [String : Any]
        let url = NSURL(string: SafewayWalletConstants.WebserviceAPI.updateProfile)!
        let request = NSMutableURLRequest(url: url as URL)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue(accessToken, forHTTPHeaderField: "accessToken")
        request.addValue(SafewayWalletConstants.subsCriptionKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        request.addValue(SafewayWalletConstants.xFunctionKey, forHTTPHeaderField: "x-functions-key" )
        request.httpMethod = "POST"
        
        if let jsonData = try? JSONSerialization.data(withJSONObject: guid, options: .prettyPrinted) {
            request.httpBody = jsonData
            DispatchQueue.global(qos: .userInitiated).async {
                let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
                    self.presenter?.hideActiviyIndicator()
                    DispatchQueue.main.async {
                       // UserDefaults.standard.value(forKey: "ApplePayEnabled")
                        UserDefaults.standard.set(nil, forKey: "cardSelected")
                        self.getAllAccounts()
                    }
                }
                task.resume()
            }
        }
    }
}
