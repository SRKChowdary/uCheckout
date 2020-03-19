//
//  CardTermsAndConditionsRouter.swift
//  UCheckout
//
//  Created by 1521398 on 27/08/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import Foundation
import UIKit

class CardTermsAndConditionsRouter: CardTermsAndConditionsPresenterToRouterProtocol {
    
    class func createModule(parentController: UINavigationController?, cardDetails: CardDetails) -> CardTermsAndConditionsViewController {
        let view = CardTermsAndConditionsStoryboard.instantiateViewController(withIdentifier: "CardTermsAndConditionsViewController") as? CardTermsAndConditionsViewController
        let presenter: CardTermsAndConditionsViewToPresenterProtocol & CardTermsAndConditionsInterectorToPresenterProtocol = CardTermsAndConditionsPresenter(cardDetails: cardDetails)
        let interactor: CardTermsAndConditionsPresentorToInterectorProtocol = CardTermsAndConditionsInteractor()
        let router: CardTermsAndConditionsPresenterToRouterProtocol = CardTermsAndConditionsRouter()
        
        view?.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interector = interactor
        presenter.parentNavigationController = parentController
        presenter.viewController = view
        interactor.presenter = presenter
        
        return view!
    }
    
    static var CardTermsAndConditionsStoryboard: UIStoryboard{
        return UIStoryboard(name:"CardTermsAndConditions",bundle: Bundle.main)
    }
}
