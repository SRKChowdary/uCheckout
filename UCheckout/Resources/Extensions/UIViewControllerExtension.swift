//
//  UIViewControllerExtension.swift
//  UCheckout
//
//  Created by i2i innovation on 03/10/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation

extension UIViewController {
    static func loadFromNib() -> Self {
        func instantiateFromNib<T: UIViewController>() -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }
        
        return instantiateFromNib()
    }
}
