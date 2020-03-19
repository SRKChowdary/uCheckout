//
//  SignInViewController.swift
//  UCheckout
//
//  Created by i2i innovation on 08/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit



class SignInViewController: WhiteStatusBaseViewController {
    
    // MARK: - IB outLet Connections

    @IBOutlet weak var passwordVisibleButton: UIButton!
    
    @IBOutlet weak var userNameErrorView: UIView!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet var toolbar: UIToolbar!

    @IBOutlet weak var backButton: UIButton!
    
    
    
    // MARK: - Variable Declarations

    var signInviewModel = SignInviewModel()
    var isBackButtonVisible = true
    
    
    
    // MARK: - View Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        backButton.isHidden = !isBackButtonVisible

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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
    }
    
    
    // MARK: - Private Methods
    
    private func updateUI(){
        passwordTextField.inputAccessoryView = toolbar

    }

    
    private func signIn()
    {
        signInviewModel.checkValidUser(strUrl: "\(UcheckoutManager.getRetailCompleteURl("/checkalloweduser"))?email=\(userNameTextField.text!)&app=scanandgo", parentViewController: self) { (success, signInData, message) in
            DispatchQueue.main.async {
                if success {
                    if let signInDat = signInData {
                        if let ack = signInDat.ack {
                            if ack == "0" {
                                self.getOctaDetails()
                                
                            }
                                
                            else if ack == "1"{
                                if let errors = signInDat.errors {
                                    if errors.count > 0 {
                                        if let message = errors.first?.message {
                                            SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: message , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                                            self.userNameErrorView.isHidden = false
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
    private func getOctaDetails(){
        signInviewModel.getOctaTokeDetails(strUrl: UcheckoutManager.getOktaCompleteURl("/api/v1/authn"), params: ["username":  userNameTextField.text!,"password": passwordTextField.text!], parentViewController: self) { (success, oktaDetails, message) in
            DispatchQueue.main.async {
                if success {
                    if let oktaModel = oktaDetails {
                        if let status = oktaModel.status {
                            if status == "PASSWORD_EXPIRED" {
                                  SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: "Your password has expired. Please change." , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                                
                            }
                            else {
                                self.forApiToken()
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
    
    private func forApiToken(){
        
        signInviewModel.getToken(strUrl: UcheckoutManager.getOktaCompleteURl("/oauth2/\(OktaConfigurationManager.manager.refreshTokenKey)/v1/token"), userName: userNameTextField.text!, password: passwordTextField.text!, parentViewController: self) { (success, octaData, message) in
            DispatchQueue.main.async {
                if success {
                    if let octaData = octaData {
                         if  let token = octaData.accessToken, let refrshToken = octaData.refreshToken  {
                            let user = UcheckoutManager.getUserProfileFromOktaToken(jwtToken: token, refreshToken: refrshToken)
                            let shared = UcheckoutSingleton.shared
                            shared.userData = user
                            UserDefaults.standard.set(true, forKey: UserDefaultConstants.IsFirstTimeUser)
                            if let scanVC = UIStoryboard.home.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                                self.navigationController?.pushViewController(scanVC, animated: true)
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
    
   
    
    
    
    @IBAction func passwordShowButtonAction(_ sender: UIButton) {
        if passwordTextField.isSecureTextEntry {
            passwordTextField.isSecureTextEntry = false
            passwordVisibleButton.setImage(UIImage(named: "icPeek"), for: .normal)
        }
        else {
            passwordTextField.isSecureTextEntry = true
            passwordVisibleButton.setImage(UIImage(named: "icNopeek"), for: .normal)

        }
    }
    
    
    @IBAction func forgetPasswordButtonAction(_ sender: UIButton) {
    }
    
    @IBAction func createAccountButtonAction(_ sender: UIButton) {
    }
    
    
    @IBAction func signInButtonAction(_ sender: UIButton) {
//        userNameTextField.text = "testusertwo@safeway.com"
//         passwordTextField.text = "test1111"
        
//        userNameTextField.text = "eyoha.g@gmail.com"
//        passwordTextField.text = "Qwerty123"
//
        self.userNameErrorView.isHidden = true
        self.passwordErrorLabel.isHidden = true

        if userNameTextField.text?.count == 0 || userNameTextField.text == "" {
            SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: "Please enter UserName", isButtonVisible: true, buttonTitle: "OK", buttonImage: UIImage())

        }
        else if passwordTextField.text?.count ?? 0 < 8 || passwordTextField.text == "" {
            SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: "Please enter atleast 8 digit Password", isButtonVisible: true, buttonTitle: "OK", buttonImage: UIImage())
            
        }
        else {
             self.getOctaDetails()
        }
        
    }
    
    @IBAction func donebUttonAction(_ sender: UIBarButtonItem) {
        passwordTextField.resignFirstResponder()
        
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        var isFound = false
        if let vcArray = self.navigationController?.viewControllers , vcArray.count != 0{
            for item in vcArray {
                if item.isKind(of: PreSignInViewController.self) {
                    isFound = true
                    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                        navigationController.popToViewController(item, animated: true)
                        
                    }
                }
            }
        }
        if !isFound {
            if let scanVC = UIStoryboard.authentification.instantiateViewController(withIdentifier: "PreSignInViewController") as? PreSignInViewController {
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

extension SignInViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == passwordTextField {
            if textField.text?.count ?? 0 > 12 {
                return false
            }
            
        }
        return true
    }
}
