//
//  DeviceDetails.swift
//  ABCoreComponent
//
//  Created by Ganesh Reddiar on 6/17/19.
//

import Foundation
public struct DeviceDetails {
    
    public static let osVersion =
        UIDevice.current.systemVersion
    
    public static let systemName =
        UIDevice.current.systemName
    
    public static let hardwarePlatform :String = {
        
        var size = 0
        sysctlbyname("hw.machine", nil, &size, nil, 0)
        var machine = [CChar](repeating: 0,  count: Int(size))
        sysctlbyname("hw.machine", &machine, &size, nil, 0)
        return String(cString: machine)
    }()
    
    public static let deviceType: String  = {
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return "iPhone"
        case .pad:
            return "iPad"
        case .tv:
            return "Apple TV"
            
        default:
            return "Unknown"
        }
    }()
}
