//
//  CardAddedMessageViewController.swift
//  UCheckout
//
//  Created by 1521398 on 27/08/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import UIKit

class CardAddedMessageViewController: UIViewController {
    @IBOutlet weak var messageLabel: UILabel!
    var presenter: CardAddedMessageViewToPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func doneButtonDidTapped(_ sender: Any) {
        presenter?.close()
    }
}

extension CardAddedMessageViewController: CardAddedMessagePresenterToViewProtocol {
    
    func showResult(message: String) {
        print(message)
        messageLabel.text = message
    }
}
