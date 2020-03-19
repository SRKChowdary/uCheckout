//
//  RegistrationTermsViewController.swift
//  UCheckout
//
//  Created by i2i Innovation on 11/6/19.
//  Copyright © 2019 Pranav. All rights reserved. WhiteStatusBaseViewController
//

import UIKit
import PassKit

class RegistrationTermsViewController: RedStatusBaseViewController
{
    // MARK: - IB outlets
    @IBOutlet weak var acceptButtonOutlet: UIButton!
    
    @IBOutlet weak var declineButtonOutlet: UIButton!
    
    @IBOutlet weak var aboveCheckBoxButton: UIButton!
    
    @IBOutlet weak var belowcheckBoxButton: UIButton!
    
    @IBOutlet weak var belowCheckboxLabel: UILabel!
    
    let text = "I have read and agree to Safeway’s general Privacy Policies."
    
   // var applePayStatus : Bool
        // I have read and agree to Safeway’s general Terms of Use.
    
    @IBOutlet weak var termsTextView: UITextView!
    
      // MARK: - View Life Cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // let url = URL(string: "https://scanandgoterms.azurewebsites.net")
       // termsTextView
        
        updateUI()
        declineButtonOutlet.layer.borderColor = UIColor.black.cgColor
        
        
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
         self.navigationController?.navigationBar.isHidden = true
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         self.navigationController?.navigationBar.isHidden = false
        
    }
    
     // MARK: - IB Actions :
    
    
    @IBAction func aboveCheckBoxButtonAction(_ sender: UIButton) {
        changeButtonImage(sender)
    }
    
    @IBAction func belowCheckBoxButtonAction(_ sender: UIButton) {
        changeButtonImage(sender)
    }
    
    @IBAction func crossButtonAction(_ sender: UIButton)
    {
        if let scanVC = UIStoryboard.authentification.instantiateViewController(withIdentifier: "LoginSDKViewController") as? LoginSDKViewController {
            let navController = UINavigationController(rootViewController: scanVC)
            UIApplication.shared.keyWindow?.rootViewController = navController
            
        }
        
    }
    
    
    
    
    @IBAction func AcceptButtonAction(_ sender: UIButton) {
        
        // If Apple Pay is added as the default method of payment :
        
        checkApplePay()
        
        
    
        // Incase Apple Pay added screen is shown to the user
         UserDefaults.standard.set(true, forKey: UserDefaultConstants.IsTermsAndConditionClicked)
        
//        if let scanVC = UIStoryboard.home.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
//            self.navigationController?.pushViewController(scanVC, animated: true)
//        }
    }
    
    @IBAction func declineButtonAction(_ sender: UIButton)
    {
        if let scanVC = UIStoryboard.authentification.instantiateViewController(withIdentifier: "LoginSDKViewController") as? LoginSDKViewController {
            let navController = UINavigationController(rootViewController: scanVC)
            UIApplication.shared.keyWindow?.rootViewController = navController
            
        }
       //self.navigationController?.popViewController(animated: true)
    }
    
    // let vc = WebkitViewController.loadFromNib()
   //  vc.urlString = "https://www.albertsonscompanies.com/about-us/our-policies/privacy-policy.html"
  //  vc.screenTitle = "Privacy policy"
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        let termsRange = (text as NSString).range(of: "Privacy Policies.")
        
        if gesture.didTapAttributedTextInLabel(label: belowCheckboxLabel, inRange: termsRange) {
           // let vc = TermsOfUseViewController.loadFromNib()
            let vc = WebkitViewController.loadFromNib()
            vc.urlString = "https://www.albertsonscompanies.com/about-us/our-policies/privacy-policy.html"
            vc.screenTitle = "Privacy policy"
            self.navigationController?.pushViewController(vc, animated: true)
        }else {
            print("Tapped none")
        }
    }
    
    // Apple Pay avail check
    
    func checkApplePay(){
        let paymentNetworks: [PKPaymentNetwork] = [.amex, .masterCard, .visa, .discover]

        // If wallet has a card for apple pay
        if PKPaymentAuthorizationController.canMakePayments(usingNetworks: paymentNetworks){
           UserDefaults.standard.set(true, forKey: "ApplePayEnabled")

            if let applePayAdded = UIStoryboard.applePayAdded.instantiateViewController(withIdentifier: "applePayDetected") as? ApplePayDetectedViewController {
                self.navigationController?.pushViewController(applePayAdded, animated: true)
            }

        }
        else{
            // If wallet doesnt have a card for apple pay
                    if let scanVC = UIStoryboard.home.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                        self.navigationController?.pushViewController(scanVC, animated: true)
                    }
        }

    }
    
    private func changeButtonImage(_ sender : UIButton){
        if let btnImage = sender.image(for: .normal),
            let Image = UIImage(named: "checkboxoff"), btnImage.pngData() == Image.pngData() {
            sender.setImage(UIImage(named:"checkboxOn"), for: .normal)
            
        }
        else {
            sender.setImage( UIImage(named:"checkboxoff"), for: .normal)
        }
        enableAcceptButton()
    }
    
    private func enableAcceptButton(){
        self.acceptButtonOutlet.isUserInteractionEnabled = true
        self.acceptButtonOutlet.backgroundColor = GlobalColor.KAppRedColor
        if let btnImage = aboveCheckBoxButton.image(for: .normal),
            let Image = UIImage(named: "checkboxoff"), btnImage.pngData() == Image.pngData() {
            self.acceptButtonOutlet.isUserInteractionEnabled = false
            self.acceptButtonOutlet.backgroundColor = GlobalColor.kGreyOutColor
        }
        if let btnImage = belowcheckBoxButton.image(for: .normal),
            let Image = UIImage(named: "checkboxoff"), btnImage.pngData() == Image.pngData() {
            self.acceptButtonOutlet.isUserInteractionEnabled = false
            self.acceptButtonOutlet.backgroundColor = GlobalColor.kGreyOutColor
        }
    }
    
    private func updateUI(){
        
        self.acceptButtonOutlet.isUserInteractionEnabled = false
        self.acceptButtonOutlet.backgroundColor = GlobalColor.kGreyOutColor
        belowCheckboxLabel.text = text
        self.belowCheckboxLabel.textColor =  UIColor.black
        let underlineAttriString = NSMutableAttributedString(string: text)
        let range1 = (text as NSString).range(of: "Privacy Policies.")
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.SNRegular(12.0), range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(red: 0/255.0, green: 145/255.0, blue: 221/255.0, alpha: 1.0), range: range1)
        belowCheckboxLabel.attributedText = underlineAttriString
        belowCheckboxLabel.isUserInteractionEnabled = true
        belowCheckboxLabel.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
    }
    
    
    

   
}







