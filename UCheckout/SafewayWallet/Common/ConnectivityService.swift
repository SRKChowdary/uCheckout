//
//  ConnectivityService.swift
//  UCheckout
//
//  Created by 1521398 on 07/09/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import Foundation
import Network

class ConnectivityService {
    let networkMonitor = NWPathMonitor()
    
    init() {
        startNetworkMonitoring()
    }
    
    //Start monitoring the network changes
    private func startNetworkMonitoring() {
        let queue = DispatchQueue(label: "Monitor")
        networkMonitor.start(queue: queue)
        networkMonitor.pathUpdateHandler = { path in
            //Notify the model about network changes
        }
    }
    
    //Check whether device is in Online or not
    public func isOnline() -> Bool {
        return networkMonitor.currentPath.status == .satisfied
    }
}

