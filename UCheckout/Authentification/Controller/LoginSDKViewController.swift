//
//  LoginSDKViewController.swift
//  UCheckout
//
//  Created by i2i innovation on 24/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit
import ABAuthenticator



class LoginSDKViewController: BaseViewController {
    
  
    //     var logInView: LogInViewController? // Initialization with default color scheme
    var logInView: UINavigationController?
    var signInviewModel = SignInviewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
          buildLogin()
 
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      

    }
    
    private func buildLogin(){
       
        let config = LogInModule.init(banner: "Safeway",
                                      bannerImage: UIImage(named: "HomeLogo.png"),
                                      createAccountHeaderTitle: "",
                                      scheme: #colorLiteral(red: 0.8666666667, green: 0.1176470588, blue: 0.1450980392, alpha: 1)) // Initialization with custom configuration
        logInView = LogInWireframe.assembleLogInView(config: config, delegate: self)
       
        if let logInView = logInView {
            self.navigationController?.present(logInView, animated: true, completion: nil)
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

extension LoginSDKViewController: LogInMainViewBehavior {
    func forgotPasswordAction() {
        self.navigationController?.dismiss(animated: false, completion: {
            let vc = ForgotPasswordViewController.loadFromNib()
            vc.loginSDKClassDelegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        })
       
    }
    
    func createAccountAction() {
        let alert = UIAlertController(title: "Message", message: "Customize create account event", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.logInView?.present(alert, animated: true, completion: nil)
    }
    
    func onSuccess()
    {
        signInviewModel.checkValidUser(strUrl: "\(UcheckoutManager.getRetailCompleteURl("/checkalloweduser"))?email=\(LocalDataStore.retrieveValue("userName")!)&app=scanandgo", parentViewController: self) { (success, signInData, message) in
            DispatchQueue.main.async {
                if success {
                    if let signInDat = signInData {
                        if let ack = signInDat.ack {
                            if ack == "0" {
                                self.navigationController?.dismiss(animated: false, completion:
                                    {
                                        // MARK: - Move to HOME VC via registration
                                        
                                        if let isTermsAndConditionClicked  = UserDefaults.standard.value(forKey: UserDefaultConstants.IsTermsAndConditionClicked) as? Bool , isTermsAndConditionClicked {
                                            if let scanVC = UIStoryboard.home.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController
                                            {
                                                self.navigationController?.pushViewController(scanVC, animated: true)
                                            }
                                        }
                                        else {
                                            let vc = RegistrationTermsViewController.loadFromNib()
                                            self.navigationController?.pushViewController(vc, animated: true)
                                        }
                                        
                                        
                                }
                                )
                                
                            }
                                
                            else if ack == "1"{
                                if let errors = signInDat.errors {
                                    if errors.count > 0
                                    {
                                        
                                        if let scanVC = UIStoryboard.authentification.instantiateViewController(withIdentifier: "BlackListViewController") as? BlackListViewController {
                                            let navController = UINavigationController(rootViewController: scanVC)
                                            UIApplication.shared.keyWindow?.rootViewController = navController
                                            
                                        }
                                    }
                                    
                                }
                            }
                            
                        }
                    }
                }
                else {
                    SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: message! , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                }
            }
        }

        
    }
    
    func oktaConfiguration() -> OktaClient? {
        let oktaClient = OktaClient.init(svcName: "token_endpoint",
                                         hostName: OktaConfigurationManager.manager.baseURL,
                                         uri: "/oauth2/\(OktaConfigurationManager.manager.refreshTokenKey)/v1/token",
            clientId: OktaConfigurationManager.manager.clientId,
            clientSecret: OktaConfigurationManager.manager.clientSecret)
        print("refreshToken ---->", OktaConfigurationManager.manager.refreshTokenKey)
        
        
        return oktaClient
        
    }
    
    func saveUserKeychain (user: UserCredential) {
        // Save user object to keychain
        if let userName = user.name {
            LocalDataStore.saveValue(userName, UserDefaultConstants.UserName)
            
        }
        if let password = user.password {
            LocalDataStore.saveValue(password, UserDefaultConstants.Password)
            
        }
    }
    
    func saveLogInTokenKeychain (token: LogInToken) {
        
        // Save token object to keychain
        
        guard let client = token.token,
            
            let accessToken = client.accessToken,
            
          
            
            let refreshToken = client.refreshToken else {return}
        print("accessToken is ------>", accessToken)
        print("refreshToken is ------>", refreshToken)
        
        let user = UcheckoutManager.getUserProfileFromOktaToken(jwtToken: accessToken, refreshToken: refreshToken)
        let shared = UcheckoutSingleton.shared
        shared.userData = user
        UserDefaults.standard.set(true, forKey: UserDefaultConstants.IsFirstTimeUser)
        
        
    }
    
    
}

class LogInModule: LogInConfiguration {
    var banner: String?
    var bannerImage: UIImage?
    var createAccountHeaderTitle: String?
    var scheme: UIColor?
    
    init(banner: String? = nil,
         bannerImage: UIImage? = nil,
         createAccountHeaderTitle: String? = nil,
         scheme: UIColor? = #colorLiteral(red: 0.8666666667, green: 0.1176470588, blue: 0.1450980392, alpha: 1)) {
        self.banner = banner
        self.bannerImage = bannerImage
        self.createAccountHeaderTitle = createAccountHeaderTitle
        self.scheme = scheme
    }
}
extension LoginSDKViewController : LoginSDKClass {
    func bringLoginScreenAgain() {
        self.buildLogin()
    }
    
    
}
