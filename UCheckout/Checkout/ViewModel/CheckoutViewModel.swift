//
//  CheckoutViewModel.swift
//  UCheckout
//
//  Created by i2i Innovation on 02/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class CheckoutViewModel: NSObject {
    
    public func getAllAccounts( strUrl : String , param :[String:Any]  ,parentViewController: UIViewController, completionBlock:@escaping (Bool,AccountModels?,String?) -> ()) {
        
        //Construct header to pass to api call
        
        
        
        
        SessionManager.sharedInstance.apiRequest(url: strUrl, method: HTTPMethodType.POST, parameter: param, headers: nil, parentViewController: parentViewController, showProgress: false) { (success, response, errorMessage) in
            
            
            let successValue = success
            let errorMsg = errorMessage
            
            if success {
                if let responseData = response as? Data {
                    let decoder = JSONDecoder()
                    
                    do {
                        let accountModel = try decoder.decode(AccountModels.self, from: responseData)
                        completionBlock(successValue, accountModel, errorMsg)
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
    
    public func checkOutCart( strUrl : String , header :[String:String]  ,parentViewController: UIViewController, completionBlock:@escaping (Bool,CheckoutModel?,String?) -> ()) {
        
        //Construct header to pass to api call
        
        
        SessionManager.sharedInstance.apiRequest(url: strUrl, method: HTTPMethodType.GET, parameter: nil, headers: header, parentViewController: parentViewController, showProgress: false) { (success, response, errorMessage) in
            
            
            let successValue = success
            let errorMsg = errorMessage
            
            if success {
                if let responseData = response as? Data {
                    let decoder = JSONDecoder()
                    
                    do {
                        let checkoutModel = try decoder.decode(CheckoutModel.self, from: responseData)
                        completionBlock(successValue, checkoutModel, errorMsg)
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
    public func getReceipt( strUrl : String , header :[String:String]?  ,parentViewController: UIViewController, completionBlock:@escaping (Bool,RecieptModel?,String?) -> ()) {
        
        //Construct header to pass to api call
        
        
        SessionManager.sharedInstance.apiRequest(url: strUrl, method: HTTPMethodType.GET, parameter: nil, headers: header, parentViewController: parentViewController, showProgress: false) { (success, response, errorMessage) in
            
            
            let successValue = success
            let errorMsg = errorMessage
            
            if success {
                if let responseData = response as? Data {
                    let decoder = JSONDecoder()
                    
                    do {
                        let recieptModel = try decoder.decode(RecieptModel.self, from: responseData)
                        completionBlock(successValue, recieptModel, errorMsg)
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
    
    public func salesTransaction( strUrl : String, param:[String:String] , header :[String:String]?  ,parentViewController: UIViewController, completionBlock:@escaping (Bool,SalesTransactionModel?,String?) -> ()) {
        
        //Construct header to pass to api call
        
        
        SessionManager.sharedInstance.apiRequest(url: strUrl, method: HTTPMethodType.POST, parameter: param, headers: nil, parentViewController: parentViewController, showProgress: false) { (success, response, errorMessage) in
            
            
            let successValue = success
            let errorMsg = errorMessage
            
            if success {
                if let responseData = response as? Data {
                    let decoder = JSONDecoder()
                    
                    do {
                        let salesTransactionModel = try decoder.decode(SalesTransactionModel.self, from: responseData)
                        completionBlock(successValue, salesTransactionModel, errorMsg)
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
    
    public func clearCart( strUrl : String, param:[String:String]?, header :[String:String]?  ,parentViewController: UIViewController, completionBlock:@escaping (Bool,ClearCartModel?,String?) -> ()) {
        
        //Construct header to pass to api call
        
        
        SessionManager.sharedInstance.apiRequest(url: strUrl, method: HTTPMethodType.DELETE, parameter: param, headers: nil, parentViewController: parentViewController, showProgress: true) { (success, response, errorMessage) in
            
            
            let successValue = success
            let errorMsg = errorMessage
            
            if success {
                if let responseData = response as? Data {
                    let decoder = JSONDecoder()
                    
                    do {
                        let clearCartModel = try decoder.decode(ClearCartModel.self, from: responseData)
                        completionBlock(successValue, clearCartModel, errorMsg)
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
