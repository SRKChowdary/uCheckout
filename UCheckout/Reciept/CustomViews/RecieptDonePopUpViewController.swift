//
//  RecieptDonePopUpViewController.swift
//  UCheckout
//
//  Created by i2i innovation on 11/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit
import SwiftPopup

class RecieptDonePopUpViewController: SwiftPopup {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
         self.dismiss(animated: true, completion: nil)
    }
    

    @IBAction func yesButtonAction(_ sender: UIButton) {
        var isFound = false
        if let vcArray = self.navigationController?.viewControllers , vcArray.count != 0{
            for item in vcArray {
                if item.isKind(of: HomeViewController.self) {
                    isFound = true
                    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                        self.dismiss(animated: true) {
                            navigationController.popToViewController(item, animated: true)
                        }
                     
                        
                        
                        
                    }
                  
                }
            }
        }
        if !isFound {
            if let scanVC = UIStoryboard.home.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                    self.dismiss(animated: true) {
                          navigationController.pushViewController(scanVC, animated: true)
                    }
                  
                    
                }
               
            }
        }
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
