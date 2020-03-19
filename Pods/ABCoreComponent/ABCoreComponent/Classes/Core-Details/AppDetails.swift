//
//  AppDetails.swift
//  ABCoreComponent
//
//  Created by Ganesh Reddiar on 6/17/19.
//

import Foundation

public struct AppDetails {
    
    public static let displayName =
        Bundle.main.infoDictionary?["CFBundleName"] as? String
    
    public static let version =
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String
    
}
