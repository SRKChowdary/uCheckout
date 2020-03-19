//
//  SessionManager.swift
//  UCheckout
//
//  Created by i2i innovation on 11/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration
import Alamofire
//import SwiftyJSON


typealias APIResult = (Bool,Any?,String?) -> ()

enum HTTPMethodType:Int {
    case GET = 1
    case POST = 2
    case PUT = 3
    case DELETE = 4
}

class SessionManager: NSObject {
    
    
    //MARK: - Properties
    
    static let sharedInstance: SessionManager = {
        let instance = SessionManager()
        
        // setup code
        
        return instance
    }()
    
    //MARK: - Private Methods
    
    private func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
    
    //MARK: - Public Methods
    
    /*
    public func apiRequest(url:String, method: HTTPMethodType, parameter: [String:Any]?, headers:[String:Any]?, parentViewController: UIViewController, showProgress: Bool = true, completion:@escaping APIResult) {
        
        //Check if internet is available
        if !self.connectedToNetwork() {
            completion(false, nil, CommonAlertMessage.InternetNotAvailable)
            return
        }
        //Show progress view
        if showProgress {
            DispatchQueue.main.async {
            MBProgressIndicator.hideIndicator(parentViewController.view)
             MBProgressIndicator.showIndicator(parentViewController.view)
               
            }
            
        }
        
        var httpMethodValue: HTTPMethod!
        switch method {
        case HTTPMethodType.GET:
            httpMethodValue = HTTPMethod.get
            break
        case HTTPMethodType.POST:
            httpMethodValue = HTTPMethod.post
            break
        case HTTPMethodType.PUT:
            httpMethodValue = HTTPMethod.put
            break
        case HTTPMethodType.DELETE:
            httpMethodValue = HTTPMethod.delete
            break
        }
        var localHeader = HTTPHeaders()
        if headers != nil {
            //TODO
          // have to add extra header
            if let locHeaders = headers {
                let allKeys = locHeaders.keys
                if locHeaders.count > 0 {
                    for item in allKeys {
                        localHeader[item] = locHeaders[item] as! String
                    }
                }
            }
            

    
        }
        else {
            localHeader = HTTPHeaders.getHeaders()
        }
        
        print("****************URL Request Start*************************")
        if let param = parameter {
           print("Request parameters ----->>>> \(String(describing: param))")
        }
        
        print("Request Headers ----->>>> \(String(describing: localHeader))")
        
        
       
        
        AF.request(url, method: httpMethodValue, parameters: parameter, encoding: JSONEncoding(options: []), headers: localHeader, interceptor: nil).responseData { (response) in
            print("Request  ----->>>> \(String(describing: response.request))")
            if let requestData = response.value {
                if let json = try? JSON(data: requestData) {
                    print("Response  ----->>>>\(json)")
                }
                
            }
            print("****************URL Request End*************************")
            //Hide progress view
            
            if showProgress {
                DispatchQueue.main.async {
                    MBProgressIndicator.hideIndicator(parentViewController.view)
                }
            }
            
            switch(response.result) {
            case .success:
                completion(true, response.data, "")
                break
            case .failure:
                completion(false, nil, CommonAlertMessage.FetchingDataError)
                return
            }
        }
       
       
        
    }*/
 
