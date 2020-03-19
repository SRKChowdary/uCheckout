//
//  RedStatusBaseViewController.swift
//  UCheckout
//
//  Created by i2i Innovation on 11/11/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class RedStatusBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.red
        navigationController?.navigationBar.barStyle = .default
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
