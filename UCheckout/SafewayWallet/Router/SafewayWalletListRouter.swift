//
//  SafewayWalletListRouter.swift
//  UCheckout
//
//  Created by 1521398 on 25/08/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import Foundation
import UIKit

class SafewayWalletListRouter: WalletListPresenterToRouterProtocol {
    
//    let base = BaseViewController()
//    let transiton = SlideInTransition()
    
    class func createModule() -> UINavigationController {
        let navController = walletStoryboard.instantiateViewController(withIdentifier: "SafewayWalletListNavigationController") as? UINavigationController
        
        guard let view = navController?.children.first as? SafewayWalletListViewController else {
            return UINavigationController()
        }
        
        let presenter: WalletListViewToPresenterProtocol & WalletListInterectorToPresenterProtocol = SafewayWalletListPresenter()
        let interactor: WalletListPresentorToInterectorProtocol = SafewayWalletListInteractor()
        let router: WalletListPresenterToRouterProtocol = SafewayWalletListRouter()
        
        view.presenter = presenter
        presenter.view = view
        presenter.router = router
        presenter.interector = interactor
        presenter.parentNavigationController = navController
        interactor.presenter = presenter
        return navController!
    }
    
    static var walletStoryboard: UIStoryboard{
        return UIStoryboard(name:"SafewayWalletList",bundle: Bundle.main)
    }
}


extension SafewayWalletListRouter : MenuTableControllerProtocol
{
    func menuClickedWithIndexpath(_ indexpath: IndexPath) {
        switch indexpath.row {
    
        //case 4 : super.moveTo
            
//        case 1: base.moveToHomeMenu()
//        case 2: base.moveToCartMenu()
//        case 3: base.moveToAccount()
//        case 4: base.movetoSafewayWallet()
//        case 5: base.moveToRecieptMenu()
//        case 6: base.moveToAboutMenu()
//        case 7: base.logOut()
 
        default:
            break
        }
    }
    
    
}
