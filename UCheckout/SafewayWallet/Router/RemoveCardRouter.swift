//
//  RemoveCardRouter.swift
//  UCheckout
//
//  Created by 1521398 on 08/09/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import Foundation

class RemoveCardRouter: RemoveCardPresenterToRouterProtocol{
    
    class func createModule() -> RemoveCardViewController {
        let view = RemoveCardStoryboard.instantiateViewController(withIdentifier: "RemoveCardViewController") as? RemoveCardViewController
        let presenter: RemoveCardViewToPresenterProtocol & RemoveCardInterectorToPresenterProtocol = RemoveCardPresenter()
        let router: RemoveCardPresenterToRouterProtocol = RemoveCardRouter()
        
        view?.presenter = presenter
        presenter.view = view
        presenter.router = router
        
        return view!
    }
    
    static var RemoveCardStoryboard: UIStoryboard{
        return UIStoryboard(name:"RemoveCard",bundle: Bundle.main)
    }
}
