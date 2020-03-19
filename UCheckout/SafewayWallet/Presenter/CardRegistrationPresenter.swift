//
//  CardRegistrationPresenter.swift
//  UCheckout
//
//  Created by 1521398 on 26/08/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import Foundation

class CardRegistrationPresenter: CardRegistrationViewToPresenterProtocol {
    
    var view: CardRegistrationPresenterToViewProtocol?
    var interector: CardRegistrationPresentorToInterectorProtocol?
    var router: CardRegistrationPresenterToRouterProtocol?
    var parentNavigationController: UINavigationController?
    
    func goBack() {
        parentNavigationController?.popViewController(animated: true)
    }
    
    func addNewCard() {
        if let cardDetails = view?.cardDetails() {
            let termsAndConditions = CardTermsAndConditionsRouter.createModule(parentController: parentNavigationController, cardDetails: cardDetails)
            termsAndConditions.presenter?.delegate = self
            parentNavigationController?.present(termsAndConditions, animated: true, completion: nil)
        }
    }
}

extension CardRegistrationPresenter: CardRegistrationInterectorToPresenterProtocol {
    
}

extension CardRegistrationPresenter: CardTermsAndConditionsProtocol {
    func dismiss(cardTermsAndConditions: CardTermsAndConditionsViewController?) {
        cardTermsAndConditions?.dismiss(animated: false, completion: {
            self.parentNavigationController?.popToRootViewController(animated: false)
        })
        
    }
    
    func cardRegistrationFailed(for controller:CardTermsAndConditionsViewController?, error: ErrorInfo) {
        controller?.dismiss(animated: false, completion: nil)
        
        view?.cardRegistrationFailed(error: error)
    }
}
