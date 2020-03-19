//
//  Alert.swift
//  ABCoreComponent
//
//  Created by Ganesh Reddiar on 7/14/19.
//

import Foundation

public struct Alert {
    
    public init () {}
    public enum Action {
        
        case dismiss (Closure?)
        case tryAgain (Closure?)
        
        public func build () -> UIAlertAction? {
            switch self {
            case .dismiss(let closure):
                let cancelAction = UIAlertAction (title: "OK", style: .cancel, handler: { action in
                    closure?()
                })
                return cancelAction
            case .tryAgain(let closure):
                let cancelAction = UIAlertAction (title: "Try Again", style: .default, handler: {action in
                    closure?()
                })
                return cancelAction
            }
        }
    }
    
    static public func error(with title: String? = "Service Problem" , message: String? = nil, code: String? = nil, retryAction:Closure? = nil ) -> UIAlertController {
        
        var message = message ?? ""
        if let code = code {
            message += " Code: \(code)"
        }
        
        let alertView = UIAlertController (title: title, message: message, preferredStyle:.alert)
        
        if let dismissAction = Action.dismiss(nil).build() {
            alertView.addAction(dismissAction)
        }
        
        if let retryAction = retryAction, let tryAgainAction = Action.tryAgain(retryAction).build() {
            alertView.addAction(tryAgainAction)
        }
        return alertView
    }
}
