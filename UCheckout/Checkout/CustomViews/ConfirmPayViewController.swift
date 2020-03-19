//
//  ConfirmPayViewController.swift
//  UCheckout
//
//  Created by i2i innovation on 19/08/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit
import SwiftPopup
import Firebase


enum CardType : String {
    case VISA = "VISA"
    case MASTERCARD = "MASTERCARD"
    case Amex = "Amex"
    case DISCOVER = "DISCOVER"
    
}


enum CardImage : String {
    case AppleCard = "appleCard"
    case Amexcard = "amexcard"
    case Discovercard = "discovercard"
     case Mastercard = "mastercard"
     case Visacard = "visacard"
}


class ConfirmPayViewController: SwiftPopup {
    
     // MARK: - IBOutlet Connection
    
    @IBOutlet weak var cardDetailLabel: UILabel!
    @IBOutlet weak var cardImage: UIImageView!
    
    @IBOutlet weak var subTotalLabel: UILabel!
    
    @IBOutlet weak var subTotalCostlabel: UILabel!
    
    @IBOutlet weak var bagsLabel: UILabel!
    
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var bagPriceLabel: UILabel!
    
    @IBOutlet weak var totalDiscountPriceLabel: UILabel!
    
    @IBOutlet weak var totalTaxPriceLabel: UILabel!
    
    @IBOutlet weak var finalPriceLabel: UILabel!
    
    @IBOutlet weak var cancelOrderButton: UIButton!
    
    @IBOutlet weak var crossButton: UIButton!
    
    @IBOutlet weak var changeButton: UIButton!
    
    
    @IBOutlet weak var FinishPaySubView: UIView!
    
    

    
    

    
    
    // MARK: - Variable Declartaion

    
    var accountModel : AccountModels?
    var checkoutModel : CheckoutModel?
    var recieptModel : RecieptModel?
    var bagCount : Int?
    var checkoutViewModel = CheckoutViewModel()
    var storeCount: Int?
    var recieptDetailList : ReceiptItemDetailsList?
    
    
   // MARK: - View Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
                populateUI()
        crossButton.isHidden = true
        cancelOrderButton.layer.borderWidth = 2
        cancelOrderButton.layer.borderColor = UIColor(red: 60.0/255.0, green: 60.0/255.0, blue: 60.0/255.0, alpha: 1.0).cgColor
        
        // accessibility focus order :
        
        self.FinishPaySubView.accessibilityElements = [cardDetailLabel,changeButton]
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.getAccountDetails()
        populateUI()

    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    private func populateUI(){
        if let aactModel = accountModel {
            if let applePayFlag = aactModel.applePayFlag , applePayFlag  {
                cardImage.image = UIImage(named: CardImage.AppleCard.rawValue)
                cardDetailLabel.text = "Apple Pay"
            }
            else {
                if let cardDetailArray = aactModel.accounts {
                    if let defaultCard = cardDetailArray.first(where: {$0.fdAccountID == aactModel.defaultCard}) {
                        if let cardType = defaultCard.credit?.cardType {
                           if let tokenID = defaultCard.token?.tokenID {
                            changeButton.setTitle("Change", for: .normal)
                            payButton.isUserInteractionEnabled = true
                            payButton.alpha = 1.0
                            switch cardType {
                            case CardType.Amex.rawValue :
                                 cardDetailLabel.text = String(format:"Amex - %@", String(tokenID.suffix(4)).capitalized)
                                cardImage.image = UIImage(named: CardImage.Amexcard.rawValue)
                                
                            case CardType.DISCOVER.rawValue :
                                cardDetailLabel.text = String(format:"Discover - %@", String(tokenID.suffix(4)).capitalized)
                                cardImage.image = UIImage(named: CardImage.Discovercard.rawValue)
                                
                            case CardType.MASTERCARD.rawValue :
                                cardDetailLabel.text = String(format:"Mastercard - %@", String(tokenID.suffix(4)).capitalized)
                                cardImage.image = UIImage(named: CardImage.Mastercard.rawValue)
                                
                            case CardType.VISA.rawValue :
                                cardDetailLabel.text = String(format:"Visa - %@", String(tokenID.suffix(4)).capitalized)
                                cardImage.image = UIImage(named: CardImage.Visacard.rawValue)
                                
                                
                            default: break
                                
                            }
                           } else {
                             makeButtonDisabled()
                            }
                           
                        }
                    }
                    else {
                        makeButtonDisabled()
                        
                    }
                }
                else {
                    makeButtonDisabled()
                }
            }
        }
        else {
             makeButtonDisabled()
        }
        
        if let recieptModel = recieptModel
        {
            // Bug Fix : Shifting back to the old logic of Sub Total
            // let userDiscount = recieptModel.data?.receiptJSON?.receiptTotalResult?.totalSavings
            
            if let itemCount = recieptModel.data?.itemCount {
                subTotalLabel.text = "Subtotal (\(itemCount))"
            }
//            if let subTotal = recieptModel.data?.totalAmount {
//                let price = (subTotal) + (userDiscount ?? 0)
//                let finalPrice = String(format: "%.2f", price)
//                subTotalCostlabel.text = "$\(finalPrice)"
//            }
            
            
            if let subTotal = recieptModel.data?.receiptJSON?.receiptTotalResult?.subTotal
            {
                let price = String(format : "%.2f", subTotal)
                subTotalCostlabel.text = "$\(price)"
            }
            if let tax = recieptModel.data?.receiptJSON?.receiptTotalResult?.tax {
                let price = String(format: "%.2f", tax)
                totalTaxPriceLabel.text = "$\(price)"
            }
            if let discount = recieptModel.data?.receiptJSON?.receiptTotalResult?.totalSavings {
                let price = String(format: "%.2f", discount)
                totalDiscountPriceLabel.text = "-$\(price)"
            }
            if let total = recieptModel.data?.receiptJSON?.receiptTotalResult?.total {
                let price = String(format: "%.2f", total)
                finalPriceLabel.text = "$\(price)"
            }
            
        }
        
//        if let bagCount = recieptDetailList?.deliveredQty
//        {
//            bagsLabel.text = "Bags (\(bagCount))"
//            bagPriceLabel.text = "$ \(String(format: "%.2f", Double(bagCount) ?? 0 * 0.10))"
//        }
//        else
//        {
//            bagsLabel.text = "Bags(0)"
//            bagPriceLabel.text = "$0.00"
//        }
        
        if let bagCount = bagCount {
            bagsLabel.text = "Bags (\(bagCount))"
            //bagPriceLabel.text = "$ \(String(format: "%.2f", Double(bagCount) * 0.10))"
        }
        else {
            bagsLabel.text = "Bags(0)"
            //bagPriceLabel.text = "$0.00"
        }

        
        
    }
    
