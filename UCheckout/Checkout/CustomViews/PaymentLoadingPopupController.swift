//
//  PaymentLoadingPopupController.swift
//  UCheckout
//
//  Created by i2i innovations on 19/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit
import SwiftPopup

class PaymentLoadingPopupController: SwiftPopup {
    
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    
    @IBOutlet weak var actIndView: UIActivityIndicatorView!
    
    var accountModel : AccountModels?
    var checkoutModel : CheckoutModel?
    var recieptModel : RecieptModel?
    
    var bagCount : Int?
    var checkoutViewModel = CheckoutViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
       

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
         makeSellTransaction()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.isHidden = true
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarView?.isHidden = false
        
    }
    
    
    private func makeSellTransaction(){
        messageLabel.text = "Talking to the cloud…"
        actIndView.startAnimating()
        self.actIndView.transform = CGAffineTransform(scaleX: 2, y: 2)
        checkoutViewModel.salesTransaction(strUrl: UcheckoutManager.getUcommdevCompleteURl("/salestransaction"), param: getPaymentDict(), header: nil, parentViewController: self) { (success, response, message) in
            
            DispatchQueue.main.async {
                 self.actIndView.stopAnimating()
                if success {
                    if let response = response {
                        if let ack = response.ack {
                            if ack == "0" {
                                print("Success")
                                if let orderID = self.checkoutModel?.data?.orderID {
                                    self.getReceipt(orderID)
                                }
                                
                                
                            }
                            else if ack == "1"{
                                if let errors = response.errors {
                                    if errors.count > 0 {
                                        if let message = errors.first?.message {
                                            self.dismiss(animated: true, completion: {
                                               SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: message , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                                            })
                                           
                                        }
                                    }
                                    
                                }
                            }
                        }
                        else {
                        }
                    }
                }
                else {
                    self.dismiss(animated: true, completion: {
                        SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: message! , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                    })
                   
                }
            }
            
        }
    }
    
    private func getReceipt(_ orderID : String){
         messageLabel.text = "Sending the receipt to you…"
        actIndView.startAnimating()
        self.actIndView.transform = CGAffineTransform(scaleX: 2, y: 2)
        let sharedInstance = UcheckoutSingleton.shared
        guard let storeId = sharedInstance.getprofileModelData?.stores?.storeID else {
            return
        }
        var headers: [String:String] = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        headers["StoreID"] = storeId
        guard let guid = sharedInstance.userData?.guid else {
            fatalError()
        }
        headers["GUID"] = guid
        headers["Ocp-Apim-Subscription-key"] = ConfigurationManager.manager.ocpSubscriptionkey
        checkoutViewModel.getReceipt(strUrl: "\(UcheckoutManager.getCompleteURl("/getReceipt"))?orderId=\(orderID)", header: headers, parentViewController: self) { (status, recieptModel, message) in
            DispatchQueue.main.async {
                  self.actIndView.stopAnimating()
                if status {
                    if let recieptModl = recieptModel {
                        if let ack = recieptModl.ack {
                            if ack == "0" {
                                self.recieptModel = recieptModl
                                self.dismiss(animated: true, completion: {
                                    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                                        //Do something
                                        
                                        if let recieptVC = UIStoryboard.reciept.instantiateViewController(withIdentifier: "MiniRecieptViewController") as? MiniRecieptViewController {
                                            recieptVC.reciptData = self.recieptModel?.data
                                            recieptVC.bagCount = self.bagCount
                                            navigationController.pushViewController(recieptVC, animated: true)
                                        }
                                    }
                                })
                                
                                
                            }
                            else if ack == "1"{
                                if let errors = recieptModl.errors {
                                    if errors.count > 0 {
                                        if let message = errors.first?.message {
                                            self.dismiss(animated: true, completion: {
                                                SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: message , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                                            })
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
                else {
                    self.dismiss(animated: true, completion: {
                        SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: message ?? "" , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                    })
                    
                }
                
            }
        }
        
    }
    
    private func getPaymentDict () -> [String:String] {
        let sharedInstance = UcheckoutSingleton.shared
        guard let storeId = sharedInstance.getprofileModelData?.stores?.storeID else {
            fatalError()
        }
        var paymentDict = [String:String]()
        
        guard let guid = sharedInstance.userData?.guid else {
            fatalError()
        }
        
        paymentDict["GUID"] = guid
        paymentDict["paymentSource"] = "vaulted_account"
        if let aactModel = accountModel{
            if let fdTokenId = aactModel.defaultCard {
                paymentDict["fdAccountId"] = fdTokenId
            }
            
            if let cardDetailArray = aactModel.accounts {
                if let defaultCard = cardDetailArray.first(where: {$0.fdAccountID == aactModel.defaultCard}) {
                    if let cardType = defaultCard.credit?.cardType {
                        if let tokenID = defaultCard.token?.tokenID {
                            paymentDict["fdToken"] = tokenID
                        }
                        paymentDict["cardType"] = cardType
                        
                    }
                }
            }
        }
        // not required : comes from backend directly,
        //paymentDict["merchantId"] = "567v67890"
        paymentDict["storeId"] = storeId
        paymentDict["transactionSource"] = "SNG"
        //10/05 1:57 PM
        if let date  = Date().toString(format: "MM/dd hh:mm a") {
            paymentDict["transactionDate"] = date
        }
        
        
        if let recieptModel = recieptModel {
            
            if let total = recieptModel.data?.receiptJSON?.receiptTotalResult?.total {
                paymentDict["transactionAmount"] = "\(total)"
            }
            
        }
        
        if let checkotModel = checkoutModel {
            if let orderId = checkotModel.data?.orderID {
                paymentDict["orderId"] = orderId
            }
        }
        
        
        return paymentDict
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
