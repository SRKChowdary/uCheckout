//
//  SafewayWalletListProtocols.swift
//  UCheckout
//
//  Created by 1521398 on 25/08/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import Foundation
import UIKit

protocol WalletListPresenterToViewProtocol: class {
    func showError(message: String)
    func showActivityIndicator()
    func hideActiviyIndicator()
    func show(walletDetails: WalletDetails)
}

protocol WalletListInterectorToPresenterProtocol: class {
    func showError(message: String)
    func showActivityIndicator()
    func hideActiviyIndicator()
    func show(walletDetails: WalletDetails)
    func cardDeletedSuccessfully()
}

protocol WalletListPresentorToInterectorProtocol: class {
    var presenter: WalletListInterectorToPresenterProtocol? {get set}
    func fetchWallets()
    func deleteAccount(fdAccountId: String)
    func updateAllCardData(fdAccountId: String, applePayEnabled : Bool)
}

protocol WalletListViewToPresenterProtocol: class {
    var view: WalletListPresenterToViewProtocol? {get set}
    var interector: WalletListPresentorToInterectorProtocol? {get set}
    var router: WalletListPresenterToRouterProtocol? {get set}
    var parentNavigationController: UINavigationController? {get set}
    func fetchCards()
    func addNewCreditCard()
    func goBack()
    func updateAllCardData(fdAccountId: String, applePayEnabled : Bool)
    func deleteAccount(fdAccountId: String)
}

protocol WalletListPresenterToRouterProtocol: class {
    static func createModule() -> UINavigationController
}
