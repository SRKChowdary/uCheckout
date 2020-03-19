//
//  ConfigurationManager.swift
//  UCheckout
//
//  Created by i2i Innovation on 21/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation

class ConfigurationManager {
    
    static let manager = ConfigurationManager()
    var baseURL = ""
    var ocpSubscriptionkey = ""
    
    private init(){
        getBaseParameter()
        
    }
    
    func getBaseParameter() {
        guard  let environment = Bundle.main.infoDictionary?["Configuration"] as? String  else {
           fatalError()
        }
            guard let pathOfPlist = Bundle.main.path(forResource: "Configuration", ofType: "plist") else {
                fatalError()
            }
            let rootDict = NSDictionary(contentsOfFile: pathOfPlist)
            guard let configDict = rootDict?[environment] as? [String:Any] else {
                fatalError()
            }
            guard let baseUrl = configDict["baseURL"] as? String  else {
               fatalError()
            }
           self.baseURL = baseUrl
        guard let ocpSubscriptionKey = configDict["Ocp-Apim-Subscription-key"] as? String  else {
            fatalError()
        }
        self.ocpSubscriptionkey = ocpSubscriptionKey
        
    }
    
}
