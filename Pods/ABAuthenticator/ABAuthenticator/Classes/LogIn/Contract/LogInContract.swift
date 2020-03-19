//
//  LogInContract.swift
//  ABAuthenticator
//
//  Created by Ganesh Reddiar on 6/1/19.
//

import Foundation


protocol LogInInteractorOuput: class {
    func outSuccess ()
    func outFailed (_ error: Error)
    func saveUserCredential (user: UserCredential?)
    func saveLogInToken (token: LogInToken)
}


protocol LogInViewBehavior: class{
    func showLoading()
    func showDone ()
    func showError (_ error: Error)
    func saveUserCredential (user: UserCredential)
    func saveLogInToken (token: LogInToken)
}

public protocol LogInMainViewBehavior: class {
    func onSuccess ()
    func forgotPasswordAction ()
    func createAccountAction ()
    func oktaConfiguration() -> OktaClient?
    func saveUserKeychain (user: UserCredential)
    func saveLogInTokenKeychain (token: LogInToken)
}
