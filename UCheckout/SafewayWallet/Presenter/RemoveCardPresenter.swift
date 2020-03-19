//
//  RemoveCardPresenter.swift
//  UCheckout
//
//  Created by 1521398 on 08/09/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import Foundation
class RemoveCardPresenter: RemoveCardViewToPresenterProtocol {
    
    var view: RemoveCardPresenterToViewProtocol?
    var router: RemoveCardPresenterToRouterProtocol?
    weak var delegate: RemoveCardPresenterProtocol?
    
    func close(controller: RemoveCardViewController) {
        delegate?.close(controller: controller)
    }
    
    func removeCard(controller: RemoveCardViewController) {
        delegate?.removeCard(controller: controller)
    }
}

extension RemoveCardPresenter: RemoveCardInterectorToPresenterProtocol {
    
}

