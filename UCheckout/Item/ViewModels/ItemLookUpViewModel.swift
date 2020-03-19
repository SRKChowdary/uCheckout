//
//  ItemLookUpViewModel.swift
//  UCheckout
//
//  Created by i2i innovation on 23/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation


class ItemLookUpViewModel : NSObject {
    
    public func getItemLookUp( strUrl : String ,parentViewController: UIViewController, completionBlock:@escaping (Bool,ItemLookUpModel?,String?) -> ()) {
        
        //Construct header to pass to api call
        var headers: [String:String] = ["Content-Type":"application/json"]
        
        headers["Ocp-Apim-Subscription-Key"] = ScanandgodevjsConfigurationManager.manager.ocpSubscriptionkey
        headers["oktatoken"] = UcheckoutSingleton.shared.userData?.accessToken
        
        print("accessToken------------------------>---------------------->",UcheckoutSingleton.shared.userData?.accessToken)
        
        SessionManager.sharedInstance.apiRequest(url: strUrl, method: HTTPMethodType.GET, parameter: nil, headers: headers, parentViewController: parentViewController, showProgress: true) { (success, response, errorMessage) in
            
            
            let successValue = success
            let errorMsg = errorMessage
            
            if success {
                if let responseData = response as? Data {
                   
                   
                    let decoder = JSONDecoder()
                    
                    do {
                        let itemLookUpModel = try decoder.decode(ItemLookUpModel.self, from: responseData)
                       // let myItemId = itemLookUpModel.data?.itemID
                        completionBlock(successValue, itemLookUpModel, errorMsg)
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
    
    
    public func addItemToCart( strUrl : String , params:[String:Any] ,parentViewController: UIViewController, completionBlock:@escaping (Bool,AddItemResponseModel?,String?) -> ()) {
        
        //Construct header to pass to api call
       
        
        SessionManager.sharedInstance.apiRequest(url: strUrl, method: HTTPMethodType.PUT, parameter: params, headers: nil, parentViewController: parentViewController, showProgress: true) { (success, response, errorMessage) in
            
            
            let successValue = success
            let errorMsg = errorMessage
            
            if success {
                if let responseData = response as? Data {
                    let decoder = JSONDecoder()
                    
                    do {
                        let addItemResponseModel = try decoder.decode(AddItemResponseModel.self, from: responseData)
                        completionBlock(successValue, addItemResponseModel, errorMsg)
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
    
    public func removeItemFromCart( strUrl : String , params:[String:Any] ,parentViewController: UIViewController, completionBlock:@escaping (Bool,AddItemResponseModel?,String?) -> ()) {
        
        //Construct header to pass to api call
        
        
        SessionManager.sharedInstance.apiRequest(url: strUrl, method: HTTPMethodType.PUT, parameter: params, headers: nil, parentViewController: parentViewController, showProgress: true) { (success, response, errorMessage) in
            
            
            let successValue = success
            let errorMsg = errorMessage
            
            if success {
                if let responseData = response as? Data {
                    let decoder = JSONDecoder()
                    
                    do {
                        let addItemResponseModel = try decoder.decode(AddItemResponseModel.self, from: responseData)
                        completionBlock(successValue, addItemResponseModel, errorMsg)
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
    
    public func clearCart( strUrl : String  ,parentViewController: UIViewController, completionBlock:@escaping (Bool,AddItemResponseModel?,String?) -> ()) {
        
        //Construct header to pass to api call
        
        
        SessionManager.sharedInstance.apiRequest(url: strUrl, method: HTTPMethodType.PUT, parameter: nil, headers: nil, parentViewController: parentViewController, showProgress: true) { (success, response, errorMessage) in
            
            
            let successValue = success
            let errorMsg = errorMessage
            
            if success {
                if let responseData = response as? Data {
                    let decoder = JSONDecoder()
                    
                    do {
                        let addItemResponseModel = try decoder.decode(AddItemResponseModel.self, from: responseData)
                        completionBlock(successValue, addItemResponseModel, errorMsg)
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
