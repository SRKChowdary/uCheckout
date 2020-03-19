//
//  ForgotPasswordViewController.swift
//  UCheckout
//
//  Created by Nilesh on 12/11/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit
import ABCoreUI

protocol LoginSDKClass : class {
    func bringLoginScreenAgain()
}

class ForgotPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
     @IBOutlet var toolbar: UIToolbar!
    
    
    weak var loginSDKClassDelegate : LoginSDKClass?

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.setHidesBackButton(true, animated:true)
        registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         self.navigationItem.setHidesBackButton(false, animated:true)
        deregisterFromKeyboardNotifications()
    }
    
    func registerForKeyboardNotifications(){
        //Keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
        
        
    }
    func deregisterFromKeyboardNotifications(){
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        
        
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        
    }
    
    private func updateUI(){
        let rightBtn = UIBarButtonItem(image: UIImage(named: "close"), style: .plain, target: self, action: #selector(closeButtonCliked))
        self.navigationItem.rightBarButtonItem = rightBtn
        self.title = "Forgot Password"
        enterButton.isUserInteractionEnabled = false
        enterButton.backgroundColor = UIColor.lightGray
        emailAddressTextField.inputAccessoryView = toolbar
        
    }
    
    @objc func closeButtonCliked(){
        self.navigationController?.popViewController(animated: true)
        loginSDKClassDelegate?.bringLoginScreenAgain()
    }
    
    @IBAction func enterButtonAction(_ sender: UIButton) {
    }
    @IBAction func donebUttonAction(_ sender: UIBarButtonItem) {
        emailAddressTextField.resignFirstResponder()
        
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

extension ForgotPasswordViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return  true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text,
            let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            let result = EmailValidator.isValidEmail(updatedText)
            if result.isSuccess {
               emailAddressTextField.textColor = UIColor.black
               enterButton.isUserInteractionEnabled = true
               enterButton.backgroundColor = GlobalColor.KAppRedColor
            }
            else {
                 emailAddressTextField.textColor = GlobalColor.KAppRedColor
                enterButton.isUserInteractionEnabled = false
                enterButton.backgroundColor = UIColor.lightGray
            }
        }
       
        return true
    }
}
