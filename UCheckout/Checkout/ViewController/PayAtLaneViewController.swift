//
//  PayAtLaneViewController.swift
//  UCheckout
//
//  Created by Nilesh Jha on 15/10/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class PayAtLaneViewController: UIViewController {

    @IBOutlet weak var barCodeImageView: UIImageView!
    @IBOutlet weak var barCodeLabel: UILabel!
    
    
    var checkoutViewModel = CheckoutViewModel()
    var recieptModel : RecieptModel?


    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

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
    
    private func updateUI(){
        if let retrieveBarcodeValue = recieptModel?.data?.retrieveBarcodeValue {
            barCodeLabel.text = retrieveBarcodeValue
            barCodeImageView.image = UIImage.generateBarcode(from: retrieveBarcodeValue)
        }
    }
    
    @IBAction func cancelOrderButtonAction(_ sender: UIButton) {
        clearCart()
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
