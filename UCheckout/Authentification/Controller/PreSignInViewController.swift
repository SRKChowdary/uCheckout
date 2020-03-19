//
//  PreSignInViewController.swift
//  UCheckout
//
//  Created by i2i innovations on 22/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit
import ABAuthenticator

class PreSignInViewController: WhiteStatusBaseViewController {
  
    
    // IB OUTLETS :
    @IBOutlet weak var createAccountButtonOutlet: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createAccountButtonOutlet.isHidden = true
        createAccountButtonOutlet.isUserInteractionEnabled = false
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    
    @IBAction func signInButtonAction(_ sender: UIButton) {
        if let scanVC = UIStoryboard.authentification.instantiateViewController(withIdentifier: "LoginSDKViewController") as? LoginSDKViewController {
            let navController = UINavigationController(rootViewController: scanVC)
            UIApplication.shared.keyWindow?.rootViewController = navController
            
        }
    }
   
    
    private func gotoAppLogin(){
        if let scanVC = UIStoryboard.authentification.instantiateViewController(withIdentifier: "PreSignInViewController") as? PreSignInViewController {
            self.navigationController?.pushViewController(scanVC, animated: true)
        }
    }
    
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        var isFound = false
        if let vcArray = self.navigationController?.viewControllers , vcArray.count != 0{
            for item in vcArray {
                if item.isKind(of: OnBoardingViewController.self) {
                    isFound = true
                    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                        navigationController.popToViewController(item, animated: true)
                        
                    }
                }
            }
        }
        if !isFound {
            if let scanVC = UIStoryboard.onBoarding.instantiateViewController(withIdentifier: "OnBoardingViewController") as? OnBoardingViewController {
                if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                    navigationController.pushViewController(scanVC, animated: true)
                    
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


