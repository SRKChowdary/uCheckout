//
//  CheckoutLoadingViewController.swift
//  UCheckout
//
//  Created by i2i innovation on 19/08/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit
import SwiftPopup

class CheckoutLoadingViewController: SwiftPopup {
    
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var actIndView: UIActivityIndicatorView!
    
    
    var checkoutViewModel = CheckoutViewModel()
    var accountModel : AccountModels?
    var checkoutModel : CheckoutModel?
    var recieptModel : RecieptModel?
    var bagItemCount : Int?
    var recieptCallstartTime : Date?
    var orderID : String?

    override func viewDidLoad() {
        super.viewDidLoad()
        getAccountDetails()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.isHidden = true
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarView?.isHidden = false
        
    }
    
    private func getAccountDetails(){
        actIndView.startAnimating()
        self.actIndView.transform = CGAffineTransform(scaleX: 2, y: 2)

        messageLabel.text = "We’re processing your order."
        let sharedInstance = UcheckoutSingleton.shared
        guard let guid = sharedInstance.userData?.guid else {
            fatalError()
        }
        // UcheckoutManager.getCompleteURl
        // checkoutManager.getUcommdevCompleteURl
        checkoutViewModel.getAllAccounts(strUrl: UcheckoutManager.getUcommdevCompleteURl("/getallaccounts"), param: ["GUID":guid], parentViewController: self) { (status, accountModel, message) in
            DispatchQueue.main.async {
                 self.actIndView.stopAnimating()
                if status {
                    if let acctModel = accountModel {
                        if let ack = acctModel.ack {
                            if ack == "0" {
                                self.accountModel = acctModel
                                self.checkOutCartDetail()
                            }
                            else if ack == "1"{
                                if let errors = acctModel.errors {
                                    if errors.count > 0 {
                                        if let message = errors.first?.message {
                                            if message == StringConstants.NOAccountAvailable {
                                                self.checkOutCartDetail()
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
    
    private func checkOutCartDetail(){
         messageLabel.text = "Just a few more seconds…"
        actIndView.startAnimating()
        self.actIndView.transform = CGAffineTransform(scaleX: 2, y: 2)
        checkoutViewModel.checkOutCart(strUrl: UcheckoutManager.getCompleteURl("/checkOutCart"), header: checkoutCartModelDict(), parentViewController: self) { (status, checkoutModel, message) in
            DispatchQueue.main.async {
                self.actIndView.stopAnimating()
                if status {
                    if let checkoutModl = checkoutModel {
                        if let ack = checkoutModl.ack {
                            if ack == "0" {
                                self.checkoutModel = checkoutModl
                                if let message = self.checkoutModel?.message , message == "Checkout Success." {
                                    if let orderID = self.checkoutModel?.data?.orderID {
                                        self.recieptCallstartTime = Date()
                                        self.orderID = orderID
                                        self.getReceipt(orderID)
                                        
                                    }
                                }
                            }
                            else if ack == "1"{
                                if let errors = checkoutModl.errors {
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
                }
                else {
                    self.dismiss(animated: true, completion: {
                        SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: message ?? "" , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                    })
                }
            }
        }
        
    }
    
    private func getReceipt(_ orderID : String){
         messageLabel.text = "Thank you again for choosing us."
        actIndView.startAnimating()
        self.actIndView.transform = CGAffineTransform(scaleX: 2, y: 2)
        let sharedInstance = UcheckoutSingleton.shared
        guard let storeId = sharedInstance.getprofileModelData?.stores?.storeID else {
            return
        }
       
        guard let guid = sharedInstance.userData?.guid  else {
            fatalError()
        }
        var headers: [String:String] = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        headers["StoreID"] = storeId
        headers["GUID"] = guid
        headers["Ocp-Apim-Subscription-key"] = ConfigurationManager.manager.ocpSubscriptionkey
        // UcheckoutManager.getScanAndGoDevJSCompleteURl
        // UcheckoutManager.getCompleteURl
        checkoutViewModel.getReceipt(strUrl: "\(UcheckoutManager.getCompleteURl("/getReceipt"))?orderId=\(orderID)", header: headers, parentViewController: self) { (status, recieptModel, message) in
            DispatchQueue.main.async {
                 self.actIndView.stopAnimating()
                if status {
                    if let recieptModl = recieptModel {
                        if let ack = recieptModl.ack {
                            if ack == "0" {
                                self.recieptCallstartTime = nil
                                self.orderID = nil
                                self.recieptModel = recieptModl
                                self.dismiss(animated: true, completion: {
                                    self.gotoCheckOutPage()
                                })
                               
                               
                            }
                            else if ack == "1"{
                                if let recieptCallstartTime = self.recieptCallstartTime {
                                    let calendar = Calendar.current
                                    let unitFlags = Set<Calendar.Component>([ .second])
                                    let datecomponenets = calendar.dateComponents(unitFlags, from: recieptCallstartTime, to: Date())
                                    if let seconds = datecomponenets.second {
                                        if seconds <= 30 {
                                            self.actIndView.startAnimating()
                                            self.actIndView.transform = CGAffineTransform(scaleX: 2, y: 2)
                                            _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.runTimedCode), userInfo: nil, repeats: false)
                                            return
                                            
                                            
                                        }
                                    }
                                }
                               
                                if let errors = recieptModl.errors {
                                    self.recieptCallstartTime = nil
                                    self.orderID = nil
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
    
    @objc private func runTimedCode() {
        if let orderID = orderID {
            self.getReceipt(orderID)
        }
    }
    
    private func gotoCheckOutPage(){
        let viewController = ConfirmPayViewController(nibName: "ConfirmPayViewController", bundle: nil)
        viewController.accountModel = self.accountModel
        viewController.recieptModel = self.recieptModel
        viewController.checkoutModel = self.checkoutModel
        viewController.bagCount = self.bagItemCount
        viewController.showAnimation = ActionSheetShowAnimation()
        viewController.dismissAnimation = ActionSheetDismissAnimation()
        // Pranav Bug Fix
        viewController.backViewColor = UIColor.black.withAlphaComponent(0.5)
        
        viewController.show()
    }
    
    private func checkoutCartModelDict()-> [String:String] {
        let sharedInstance = UcheckoutSingleton.shared
        guard let storeId = sharedInstance.getprofileModelData?.stores?.storeID else {
            fatalError()
        }
        guard let guid = sharedInstance.userData?.guid  else {
            fatalError()
        }
        guard let coremaClubCard = sharedInstance.userData?.coremaClubCard  else {
            fatalError()
        }
         var paramDict = [String:String]()
         paramDict["guid"] = guid
         paramDict["platform"] = AppConstants.Platform
         paramDict["version"] = "1.0"
         paramDict["Clubcard_nbr"] = coremaClubCard
         paramDict["storeid"] = storeId
        paramDict["Ocp-Apim-Subscription-Key"] = ConfigurationManager.manager.ocpSubscriptionkey
        return paramDict
        
        
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
