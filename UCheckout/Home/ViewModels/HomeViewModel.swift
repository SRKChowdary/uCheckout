//
//  HomeViewModel.swift
//  UCheckout
//
//  Created by i2i innovation on 11/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class HomeViewModel: NSObject {
    
    
    public func getviewCart( strUrl : String ,parentViewController: UIViewController, completionBlock:@escaping (Bool,ViewCartModel?,String?) -> ()) {
        
        //Construct header to pass to api call
       // let headers: [String:String] = ["Content-Type":"application/json"]
        
        SessionManager.sharedInstance.apiRequest(url: strUrl, method: HTTPMethodType.GET, parameter: nil, headers: nil, parentViewController: parentViewController, showProgress: true) { (success, response, errorMessage) in
            
            
            let successValue = success
            let errorMsg = errorMessage
            
            if success {
                if let responseData = response as? Data {
                    let decoder = JSONDecoder()
                    
                    do {
                        let viewCartModel = try decoder.decode(ViewCartModel.self, from: responseData)
                         completionBlock(successValue, viewCartModel, errorMsg)
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
    
    
    public func getProfileData( strUrl : String , params:[String:Any] ,parentViewController: UIViewController, completionBlock:@escaping (Bool,GetprofileModel?,String?) -> ()) {
        
        //Construct header to pass to api call
        // let headers: [String:String] = ["Content-Type":"application/json"]
        
        SessionManager.sharedInstance.apiRequest(url: strUrl, method: HTTPMethodType.POST, parameter: params, headers: nil, parentViewController: parentViewController, showProgress: true) { (success, response, errorMessage) in
            
            let successValue = success
            let errorMsg = errorMessage
            
            if success {
                if let responseData = response as? Data {
                    let decoder = JSONDecoder()
                    
                    do {
                        let getprofileModel = try decoder.decode(GetprofileModel.self, from: responseData)
                        completionBlock(successValue, getprofileModel, errorMsg)
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
