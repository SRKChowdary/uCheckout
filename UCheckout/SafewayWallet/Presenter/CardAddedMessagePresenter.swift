//
//  CardAddedMessagePresenter.swift
//  UCheckout
//
//  Created by 1521398 on 28/08/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import Foundation

class CardAddedMessagePresenter: CardAddedMessageViewToPresenterProtocol {
    
    var view: CardAddedMessagePresenterToViewProtocol?
    var interector: CardAddedMessagePresentorToInterectorProtocol?
    var router: CardAddedMessagePresenterToRouterProtocol?
    var parentNavigationController: UINavigationController?
    var viewController: CardAddedMessageViewController?
    var delegate: CardAddedMessageProtocol?
    
    
    func close() {
        delegate?.dismiss(cardAddedMessagecontroller: viewController)
    }
    
}

extension CardAddedMessagePresenter: CardAddedMessageInterectorToPresenterProtocol {
    
}
