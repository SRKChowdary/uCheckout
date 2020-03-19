//
//  NewPaymentMethodRouter.swift
//  UCheckout
//
//  Created by 1521398 on 25/08/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import Foundation
import UIKit

class NewPaymentMethodRouter: NewPaymentMethodPresenterToRouterProtocol{
    
    class func createModule(parentController: UINavigationController?) -> UIViewController{
        let view = newPaymentMethodStoryboard.instantiateViewController(withIdentifier: "NewPaymentMethodViewController") as? NewPaymentMethodViewController
        let presenter: NewPaymentMethodViewToPresenterProtocol & NewPaymentMethodInterectorToPresenterProtocol = NewPaymentMethodPresenter()
        let interactor: NewPaymentMethodPresentorToInterectorProtocol = NewPaymentMethodInteractor()
        let router: NewPaymentMethodPresenterToRouterProtocol = NewPaymentMethodRouter()
        
        view?.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interector = interactor
        presenter.parentNavigationController = parentController
        interactor.presenter = presenter
        
        return view!
    }
    
    static var newPaymentMethodStoryboard: UIStoryboard{
        return UIStoryboard(name:"NewPaymentMethod",bundle: Bundle.main)
    }
}
