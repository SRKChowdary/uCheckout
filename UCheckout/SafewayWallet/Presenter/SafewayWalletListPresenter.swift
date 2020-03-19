//
//  SafewayWalletListPresenter.swift
//  UCheckout
//
//  Created by 1521398 on 25/08/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import Foundation

class SafewayWalletListPresenter: WalletListViewToPresenterProtocol {
    var view: WalletListPresenterToViewProtocol?
    var interector: WalletListPresentorToInterectorProtocol?
    var router: WalletListPresenterToRouterProtocol?
    var parentNavigationController: UINavigationController?
    var removeCardController: RemoveCardViewController?
    private var fdAccountId: String?
    
    func goBack() {
        parentNavigationController?.popViewController(animated: true)
    }
    
    func addNewCreditCard() {
        let newPaymentMethod = NewPaymentMethodRouter.createModule(parentController: parentNavigationController)
        parentNavigationController?.pushViewController(newPaymentMethod, animated: true)
    }
    
    func fetchCards() {
        interector?.fetchWallets()
    }
    
    func deleteAccount(fdAccountId: String) {
        self.fdAccountId = fdAccountId
        //Present Remove confirm
        let removeCard = RemoveCardRouter.createModule()
        removeCard.presenter?.delegate = self
        
        guard let parentController = parentNavigationController else {
            return
        }
        addViewControllerToContainerView(viewController: removeCard, parent: parentController)
    }
    
    func updateAllCardData(fdAccountId: String, applePayEnabled: Bool) {
        interector?.updateAllCardData(fdAccountId: fdAccountId, applePayEnabled: applePayEnabled)
    }
    
    private func addViewControllerToContainerView(viewController: UIViewController, parent: UIViewController) {
        parent.addChild(viewController)
        parent.view.addSubview(viewController.view)
        viewController.view.frame = parent.view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        viewController.didMove(toParent: parent)
    }
    
    func removeViewControllerFromContainer(viewController: UIViewController, parent: UIViewController) {
        viewController.didMove(toParent: parent)
        viewController.view.removeFromSuperview()
        viewController.removeFromParent()
    }
}

extension SafewayWalletListPresenter: WalletListInterectorToPresenterProtocol {
    
    func showActivityIndicator() {
        view?.showActivityIndicator()
    }
    
    func hideActiviyIndicator() {
        view?.hideActiviyIndicator()
    }
    
    func showError(message: String) {
        view?.showError(message: message)
    }
    
    func show(walletDetails: WalletDetails) {
        view?.show(walletDetails: walletDetails)
    }
    
    func cardDeletedSuccessfully() {
        DispatchQueue.main.async {
            guard let parentController = self.parentNavigationController, let removeCardController = self.removeCardController  else {
                return
            }
            self.removeViewControllerFromContainer(viewController: removeCardController, parent: parentController)
        }
    }
}

extension SafewayWalletListPresenter: RemoveCardPresenterProtocol {
    func close(controller: RemoveCardViewController) {
        guard let parentController = self.parentNavigationController else {
            return
        }
        self.removeViewControllerFromContainer(viewController: controller, parent: parentController)
    }
    
    func removeCard(controller: RemoveCardViewController) {
        self.removeCardController = controller
        if let fdAccountId = fdAccountId {
           interector?.deleteAccount(fdAccountId: fdAccountId)
        }
    }
}
