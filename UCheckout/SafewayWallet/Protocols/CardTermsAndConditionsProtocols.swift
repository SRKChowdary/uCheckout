//
//  CardTermsAndConditionsProtocols.swift
//  UCheckout
//
//  Created by 1521398 on 27/08/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import Foundation
import UIKit

protocol CardTermsAndConditionsPresenterToViewProtocol: class {
    func showError(message: String)
    func showActivityIndicator()
    func hideActiviyIndicator()
}

protocol CardTermsAndConditionsInterectorToPresenterProtocol: class {
    func showError(message: String)
    func showActivityIndicator()
    func hideActiviyIndicator()
    func cardRegistrationFailed(error: ErrorInfo)
    func cardRegistrationSuccess(message: String)
}

protocol CardTermsAndConditionsPresentorToInterectorProtocol: class {
    var presenter: CardTermsAndConditionsInterectorToPresenterProtocol? {get set}
    func registerCard(using cardDetails: CardDetails)
}

protocol CardTermsAndConditionsViewToPresenterProtocol: class {
    var view: CardTermsAndConditionsPresenterToViewProtocol? {get set}
    var interector: CardTermsAndConditionsPresentorToInterectorProtocol? {get set}
    var router: CardTermsAndConditionsPresenterToRouterProtocol? {get set}
    var parentNavigationController: UINavigationController? {get set}
    var viewController: CardTermsAndConditionsViewController? {get set}
    var delegate: CardTermsAndConditionsProtocol? {get set}
    var cardDetails: CardDetails { get set }
    func acceptAndContinue()
    func close()
}

protocol CardTermsAndConditionsPresenterToRouterProtocol: class {
    static func createModule(parentController: UINavigationController?, cardDetails: CardDetails) -> CardTermsAndConditionsViewController
}

protocol CardTermsAndConditionsProtocol {
    func dismiss(cardTermsAndConditions: CardTermsAndConditionsViewController?)
    func cardRegistrationFailed(for controller:CardTermsAndConditionsViewController?, error: ErrorInfo)
}
