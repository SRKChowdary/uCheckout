//
//  CardAddedMessageProtocols.swift
//  UCheckout
//
//  Created by 1521398 on 28/08/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import Foundation
import UIKit

protocol CardAddedMessagePresenterToViewProtocol: class {
    func showResult(message: String)
}

protocol CardAddedMessageInterectorToPresenterProtocol: class {
    
}

protocol CardAddedMessagePresentorToInterectorProtocol: class {
    var presenter: CardAddedMessageInterectorToPresenterProtocol? {get set}
}

protocol CardAddedMessageViewToPresenterProtocol: class {
    var view: CardAddedMessagePresenterToViewProtocol? {get set}
    var interector: CardAddedMessagePresentorToInterectorProtocol? {get set}
    var router: CardAddedMessagePresenterToRouterProtocol? {get set}
    var parentNavigationController: UINavigationController? {get set}
    var delegate: CardAddedMessageProtocol? { get set }
    var viewController: CardAddedMessageViewController? {get set}
    func close()
}

protocol CardAddedMessagePresenterToRouterProtocol: class {
    static func createModule(parentController: UINavigationController?) -> CardAddedMessageViewController
}

protocol CardAddedMessageProtocol {
    func dismiss(cardAddedMessagecontroller: CardAddedMessageViewController?)
}
