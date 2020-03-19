//
//  stackViewExtension.swift
//  UCheckout
//
//  Created by i2i Innovation on 2/11/20.
//  Copyright © 2020 Pranav. All rights reserved.
//

import Foundation


extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        subView.layer.cornerRadius = 8
        insertSubview(subView, at: 0)
    }
}
