//
//  CircularButton.swift
//  UCheckout
//
//  Created by i2i Innovation on 19/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation

@IBDesignable class RoundButton: UIButton {
    
    
    @IBInspectable var cornerRadius: CGFloat = 44 {
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
        // Common logic goes here
        self.layer.cornerRadius = 44
        self.clipsToBounds = true
        //self.layer.borderColor = UIColor.init(red: 228/255.0, green: 23/255.0, blue: 32/255.0, alpha: 1).cgColor
        //self.layer.borderWidth = 2
    }
    
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
        self.clipsToBounds = true
        
    }
}
