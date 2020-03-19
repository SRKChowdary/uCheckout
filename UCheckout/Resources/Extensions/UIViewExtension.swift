//
//  UIViewExtension.swift
//  UCheckout
//
//  Created by i2i Innovation on 2/11/20.
//  Copyright © 2020 Pranav. All rights reserved.
//

import Foundation

extension UIView {

    func dropShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 2, height: 3)
        self.layer.shadowRadius = 3
        //self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale

    }
}

// offset Shadow
//extension UIView{
//    func dropShadow() {
//self.layer.cornerRadius = 8
//self.layer.shadowColor = UIColor.darkGray.cgColor
//self.layer.shadowOpacity = 1
//self.layer.shadowOffset = .zero
//self.layer.shadowRadius = 5
//    }
//}

//Rounded Shadow
//extension UIView {
//
//    func dropShadow() {
//
//        var shadowLayer: CAShapeLayer!
//        let cornerRadius: CGFloat = 16.0
//        let fillColor: UIColor = .white
//
//        if shadowLayer == nil {
//            shadowLayer = CAShapeLayer()
//
//            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
//            shadowLayer.fillColor = fillColor.cgColor
//
//            shadowLayer.shadowColor = UIColor.black.cgColor
//            shadowLayer.shadowPath = shadowLayer.path
//            shadowLayer.shadowOffset = CGSize(width: -2.0, height: 2.0)
//            shadowLayer.shadowOpacity = 0.8
//            shadowLayer.shadowRadius = 2
//
//            layer.insertSublayer(shadowLayer, at: 0)
//        }
//    }
//}



//extension UIView {
//    func dropShadow() {
//        self.layer.cornerRadius = 25.0
//        self.clipsToBounds = true
//        self.layer.cornerRadius = 8
//        self.layer.shadowColor = UIColor.darkGray.cgColor
//        self.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
//        self.layer.shadowRadius = 25.0
//        self.layer.shadowOpacity = 0.2
//    }
//}
