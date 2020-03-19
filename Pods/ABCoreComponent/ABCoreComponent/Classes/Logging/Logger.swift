//
//  Logger.swift
//  ABCoreComponent
//
//  Created by Ganesh Reddiar on 5/18/19.
//

import Foundation

class Logger {
    
    static let instance = Logger()
    
    func report (response: Data?) {
        #if DEBUG
        if let response = response,  let str = String(data: response, encoding: .utf8) {
            print ("# Reporting Response #")
            print (str)
            print ("# End of Response")
        }
        #endif
    }
    
    
}
