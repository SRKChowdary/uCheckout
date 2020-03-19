//
//  OktaConfigurationManager.swift
//  UCheckout
//
//  Created by i2i innovation on 12/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation

class OktaConfigurationManager {
    
    static let manager = OktaConfigurationManager()
    var baseURL = ""
    var ocpSubscriptionkey = ""
    var clientId = ""
    var clientSecret = ""
    var refreshTokenKey = ""
    
    private init(){
        getBaseParameter()
        
    }
    
    func getBaseParameter() {
        guard  let environment = Bundle.main.infoDictionary?["Configuration"] as? String  else {
            fatalError()
        }
        guard let pathOfPlist = Bundle.main.path(forResource: "OktaConfiguration", ofType: "plist") else {
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
        guard let clientId = configDict["clientId"] as? String  else {
            fatalError()
        }
        self.clientId = clientId
        guard let clientSecret = configDict["clientSecret"] as? String  else {
            fatalError()
        }
        self.clientSecret = clientSecret
        
        guard let refreshTokenKey = configDict["refreshTokenKey"] as? String  else {
            fatalError()
        }
        self.refreshTokenKey = refreshTokenKey
        
    }
    
}

