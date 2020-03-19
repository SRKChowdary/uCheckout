//
//  LandingViewController.swift
//  UCheckout
//
//  Created by i2i innovation on 26/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class LandingViewController: WhiteStatusBaseViewController {
    
    @IBOutlet weak var versionLabel: UILabel!
    
    
    var userName : String?
    var password : String?
    var signInviewModel = SignInviewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        versionLabel.text = "Version: \(UIDevice().appShortVersion)"
        forApiToken()

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
    
    private func forApiToken(){
        if let userName = userName , let password = password {
            signInviewModel.getToken(strUrl: UcheckoutManager.getOktaCompleteURl("/oauth2/\(OktaConfigurationManager.manager.refreshTokenKey)/v1/token"), userName: userName, password: password, parentViewController: self) { (success, octaData, message) in
                DispatchQueue.main.async {
                    if success {
                        if let octaData = octaData {
                            if  let token = octaData.accessToken, let refrshToken = octaData.refreshToken  {
                                let expTime = octaData.expiresIn
                                let user = UcheckoutManager.getUserProfileFromOktaToken(jwtToken: token, refreshToken: refrshToken)
                                let shared = UcheckoutSingleton.shared
                                shared.userData = user
                                if let scanVC = UIStoryboard.home.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                                    self.navigationController?.pushViewController(scanVC, animated: true)
                                }
                                
                            }
                            
                        }
                    }
                    else {
                        
                        if let scanVC = UIStoryboard.authentification.instantiateViewController(withIdentifier: "LoginSDKViewController") as? LoginSDKViewController {
                            let navController = UINavigationController(rootViewController: scanVC)
                             UIApplication.shared.keyWindow?.rootViewController = navController
                            
                        }
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
