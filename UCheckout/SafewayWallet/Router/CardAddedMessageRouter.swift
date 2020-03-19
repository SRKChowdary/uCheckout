//
//  CardAddedMessageRouter.swift
//  UCheckout
//
//  Created by 1521398 on 28/08/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import Foundation
import UIKit

class CardAddedMessageRouter: CardAddedMessagePresenterToRouterProtocol {
    
    class func createModule(parentController: UINavigationController?) -> CardAddedMessageViewController {
        let view = CardAddedMessageStoryboard.instantiateViewController(withIdentifier: "CardAddedMessageViewController") as? CardAddedMessageViewController
        let presenter: CardAddedMessageViewToPresenterProtocol & CardAddedMessageInterectorToPresenterProtocol = CardAddedMessagePresenter()
        let interactor: CardAddedMessagePresentorToInterectorProtocol = CardAddedMessageInteractor()
        let router: CardAddedMessagePresenterToRouterProtocol = CardAddedMessageRouter()
        
        view?.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interector = interactor
        presenter.parentNavigationController = parentController
        presenter.viewController = view
        interactor.presenter = presenter
        
        return view!
    }
    
    static var CardAddedMessageStoryboard: UIStoryboard{
        return UIStoryboard(name:"CardAddedMessage",bundle: Bundle.main)
    }
}
