//
//  CustomCartHeaderView.swift
//  UCheckout
//
//  Created by i2i innovation on 09/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

@IBDesignable class CustomCartHeaderView: UIView {
    

    @IBOutlet weak var cartCountLabel: CircularLabel!
    class func instantiateFromNib() -> CustomCartHeaderView {
        let nib = UINib(nibName: "CustomCartHeaderView", bundle: nil)
        let nibObjects = nib.instantiate(withOwner: nil, options: nil)
        let customTitleView = nibObjects.first as! CustomCartHeaderView
        return customTitleView
    }
    
}
