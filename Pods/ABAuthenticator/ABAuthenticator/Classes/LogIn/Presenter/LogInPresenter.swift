//
//  LogInPresenter.swift
//  ABAuthenticator
//
//  Created by Ganesh Reddiar on 6/1/19.
//

import Foundation
import ABCoreComponent

class LogInPresenter {
    
    var interactor: LogInInteractor?
    weak var view: LogInViewBehavior?
    
    func signIn (user: String?, password: String? ) {
        
        let user = UserCredential (name: user, password: password)
        view?.showLoading()
        interactor?.signIn(user: user, completed: nil)
    }
}

extension LogInPresenter: LogInInteractorOuput {
    func outSuccess() {
        view?.showDone()
    }
    
    func outFailed(_ error: Error) {
        view?.showError(error)
    }
    
    func saveUserCredential(user: UserCredential?) {
        guard let safeUser = user else {return}
        view?.saveUserCredential(user: safeUser)
    }
    
    func saveLogInToken(token: LogInToken) {
        view?.saveLogInToken(token: token)
    }
}
