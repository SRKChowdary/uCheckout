//
//  CustomNavigationBarView.swift
//  UCheckout
//
//  Created by i2i Innovation on 25/08/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

protocol CustomNavBarProtocol {
    func centerButtonClicked()
    func menuButtonClicked()
}

class CustomNavigationBarView: UIView {
    
    @IBOutlet var containerView: UIView!
    
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var centerButton: UIButton!
    
    @IBOutlet weak var cartCountLabel: CircularLabel!
    
    @IBOutlet weak var deleteButtton: UIButton!
    
    
    // Added this to turn off the tapping on cart when user is out of store, Now its letting the user go to cart page --> Scan, when user is out of store,
    @IBOutlet weak var centerButtonImageView: UIImageView!
    
    
     var customNavBarProtocolDelegate : CustomNavBarProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commitInit()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commitInit()
    }
    
    private func commitInit(){
        Bundle.main.loadNibNamed("CustomNavigationBarView", owner: self, options: nil)
        addSubview(containerView)
        containerView.frame = self.bounds
        containerView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBAction func centerButtonAction(_ sender: UIButton) {
        customNavBarProtocolDelegate.centerButtonClicked()
    }
    
    @IBAction func menuButtonAction(_ sender: UIButton) {
        customNavBarProtocolDelegate.menuButtonClicked()
    }
    
    func setCenterButton(enabled: Bool) {
        
        centerButtonImageView.image = UIImage(named: enabled ? "icMenuCartWhite" : "icMenuCartWhite")
        centerButton.isUserInteractionEnabled = enabled
        cartCountLabel.backgroundColor = enabled ? .white : .white
    
    }
    

}