    public func apiRequest(url:String, method: HTTPMethodType, parameter: [String:Any]?, headers:[String:String]?, parentViewController: UIViewController, showProgress: Bool, completion:@escaping APIResult) {
        
        //Check if internet is available
        if !self.connectedToNetwork() {
            completion(false, nil, CommonAlertMessage.InternetNotAvailable)
            return
        }
        
        //Show progress view
        if showProgress {
            DispatchQueue.main.async {
                MBProgressIndicator.hideIndicator(parentViewController.view)
                MBProgressIndicator.showIndicator(parentViewController.view)
                
            }
            
        }
        
        var httpMethodValue: HTTPMethod!
        switch method {
        case HTTPMethodType.GET:
            httpMethodValue = HTTPMethod.get
            break
        case HTTPMethodType.POST:
            httpMethodValue = HTTPMethod.post
            break
        case HTTPMethodType.PUT:
            httpMethodValue = HTTPMethod.put
            break
        case HTTPMethodType.DELETE:
            httpMethodValue = HTTPMethod.delete
            break
        }
        
        var localHeader = HTTPHeaders()
        if headers != nil {
            //TODO
            // have to add extra header
            if let locHeaders = headers {
                let allKeys = locHeaders.keys
                if locHeaders.count > 0 {
                    for item in allKeys {
                        localHeader[item] = locHeaders[item] as! String
                    }
                }
            }
            
            
            
        }
        else {
            
            var headers: HTTPHeaders = [
                "Content-Type": "application/json",
                "Accept": "application/json"
            ]
            let sharedInstance = UcheckoutSingleton.shared
            if let storeId = sharedInstance.getprofileModelData?.stores?.storeID  {
                headers["storeid"] = storeId

            }
            guard let guid = sharedInstance.userData?.guid else {
                fatalError()
            }
            
            headers["guid"] = guid
            headers["Ocp-Apim-Subscription-key"] = ConfigurationManager.manager.ocpSubscriptionkey
            localHeader = headers
        }
        
        print("****************URL Request Start*************************")
        if let param = parameter {
            print("Request parameters ----->>>> \(String(describing: param))")
        }
        
        print("Request Headers ----->>>> \(String(describing: localHeader))")
        
        print("parameters = \(String(describing: parameter))")
        Alamofire.request(url, method: httpMethodValue, parameters: parameter, encoding: JSONEncoding.default, headers: localHeader)
            .responseJSON { (response) in
               
                if let locData = response.data {
                    let responseString = String(data: locData, encoding: .utf8)
                    let env = UcheckoutManager.getEnvironment()
                    if env != EnvConstants.kProduction {
                     print("Request  ----->>>> \(String(describing: response.request))")
                       print("responseString = \(String(describing: responseString))")

                    }
                    
                print("responseString = \(String(describing: responseString))")


                }
                
                print("****************URL Request End*************************")
               
                //Hide progress view
                
               
                    DispatchQueue.main.async {
                        MBProgressIndicator.hideIndicator(parentViewController.view)
                    }
                
                
                switch(response.result) {
                case .success:
                    completion(true, response.data, "")
                    break
                case .failure:
                    completion(false, nil, CommonAlertMessage.FetchingDataError)
                    return
                }
        }
        
    }
    
    public func apiRequestForAPIToken(url:String,userName : String, password: String, method: HTTPMethodType, parentViewController: UIViewController, showProgress: Bool = true, completion:@escaping APIResult) {
        
        //Check if internet is available
        if !self.connectedToNetwork() {
            completion(false, nil, CommonAlertMessage.InternetNotAvailable)
            return
        }
        else {
            if NetworkReachabilityManager()?.networkReachabilityStatus == .reachable(.ethernetOrWiFi) {
                //                completion(false, nil, "Please Switch to Cellualr Network")
                //                return
            }
        }
        //Show progress view
        if showProgress {
            DispatchQueue.main.async {
                MBProgressIndicator.hideIndicator(parentViewController.view)
                MBProgressIndicator.showIndicator(parentViewController.view)
                
            }
            
        }
        
        let url = URL(string: url)
        var request = URLRequest(url: url!, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalCacheData, timeoutInterval: 100)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let base64Authorization:String = UcheckoutManager.getOktaAuthorizationBas64Value() {
            request.setValue("Basic " + base64Authorization, forHTTPHeaderField: "Authorization")
        }
        request.setValue("utf-8", forHTTPHeaderField: "charset")
        request.httpShouldHandleCookies=false
        request.httpMethod = "POST"
        let body:String = "username=" + userName + "&password=" + password + "&grant_type=password&scope=openid profile offline_access"
        
        let bodydata = body.data(using: .utf8)
        
        request.httpBody = bodydata
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
            
            DispatchQueue.main.async {
                MBProgressIndicator.hideIndicator(parentViewController.view)
            }
            
            if error != nil{
                completion(false, nil, CommonAlertMessage.FetchingDataError)
                
                return
            }
            if let locData = data {
                let responseString = String(data: locData, encoding: .utf8)
                print("responseString = \(String(describing: responseString))")
                
                
            }
             completion(true, data, CommonAlertMessage.FetchingDataError)
            
            
        }
        task.resume()
        
        
        
    }
    
    
    
    
}

