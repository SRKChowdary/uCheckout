//
//  FAQViewModel.swift
//  UCheckout
//
//  Created by Nilesh Jha on 06/11/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation

class  FAQViewModel : NSObject {
    public func getAllFAQs( strUrl : String ,parentViewController: UIViewController, completionBlock:@escaping (Bool,FAQModel?,String?) -> ()) {
        SessionManager.sharedInstance.apiRequest(url: strUrl, method: HTTPMethodType.GET, parameter: nil, headers: nil, parentViewController: parentViewController, showProgress: true) { (success, response, errorMessage) in
            
            
            let successValue = success
            let errorMsg = errorMessage
            
            if success {
                if let responseData = response as? Data {
                    let decoder = JSONDecoder()
                    
                    do {
                        let accountModel = try decoder.decode(FAQModel.self, from: responseData)
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
}
