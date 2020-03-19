//
//  SignInviewModel.swift
//  UCheckout
//
//  Created by i2i Innovation on 08/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit
import JWTDecode

class SignInviewModel: NSObject {
    
    public func checkValidUser( strUrl : String ,parentViewController: UIViewController, completionBlock:@escaping (Bool,SignInModel?,String?) -> ()) {
        
        //Construct header to pass to api call
        var headers: [String:String] = ["Content-Type":"application/json"]
        headers["Ocp-Apim-Subscription-Key"] = "f0760b3c35e546a399432d091658c484"
        
        SessionManager.sharedInstance.apiRequest(url: strUrl, method: HTTPMethodType.GET, parameter: nil, headers: headers, parentViewController: parentViewController, showProgress: true) { (success, response, errorMessage) in
            
            
            let successValue = success
            let errorMsg = errorMessage
            
            if success {
                if let responseData = response as? Data {
                    let decoder = JSONDecoder()
                    
                    do {
                        let signInModel = try decoder.decode(SignInModel.self, from: responseData)
                        completionBlock(successValue, signInModel, errorMsg)
                        return
                        
                        
                    } catch {
                        print(error.localizedDescription)
                        completionBlock(successValue, nil, error.localizedDescription)
                        return
                    }
                }
            }
            
            //callback
            completionBlock(successValue, nil, errorMsg)
        }
    }
    
    public func getOctaTokeDetails( strUrl : String ,params : [String:String],parentViewController: UIViewController, completionBlock:@escaping (Bool,OktaAuthModel?,String?) -> ()) {
        
        //Construct header to pass to api call
        let headers: [String:String] = ["Content-Type":"application/json"]
        
        SessionManager.sharedInstance.apiRequest(url: strUrl, method: HTTPMethodType.POST, parameter: params, headers: headers, parentViewController: parentViewController, showProgress: true) { (success, response, errorMessage) in
            
            
            let successValue = success
            let errorMsg = errorMessage
            
            if success {
                if let responseData = response as? Data {
                    let decoder = JSONDecoder()
                    
                    do {
                        let signInModel = try decoder.decode(OktaAuthModel.self, from: responseData)
                        completionBlock(successValue, signInModel, errorMsg)
                        return
                        
                        
                    } catch {
                        print(error.localizedDescription)
                        completionBlock(successValue, nil, error.localizedDescription)
                        return
                    }
                }
            }
            
            //callback
            completionBlock(successValue, nil, errorMsg)
        }
    }
    
    public func getToken( strUrl : String ,userName : String,password : String ,parentViewController: UIViewController, completionBlock:@escaping (Bool,OktaAPIModel?,String?) -> ()) {
        
        //Construct header to pass to api call
        SessionManager.sharedInstance.apiRequestForAPIToken(url: strUrl, userName: userName, password: password, method: .POST, parentViewController: parentViewController) { (success, data, message) in
            
            let successValue = success
            let errorMsg = message
            
            if success {
                if let responseData = data as? Data {
                    let decoder = JSONDecoder()
                    
                    do {
                        let oktaAPIModel = try decoder.decode(OktaAPIModel.self, from: responseData)
                        completionBlock(successValue, oktaAPIModel, errorMsg)
                        return
                        
                        
                    } catch {
                        print(error.localizedDescription)
                        completionBlock(successValue, nil, error.localizedDescription)
                        return
                    }
                }
            }
            
            //callback
            completionBlock(successValue, nil, errorMsg)
            
        }
        
    }
    

}
