//
//  CircularLabel.swift
//  UCheckout
//
//  Created by i2i innovation on 09/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation

@IBDesignable class CircularLabel: UILabel {
    
    @IBInspectable var cornerRadius: CGFloat = 20 {
        didSet {
            refreshCorners(value: cornerRadius)
             self.clipsToBounds = true
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func sharedInit() {
        refreshCorners(value: cornerRadius)
         self.clipsToBounds = true
    }
    
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
         self.clipsToBounds = true
       
    }
}
