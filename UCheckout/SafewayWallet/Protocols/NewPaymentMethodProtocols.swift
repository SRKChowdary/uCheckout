//
//  NewPaymentMethodProtocols.swift
//  UCheckout
//
//  Created by 1521398 on 25/08/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import Foundation
import UIKit

protocol NewPaymentMethodPresenterToViewProtocol: class {

}

protocol NewPaymentMethodInterectorToPresenterProtocol: class {
    
}

protocol NewPaymentMethodPresentorToInterectorProtocol: class {
    var presenter: NewPaymentMethodInterectorToPresenterProtocol? {get set}
}

protocol NewPaymentMethodViewToPresenterProtocol: class {
    var view: NewPaymentMethodPresenterToViewProtocol? {get set}
    var interector: NewPaymentMethodPresentorToInterectorProtocol? {get set}
    var router: NewPaymentMethodPresenterToRouterProtocol? {get set}
    var parentNavigationController: UINavigationController?  {get set}
    func goBack()
    func addCard()
    func closePaymentMethods()
}

protocol NewPaymentMethodPresenterToRouterProtocol: class {
    static func createModule(parentController: UINavigationController?) -> UIViewController
}