    private func makeButtonDisabled(){
        cardDetailLabel.text = "No Payment Method"
        cardImage.image = UIImage(named: "imageWalletEmpty")
        changeButton.setTitle("Add", for: .normal)
        payButton.isUserInteractionEnabled = false
        payButton.alpha = 0.5
    }
    
    private func getAccountDetails(){
        let sharedInstance = UcheckoutSingleton.shared
        guard let guid = sharedInstance.userData?.guid else {
            fatalError()
        }
        checkoutViewModel.getAllAccounts(strUrl: UcheckoutManager.getUcommdevCompleteURl("/getallaccounts"), param: ["GUID":guid], parentViewController: self) { (status, accountModel, message) in
            DispatchQueue.main.async {
                if status {
                    if let acctModel = accountModel {
                        if let ack = acctModel.ack {
                            if ack == "0" {
                                self.accountModel = acctModel
                                self.populateUI()
                            }
                            else if ack == "1"{
                                if let errors = acctModel.errors {
                                    if errors.count > 0 {
                                        if let message = errors.first?.message {
                                            if message == StringConstants.NOAccountAvailable {
                                                self.accountModel = nil
                                                self.populateUI()
                                            }
                                            else {
                                                self.dismiss(animated: true, completion: {
                                                    SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: message , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                                                })
                                            }
                                        }
                                    }
                                    
                                }
                            }
                            
                            
                        }
                    }
                    else {
                        self.dismiss(animated: true, completion: {
                            SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: message ?? "" , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                        })
                    }
                }
            }
            
        }
    }
    
   
    
    
    
    
    
    // MARK: - Button Action Methods
    
    
    
    @IBAction func cardChangeAction(_ sender: Any)
    {
        FirebaseEventmanger.logEventWithName("cardChangeButtonPress_CheckoutPage", andCustomAttributes: ["build_number":UIDevice().appShortVersion,"page":"ConfirmPayViewController","event_day_of_week":UcheckoutManager.getDay()])
        
        let vc = SafewayWalletListRouter.createModule()
        self.present(vc, animated: true, completion: nil)
       
        
    }
    
    
    @IBAction func payButtonAction(_ sender: UIButton) {
        FirebaseEventmanger.logEventWithName("Paybutton_Pressed", andCustomAttributes: ["build_number":UIDevice().appShortVersion,"page":"ConfirmPayViewController","event_day_of_week":UcheckoutManager.getDay()])
        let viewController = PaymentLoadingPopupController(nibName: "PaymentLoadingPopupController", bundle: nil)
        viewController.accountModel = accountModel
        viewController.recieptModel = recieptModel
        viewController.checkoutModel = checkoutModel
        viewController.backViewColor = UIColor.black.withAlphaComponent(0.9)
        viewController.bagCount = bagCount

        self.present(viewController, animated: true, completion: nil)
       
    }
    
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        FirebaseEventmanger.logEventWithName("cancelButton_Pressed", andCustomAttributes: ["build_number":UIDevice().appShortVersion,"page":"ConfirmPayViewController","event_day_of_week":UcheckoutManager.getDay()])
        if let scanVC = UIStoryboard.checkout.instantiateViewController(withIdentifier: "CheckoutCamcelViewController") as? CheckoutCamcelViewController {
            scanVC.accountModel = accountModel
            scanVC.checkoutModel = checkoutModel
            scanVC.recieptModel = recieptModel
            scanVC.bagCount = bagCount
            
            if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                self.dismiss(animated: false) {
                    navigationController.pushViewController(scanVC, animated: true)

                }
                
            }
        }
    }
    
    @IBAction func crossButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)

    }
    
    private func clearCart(){
        checkoutViewModel.clearCart(strUrl: UcheckoutManager.getCompleteURl("/clearCart"), param: nil, header: nil, parentViewController: self) { (success, clearModel, message) in
            DispatchQueue.main.async {
                if success {
                    if let clearModel = clearModel {
                        if let ack = clearModel.ack , ack == "0" {
                            self.moveToHomeMenu()

                        }
                    }
                }
                else {
                    SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: message! , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                }
            }
        }
    }
    
    func moveToHomeMenu(){
        
        var isFound = false
        if let vcArray = self.navigationController?.viewControllers , vcArray.count != 0{
            for item in vcArray {
                if item.isKind(of: HomeViewController.self) {
                    isFound = true
                    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                        navigationController.popToViewController(item, animated: true)
                        
                    }
                }
            }
        }
        if !isFound {
            if let scanVC = UIStoryboard.home.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
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


