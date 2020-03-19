//
//  CardRegistrationRouter.swift
//  UCheckout
//
//  Created by 1521398 on 26/08/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import Foundation
import UIKit

class CardRegistrationRouter: CardRegistrationPresenterToRouterProtocol {
    
    class func createModule(parentController: UINavigationController?) -> UIViewController {
        let view = cardRegistrationStoryboard.instantiateViewController(withIdentifier: "CardRegistrationViewController") as? CardRegistrationViewController
        let presenter: CardRegistrationViewToPresenterProtocol & CardRegistrationInterectorToPresenterProtocol = CardRegistrationPresenter()
        let interactor: CardRegistrationPresentorToInterectorProtocol = CardRegistrationInteractor()
        let router: CardRegistrationPresenterToRouterProtocol = CardRegistrationRouter()
        
        view?.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interector = interactor
        presenter.parentNavigationController = parentController
        interactor.presenter = presenter
        
        return view!
    }
    
    static var cardRegistrationStoryboard: UIStoryboard{
        return UIStoryboard(name:"CardRegistration",bundle: Bundle.main)
    }
}
