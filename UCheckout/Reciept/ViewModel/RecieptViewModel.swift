//
//  RecieptViewModel.swift
//  UCheckout
//
//  Created by i2i innovation on 05/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class RecieptViewModel: NSObject {
    
    public func getRecieptHistory( strUrl : String ,parentViewController: UIViewController, completionBlock:@escaping (Bool,RecieptModelArray?,String?) -> ()) {
        
       
        
        SessionManager.sharedInstance.apiRequest(url: strUrl, method: HTTPMethodType.GET, parameter: nil, headers: nil, parentViewController: parentViewController, showProgress: true) { (success, response, errorMessage) in
            
            
            let successValue = success
            let errorMsg = errorMessage
            
            if success {
                if let responseData = response as? Data {
                    let decoder = JSONDecoder()
                    
                    do {
                        let itemLookUpModel = try decoder.decode(RecieptModelArray.self, from: responseData)
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
    

}
