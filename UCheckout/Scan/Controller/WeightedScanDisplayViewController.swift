//
//  WeightedScanDisplayViewController.swift
//  UCheckout
//
//  Created by i2i Innovation on 28/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class WeightedScanDisplayViewController: UIViewController {
    
    // MARK: - IB Outlet Connection
    
    @IBOutlet weak var viewTitleLable: UILabel!
    
    
    
    // MARK: - Variables
    var isFromPLUScreen : Bool?
    var pluCode : String?
    var itemName : String?
    var isFromScanPage : Bool?
    
    @IBOutlet weak var pluCodeLabel: UILabel!
    
    
    // MARK: - View Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func updateUI(){
        if let isFromPLUScren = isFromPLUScreen , isFromPLUScren {
             pluCodeLabel.isHidden = false
            pluCodeLabel.text = "PLU: \(pluCode ?? "")"
            viewTitleLable.text = itemName ?? ""
        }
        else {
            pluCodeLabel.isHidden = true
             viewTitleLable.text = "Scale Item"
        }
    }
    
    
    
      // MARK: - IB Action Methods
    
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func scanBarCodeAction(_ sender: UIButton) {
        if let isFromPLUScren = isFromPLUScreen , isFromPLUScren {
            var isFound = false
            if let vcArray = self.navigationController?.viewControllers , vcArray.count != 0{
                for item in vcArray {
                    if item.isKind(of: ScannerBaseViewController.self) {
                        isFound = true
                        self.navigationController?.popToViewController(item, animated: true)
                    }
                }
            }
            if !isFound {
                if let scanVC = UIStoryboard.scan.instantiateViewController(withIdentifier: "ScannerBaseViewController") as? ScannerBaseViewController {
                    self.navigationController?.pushViewController(scanVC, animated: true)
                }
            }
        }
        else {
            self.navigationController?.popViewController(animated: true)

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
