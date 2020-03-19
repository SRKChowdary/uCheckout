//
//  HomeViewController.swift
//  UCheckout
//
//  Created by i2i innovation on 11/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD


class MBProgressIndicator: NSObject {
    class func showIndicator(_ view : UIView){
        let loadingNotification = MBProgressHUD.showAdded(to: view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = "Loading"
    }
    
    class func hideIndicator(_ view : UIView){
        MBProgressHUD.hide(for: view, animated: true)
        
    }
}
