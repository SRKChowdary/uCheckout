//
//  RemoveCardViewController.swift
//  UCheckout
//
//  Created by 1521398 on 08/09/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import UIKit

class RemoveCardViewController: UIViewController {
    var presenter: RemoveCardViewToPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeIconDidTapped(_ sender: Any) {
        presenter?.close(controller: self)
    }
    
    @IBAction func cancelButtonDidTapped(_ sender: Any) {
        presenter?.close(controller: self)
    }
    
    @IBAction func removeButtonDidTapped(_ sender: Any) {
        presenter?.removeCard(controller: self)
    }
    
}

extension RemoveCardViewController: RemoveCardPresenterToViewProtocol {
    
    
}
