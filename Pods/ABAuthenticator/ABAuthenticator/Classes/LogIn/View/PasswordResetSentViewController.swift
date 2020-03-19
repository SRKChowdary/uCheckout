//
//  PasswordRestSentViewController.swift
//  SafewayDelivery
//
//  Created by Bindu Suma J on 01/10/19.
//  Copyright © 2019 Albertsons. All rights reserved.
//

import UIKit

class PasswordResetSentViewController: UIViewController {


    var scrollView = UIScrollView()
    var contentView = UIView()
    var emailSentLabel = UILabel()
    var messageOneLabel = UILabel()
    var messageTwoLabel = UILabel()
    var signInButton = UIButton()
    
    var schemeColor: UIColor = #colorLiteral(red: 0.8666666667, green: 0.1176470588, blue: 0.1450980392, alpha: 1)
    
    var buttonAttributes: [NSAttributedString.Key: Any] =
        [.font: UIFont.systemFont(ofSize: 13.0, weight: .bold),
         .foregroundColor: UIColor.white]
    
    override func viewDidLoad() {
        buildHierarchy()
        buildStyle()
        buildConstraints()
        accessibilitySetUp()
        view.backgroundColor = UIColor.white
    }
    
    func buildHierarchy()
    {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(emailSentLabel)
        contentView.addSubview(messageOneLabel)
        contentView.addSubview(messageTwoLabel)
        contentView.addSubview(signInButton)
        
    }
    
    func buildStyle(){
        emailSentLabel.text = "Forgot Password Reset Email Sent"
        emailSentLabel.textAlignment = .left
        emailSentLabel.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        emailSentLabel.numberOfLines = 2
        
        //Message Labels
        
        messageOneLabel.text = "Check your email for a password reset link. Your link will expire in 6 hours."
        messageOneLabel.textAlignment = .left
        messageOneLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        messageOneLabel.textColor = UIColor(red: 75/255, green: 74/255, blue: 75/255, alpha: 1)
        messageOneLabel.numberOfLines = 3
        
        messageTwoLabel.text = "If you don’t see an email soon please check your Spam folder."
        messageTwoLabel.textAlignment = .left
        messageTwoLabel.font = UIFont.systemFont(ofSize: 18, weight: .regular)//Style.font(18, weight: UIFont.Weight.regular)
        messageTwoLabel.textColor = UIColor(red: 75/255, green: 74/255, blue: 75/255, alpha: 1)
        messageTwoLabel.numberOfLines = 2
        
      /// SignIn Button
        signInButton.backgroundColor = schemeColor
        signInButton.setAttributedTitle(NSMutableAttributedString(string: "SIGN IN", attributes: buttonAttributes), for: .normal)
        signInButton.addTarget(self, action: #selector(signInButtonAction), for: .touchUpInside)

    }
    
    
    func buildConstraints()
    {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        emailSentLabel.snp.makeConstraints({make in
            make.topMargin.equalToSuperview().offset(78)
            make.leftMargin.equalToSuperview().offset(18)
            make.rightMargin.equalToSuperview().offset(-40)
        })
        
        messageOneLabel.snp.makeConstraints({make in
            make.top.equalTo(emailSentLabel.snp.bottom).offset(22)
            make.leftMargin.equalToSuperview().offset(18)
            make.rightMargin.equalToSuperview().offset(-20)
        })
        
        messageTwoLabel.snp.makeConstraints({make in
            make.top.equalTo(messageOneLabel.snp.bottom).offset(22)
            make.leftMargin.equalToSuperview().offset(18)
            make.rightMargin.equalToSuperview().offset(-20)
        })
        
        
        // SignInButton
        signInButton.snp.makeConstraints({make in
            make.top.equalTo(messageTwoLabel.snp.bottom).offset(44)
            make.leftMargin.equalToSuperview().offset(20)
            make.rightMargin.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        })
        
    }
    
    func accessibilitySetUp()
    {
        signInButton.accessibilityHint = "Double tap on Sign In button"
        
        self.view.accessibilityElements = [emailSentLabel, messageOneLabel, messageTwoLabel, signInButton]
    }
    
    
    @objc func signInButtonAction(sender: UIButton)
    {
        
    }
    
}
