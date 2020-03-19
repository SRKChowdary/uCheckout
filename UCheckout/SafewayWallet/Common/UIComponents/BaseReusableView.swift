//
//  BaseReusableView.swift
//  UCheckout
//
//  Created by 1521398 on 04/09/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import Foundation
/// Class from UIView created for all views with a xib files that needs to load on storyboard
public protocol XibLoadable {
    var contentView: UIView? { get set }
    
    func xibSetup() -> UIView?
    func loadView() -> UIView?
}

public class BaseReusableView: UIView, XibLoadable {
    public var contentView: UIView?
    
    // MARK: Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        _ = xibSetup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        if xibSetup() == nil { return nil }
    }
    
    /**
     Configures the implementation of this class
     */
    public func xibSetup() -> UIView? {
        if let nibView = loadView() {
            // Use bounds not frame or it'll be offset
            nibView.frame = bounds
            
            // Make the view stretch with containing view
            nibView.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth,
                                        UIView.AutoresizingMask.flexibleHeight]
            
            // Adding custom subview on top of our view (over any custom drawing > see note below)
            addSubview(nibView)
            contentView = nibView
            
            return nibView
        } else {
            return nil
        }
    }
    
    /**
     Loads the xib file from the Bundle
     
     - Returns: The view loaded from the Bundle of this class
     */
    public func loadView() -> UIView? {
        let view = Bundle(for: type(of: self)).loadNibNamed(String(describing: type(of: self)),
                                                            owner: self,
                                                            options: nil)?[0] as? UIView
        return view
    }
    
}
