//
//  ApplePayDetectedViewController.swift
//  UCheckout
//
//  Created by i2i Innovation on 2/10/20.
//  Copyright © 2020 Pranav. All rights reserved.
//

import UIKit

class ApplePayDetectedViewController: UIViewController {
    
    
    // Outlets :
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // IB Actions :
    
    
    @IBAction func DoneApplePayAddedButton(_ sender: UIButton) {
        if let homeVC = UIStoryboard.home.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            self.navigationController?.pushViewController(homeVC, animated: true)
        }
    }
    
    @IBAction func closeApplePayAddedScreen(_ sender: UIButton) {

        dismiss(animated: true, completion: nil)
    }
    
    
}
