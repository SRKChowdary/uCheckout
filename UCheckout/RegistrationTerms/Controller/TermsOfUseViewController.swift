//
//  TermsOfUseViewController.swift
//  UCheckout
//
//  Created by Nilesh Jha on 11/11/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class TermsOfUseViewController: BaseViewController {
    
    @IBOutlet weak var termsOfUseView: UIView!
    var isFromWallet = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Terms of Use"
        if isFromWallet {
           termsOfUseView.isHidden = false
        }
        else {
            termsOfUseView.isHidden = true
        }

        // Do any additional setup after loading the view.
    }
    

    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
