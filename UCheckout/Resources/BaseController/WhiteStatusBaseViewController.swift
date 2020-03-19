//
//  WhiteStatusBaseViewController.swift
//  UCheckout
//
//  Created by i2i innovations on 23/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class WhiteStatusBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         UIApplication.shared.statusBarView?.backgroundColor = UIColor.white
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
