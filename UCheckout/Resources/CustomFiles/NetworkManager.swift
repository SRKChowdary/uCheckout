//
//  NetworkManager.swift
//  UCheckout
//
//  Created by Nilesh Jha on 21/11/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkManagerProtocol : class {
    func wifiRechability(isAvailable : Bool)
}

class NetworkManager {
    
    //shared instance
    static let shared = NetworkManager()
    weak var delegate : NetworkManagerProtocol?
    
    let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")
    
    func startNetworkReachabilityObserver() {
        
        reachabilityManager?.listener = { [weak self] status in
            switch status {
                
            case .notReachable:
                print("The network is not reachable")
                 self?.delegate?.wifiRechability(isAvailable: false)
                
            case .unknown :
                print("It is unknown whether the network is reachable")
                 self?.delegate?.wifiRechability(isAvailable: false)
                
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
                self?.delegate?.wifiRechability(isAvailable: true)
                
            case .reachable(.wwan):
                print("The network is reachable over the WWAN connection")
                 self?.delegate?.wifiRechability(isAvailable: false)
                
            }
        }
        
        // start listening
        reachabilityManager?.startListening()
    }
}
