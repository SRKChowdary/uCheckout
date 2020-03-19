//
//  RemoveCardProtocols.swift
//  UCheckout
//
//  Created by 1521398 on 08/09/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import Foundation

protocol RemoveCardPresenterToViewProtocol: class {
    
}

protocol RemoveCardInterectorToPresenterProtocol: class {

}

protocol RemoveCardPresentorToInterectorProtocol: class {
    var presenter: RemoveCardInterectorToPresenterProtocol? {get set}
}

protocol RemoveCardViewToPresenterProtocol: class {
    var view: RemoveCardPresenterToViewProtocol? {get set}
    var router: RemoveCardPresenterToRouterProtocol? {get set}
    var delegate: RemoveCardPresenterProtocol? {get set}
    func close(controller: RemoveCardViewController)
    func removeCard(controller: RemoveCardViewController)
}

protocol RemoveCardPresenterToRouterProtocol: class {
    static func createModule() -> RemoveCardViewController
}

protocol RemoveCardPresenterProtocol: class {
    func close(controller: RemoveCardViewController)
    func removeCard(controller: RemoveCardViewController)
}
