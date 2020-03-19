//
//  CheckoutCamcelViewController.swift
//  UCheckout
//
//  Created by i2i innovation on 14/10/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class CheckoutCamcelViewController: UIViewController {
    
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var payAtLaneButton: UIButton!
    
    @IBOutlet weak var cancelButton: UIButton!
    
    var checkoutViewModel = CheckoutViewModel()
    var accountModel : AccountModels?
    var checkoutModel : CheckoutModel?
    var recieptModel : RecieptModel?
    var bagCount : Int?
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Bug FIX : Need to hide Pay at Lane button for now : 
        payAtLaneButton.isEnabled =  false
        payAtLaneButton.isHidden = true
//        payAtLaneButton.backgroundColor = UIColor.gray
//        payAtLaneButton.tintColor = UIColor.gray
        

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
    
    
    @IBAction func payAtLaneButtonAction(_ sender: UIButton) {
        
//        if let scanVC = UIStoryboard.checkout.instantiateViewController(withIdentifier: "PayAtLaneViewController") as? PayAtLaneViewController {
//            scanVC.recieptModel = recieptModel
//            if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
//                navigationController.pushViewController(scanVC, animated: true)
//
//            }
//        }

    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        clearCart()
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        let viewController = ConfirmPayViewController(nibName: "ConfirmPayViewController", bundle: nil)
        viewController.accountModel = self.accountModel
        viewController.recieptModel = self.recieptModel
        viewController.checkoutModel = self.checkoutModel
        viewController.bagCount = bagCount ?? 0
        viewController.showAnimation = ActionSheetShowAnimation()
        viewController.dismissAnimation = ActionSheetDismissAnimation()
        // Pranav Bug Fix
        viewController.backViewColor = UIColor.black.withAlphaComponent(0.5)
        
        viewController.show()
    }
    
    private func clearCart(){
        checkoutViewModel.clearCart(strUrl: UcheckoutManager.getCompleteURl("/clearCart"), param: nil, header: nil, parentViewController: self) { (success, clearModel, message) in
            DispatchQueue.main.async {
                if success {
                    if let clearModel = clearModel {
                        if let ack = clearModel.ack , ack == "0" {
                            if let scanVC = UIStoryboard.checkout.instantiateViewController(withIdentifier: "CheckoutCancelDoneViewController") as? CheckoutCancelDoneViewController {
                                if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                                    navigationController.pushViewController(scanVC, animated: true)
                                    
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
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
