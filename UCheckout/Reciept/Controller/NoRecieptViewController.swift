//
//  NoRecieptViewController.swift
//  UCheckout
//
//  Created by i2i innovation on 05/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class NoRecieptViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func shopNowButtonAction(_ sender: UIButton)
    {
        if let scanVC = UIStoryboard.home.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
            if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                navigationController.pushViewController(scanVC, animated: true)
                
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
