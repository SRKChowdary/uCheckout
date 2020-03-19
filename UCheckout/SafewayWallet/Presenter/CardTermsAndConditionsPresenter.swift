//
//  CardTermsAndConditionsPresenter.swift
//  UCheckout
//
//  Created by 1521398 on 27/08/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import Foundation
class CardTermsAndConditionsPresenter: CardTermsAndConditionsViewToPresenterProtocol {
    
    var view: CardTermsAndConditionsPresenterToViewProtocol?
    var interector: CardTermsAndConditionsPresentorToInterectorProtocol?
    var router: CardTermsAndConditionsPresenterToRouterProtocol?
    var parentNavigationController: UINavigationController?
    var viewController: CardTermsAndConditionsViewController?
    var delegate: CardTermsAndConditionsProtocol?
    var cardDetails: CardDetails
    
    init(cardDetails: CardDetails) {
        self.cardDetails = cardDetails
    }
    
    func acceptAndContinue() {
        interector?.registerCard(using: cardDetails)
    }
    
    func close() {
        viewController?.dismiss(animated: true, completion: nil)
    }
    
}

extension CardTermsAndConditionsPresenter: CardTermsAndConditionsInterectorToPresenterProtocol {
    
    func showActivityIndicator() {
        view?.showActivityIndicator()
    }
    
    func hideActiviyIndicator() {
        view?.hideActiviyIndicator()
    }
    
    func showError(message: String) {
        view?.showError(message: message)
    }
    
    func cardRegistrationFailed(error: ErrorInfo) {
        delegate?.cardRegistrationFailed(for: self.viewController, error: error)
    }
    
    func cardRegistrationSuccess(message: String) {
        let cardAdded = CardAddedMessageRouter.createModule(parentController: parentNavigationController)
        cardAdded.presenter?.delegate = self
        viewController?.present(cardAdded, animated: true, completion: nil)
        cardAdded.presenter?.view?.showResult(message: message)
    }
}

extension CardTermsAndConditionsPresenter: CardAddedMessageProtocol {
    func dismiss(cardAddedMessagecontroller: CardAddedMessageViewController?) {
        cardAddedMessagecontroller?.dismiss(animated: false, completion: nil)
        //Dismiss Terms and conditions
        delegate?.dismiss(cardTermsAndConditions: self.viewController)
    }
    
    
}
