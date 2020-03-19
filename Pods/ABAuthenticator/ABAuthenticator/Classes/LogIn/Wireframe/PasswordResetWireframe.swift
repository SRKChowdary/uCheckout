//
//  PasswordResetWireframe.swift
//  SafewayDelivery
//
//  Created by Bindu Suma J on 01/10/19.
//  Copyright © 2019 Albertsons. All rights reserved.
//

import Foundation
class PasswordResetWireframe
{
    class func assembleModule() -> PasswordResetSentViewController? {
        
    let view = PasswordResetSentViewController()
        view.navigationItem.title = "Password Reset Sent"
        return view
    }
}
