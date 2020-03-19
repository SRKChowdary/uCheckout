//
//  ABLabel.swift
//  ECommerce
//
//  Created by Jonathan Gascoigne on 4/11/19.
//  Copyright © 2019 Albertsons. All rights reserved.
//

import Foundation

public class ABLabel: ABField {
    var label = UILabel()
        
    public convenience init(withTitle title:String, text:String)
    {
        self.init(withTitle: title, placeholder: nil)
        self.text = text
    }
    
    override func buildHierarchy() {
        addSubview(borderView)
        borderView.addSubview(label)
        addSubview(imageLabel)
    }
    
    override func setPlaceholder() { }
    
    override func setup() {
        super.setup()
        textField = nil
    }
    
    override func buildStyle() {
        super.buildStyle()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = textField.tintColor
        label.textColor = textField.textColor
        label.font = textField.font
        borderView.layer.borderWidth = 0
    }
    
    /** The current text that is displayed by the label.
 
    This property is nil by default.
     
    Assigning a new value to this property also replaces the value of the attributedText property with the same text, although without any inherent style attributes. Instead the label styles the new string using shadowColor, textAlignment, and other style-related properties of the class.*/
    override public var text: String? {
        get {
            return label.text
        }
        set {
            label.text = newValue
        }
    }
    
    /** The current styled text that is displayed by the label.
     
    This property is nil by default.
     
    Assigning a new value to this property also replaces the value of the text property with the same string data, although without any formatting information. In addition, assigning a new a value updates the values in the font, textColor, and other style-related properties so that they reflect the style information starting at location 0 in the attributed string.
     
    To turn on auto-kerning on the label, set `kern` of the string to null. */
    override public var attributedText: NSAttributedString? {
        get {
            return label.attributedText
        }
        set {
            label.attributedText = newValue
        }
    }
    /** The maximum number of lines to use for rendering text.
     
    This property controls the maximum number of lines to use in order to fit the label’s text into its bounding rectangle. The default value for this property is 1. To remove any maximum limit, and use as many lines as needed, set the value of this property to 0.*/
    public var numberOfLines:Int {
        get {
            return label.numberOfLines
        }
        set {
            label.numberOfLines = newValue
        }
    }
    
    /// A succinct label that identifies the accessibility element of the label, in a localized string.
    override open var accessibilityLabel:String? {
        get {
            return label.accessibilityLabel
        }
        set {
            label.accessibilityLabel = newValue
        }
    }
    
    /// A brief description of the result of performing an action on the accessibility element (label), in a localized string.
    override open var accessibilityHint:String? {
        get {
            return label.accessibilityHint
        }
        set {
            label.accessibilityHint = newValue
        }
    }
    
    override func layoutBorderConstraints()  {
        borderView.snp.remakeConstraints { make in
            if topLabel == nil { make.top.equalToSuperview() }
            make.left.equalToSuperview()
            make.right.equalTo(sideButton?.snp.left ?? snp.right)
            if errorLabel.superview == nil { make.bottom.equalToSuperview() }
        }
    }
    
    override func layoutTextFieldConstraints() {
        label.snp.remakeConstraints { make in
            make.left.equalTo(borderView).offset(5)
            make.right.equalTo(imageLabel.snp.left).offset(-8)
            make.top.equalTo(borderView)
            make.bottom.equalTo(borderView)
        }
    }
    
    override func layoutImageLabelConstraints() {
        imageLabel.snp.remakeConstraints { make in
            make.left.equalTo(label.snp.right).offset(-8)
            make.right.equalTo(extraButton?.snp.left ?? borderView.snp.right).offset(-8)
            make.width.equalTo(imageLabel.isHidden ? 0 : 20)
            make.height.equalTo(20)
            make.top.equalTo(borderView).offset(8)
        }
    }
    
    override func changeTint() { } 
    
    @discardableResult override public func becomeFirstResponder() -> Bool { return false }
    @discardableResult override public func resignFirstResponder() -> Bool { return false }
    override public var isFirstResponder: Bool { return false }
}
