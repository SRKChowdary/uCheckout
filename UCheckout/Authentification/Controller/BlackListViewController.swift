//
//  BlackListViewController.swift
//  UCheckout
//
//  Created by i2i Innovation on 11/21/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class BlackListViewController: UIViewController {
    
    
    // MARK:-
    // IB Outlets
    
    
    @IBOutlet weak var BlackListUserTextView: UITextView!
    


    override func viewDidLoad()
    {
        super.viewDidLoad()

       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
        
    }
    
    
    // IB Actions :-
    
    @IBAction func closeButtonAction(_ sender: UIButton)
    {
        
        if let scanVC = UIStoryboard.authentification.instantiateViewController(withIdentifier: "LoginSDKViewController") as? LoginSDKViewController {
            let navController = UINavigationController(rootViewController: scanVC)
            UIApplication.shared.keyWindow?.rootViewController = navController
            
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
