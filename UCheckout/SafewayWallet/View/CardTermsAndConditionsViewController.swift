//
//  CardTermsAndConditionsViewController.swift
//  UCheckout
//
//  Created by 1521398 on 27/08/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import UIKit

class CardTermsAndConditionsViewController: UIViewController {
    
    @IBOutlet weak var termsTextView: UITextView!
    
    let text = "By clicking “Accept & Continue”, you consent to and authorize:\r\r1. Your electronic acceptance of the Albertsons Companies Terms of Use, and \r\r2. Our storage of your card data (Name, Credit Card Number, Expiration Date) for purposes of future transactions using the app; (3) All transactions made via the company app using your mobile device, and (4) the company charging your selected payment method in the amount of each such transaction."

    var presenter: CardTermsAndConditionsViewToPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let attributedString = NSMutableAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 18.0, weight: .regular),
                                                                                                .foregroundColor: UIColor(white: 0.0, alpha: 1.0),
                        .kern: -0.24])
        attributedString.addAttribute(.link, value: "https://www.google.com", range: NSRange(location: 101, length: 33))
        
        termsTextView.attributedText = attributedString
        // Do any additional setup after loading the view.
        //showTerms()
        
    }
    

    @IBAction func closeButtonDidTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
        //presenter?.close()
    }
    
    @IBAction func acceptAndContinueDidTapped(_ sender: Any) {
        presenter?.acceptAndContinue()
    }
  
    
    
    
//    func showTerms() {
      // let attributedString = NSMutableAttributedString(string: SafewayWalletConstants.Messages.termsAndConditions, attributes: [
//            .font: UIFont.systemFont(ofSize: 15.0, weight: .regular),
//            .foregroundColor: UIColor(white: 0.0, alpha: 1.0),
//            .kern: -0.24
//            ])
//        attributedString.addAttributes([
//            .font: UIFont.systemFont(ofSize: 15.0, weight: .bold),
//            .foregroundColor: UIColor(red: 13.0 / 255.0, green: 144.0 / 255.0, blue: 215.0 / 255.0, alpha: 1.0)
//            ], range: NSRange(location: 101, length: 33))
//
//
//        // New :
//
//        termsAndConditionsLabel.attributedText = attributedString
//        termsAndConditionsLabel.isUserInteractionEnabled = true
//        termsAndConditionsLabel.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
//
//
//      //  let linkRange = (attributedString.string as NSString).range(of: "Albertsons Companies Terms of Use")
//
//       // attributedString.addAttribute(NSAttributedString.Key.link, value: "http://www.safeway.com/emmd/Vons/v1/TermsOfUse_mobile.html", range: linkRange)
//       // termsAndConditionsLabel.attributedText = attributedString
//
////        let vc = WebkitViewController.loadFromNib()
////        vc.urlString = "https://www.albertsonscompanies.com/about-us/our-policies/terms-of-use.html"
////        vc.screenTitle = "Terms of use"
////        self.navigationController?.pushViewController(vc, animated: true)
//
//    }
//
//    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
//
//        let vc = WebkitViewController.loadFromNib()
//        vc.title = "Albertsons Companies Terms of Use"
//       // vc.urlString = "https://www.albertsonscompanies.com/about-us/our-policies/terms-of-use.html"
//        vc.screenTitle = "Terms of use"
//        self.navigationController?.pushViewController(vc, animated: true)
//
////
////        let viewController = WebViewController(nibName: "WebViewController", bundle: nil)
////        viewController.titleLabel = "Terms And Conditions" //"Albertsons Companies Terms of Use"
////
////        viewController.urlString =  "http://www.safeway.com/emmd/Vons/v1/TermsOfUse_mobile.html"
////        UIApplication.topViewController()?.present(viewController, animated: true, completion: nil)
//        return false
//    }
    
}

extension CardTermsAndConditionsViewController: CardTermsAndConditionsPresenterToViewProtocol {
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func showActivityIndicator() {
        DispatchQueue.main.async {
            MBProgressIndicator.showIndicator(self.view)
        }
    }
    
    func hideActiviyIndicator() {
        DispatchQueue.main.async {
            MBProgressIndicator.hideIndicator(self.view)
        }
    }
}

extension CardTermsAndConditionsViewController : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
         let vc = TermsOfUseViewController.loadFromNib()
         vc.isFromWallet = true
         self.present(vc, animated: true, completion: nil)
        return false
    }
}
