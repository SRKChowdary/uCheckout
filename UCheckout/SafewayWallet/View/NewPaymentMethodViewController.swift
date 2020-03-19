//
//  NewPaymentMethodViewController.swift
//  UCheckout
//
//  Created by 1521398 on 25/08/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import UIKit

class NewPaymentMethodViewController: UIViewController {
    
    
    @IBOutlet weak var applePayOutlet: UIImageView!
    
    @IBOutlet weak var closeBarButton: UIBarButtonItem!
    
    
    
    var presenter: NewPaymentMethodViewToPresenterProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        applePayOutlet.isHidden = true
        closeBarButton.isAccessibilityElement = true
        closeBarButton.accessibilityLabel = "Close Button"
    

        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonDidTapped(_ sender: Any) {
        presenter?.goBack()
    }
    
    @IBAction func didTappedClose(_ sender: Any) {
        self.isAccessibilityElement = true
        presenter?.closePaymentMethods()
    }
    
    @IBAction func didTappedAddCard(_ sender: Any) {
        presenter?.addCard()
    }

}

extension NewPaymentMethodViewController: NewPaymentMethodPresenterToViewProtocol {
    
    
}
