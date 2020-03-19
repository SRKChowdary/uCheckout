//
//  NewPaymentMethodPresenter.swift
//  UCheckout
//
//  Created by 1521398 on 25/08/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import Foundation

class NewPaymentMethodPresenter: NewPaymentMethodViewToPresenterProtocol {
    
    var view: NewPaymentMethodPresenterToViewProtocol?
    var interector: NewPaymentMethodPresentorToInterectorProtocol?
    var router: NewPaymentMethodPresenterToRouterProtocol?
    var parentNavigationController: UINavigationController?
    
    func goBack() {
        parentNavigationController?.popViewController(animated: true)
    }
    
    func addCard() {
        let newPaymentMethod = CardRegistrationRouter.createModule(parentController: parentNavigationController)
        parentNavigationController?.pushViewController(newPaymentMethod, animated: true)
    }
    
    
    func closePaymentMethods() {
        parentNavigationController?.popViewController(animated: false)
    }
}

extension NewPaymentMethodPresenter: NewPaymentMethodInterectorToPresenterProtocol {
    
}

