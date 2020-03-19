//
//  CardRegistrationProtocols.swift
//  UCheckout
//
//  Created by 1521398 on 26/08/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import Foundation
import UIKit

protocol CardRegistrationPresenterToViewProtocol: class {
    func cardRegistrationFailed(error: ErrorInfo)
    func cardDetails() -> CardDetails
}

protocol CardRegistrationInterectorToPresenterProtocol: class {
    
}

protocol CardRegistrationPresentorToInterectorProtocol: class {
    var presenter: CardRegistrationInterectorToPresenterProtocol? {get set}
}

protocol CardRegistrationViewToPresenterProtocol: class {
    var view: CardRegistrationPresenterToViewProtocol? {get set}
    var interector: CardRegistrationPresentorToInterectorProtocol? {get set}
    var router: CardRegistrationPresenterToRouterProtocol? {get set}
    var parentNavigationController: UINavigationController? {get set}
    func goBack()
    func addNewCard()
}

protocol CardRegistrationPresenterToRouterProtocol: class {
    static func createModule(parentController: UINavigationController?) -> UIViewController
}
