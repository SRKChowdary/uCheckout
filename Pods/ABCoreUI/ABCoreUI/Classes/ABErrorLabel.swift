//
//  ABErrorLabel.swift
//  ECommerce
//
//  Created by Ganesh Reddiar on 4/25/16.
//  Copyright © 2016 Albertsons. All rights reserved.
//



import UIKit

@IBDesignable class ABErrorLabel:UILabel {
    
    @IBInspectable var containsLink:Bool = false
    @IBInspectable var linkFontColor:UIColor = #colorLiteral(red: 0, green: 0.47843137254902, blue: 1, alpha: 1)
    @IBInspectable var standardFontColor:UIColor = #colorLiteral(red: 0.8666666667, green: 0.1176470588, blue: 0.1450980392, alpha: 1)
    var isError = false
    var linkAction:()->() = {}
    var type:ABFieldType = .any
    
    override var text:String? {
        didSet {
            self.setUp()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUp()
    }
    
    
    
    func setUp() {
      
        self.numberOfLines = 0
        if var text = self.text {
            
            let standardAttributes = [.foregroundColor: standardFontColor] as [NSAttributedString.Key:Any]
            var attributedString  = NSMutableAttributedString(string: text , attributes: standardAttributes)
            
            if containsLink {
                
                setTapGesture()
                
                if let startLinkElementIndex = text.range(of: "<li>")?.lowerBound {
                    
                    let linkTextStartIndex = text.index(startLinkElementIndex, offsetBy: 4)
                    text.removeSubrange(startLinkElementIndex..<linkTextStartIndex)
                    
                    
                    if let endLinkElementIndex = text.range(of: "</li>")?.lowerBound {
                        
                        let linkTextEndIndex = text.index(endLinkElementIndex, offsetBy: 5)
                        text.removeSubrange(endLinkElementIndex..<linkTextEndIndex)
                        
                        let linkText = text[startLinkElementIndex..<endLinkElementIndex]
                        let linkAttributes = [.foregroundColor: linkFontColor] as [NSAttributedString.Key:Any]
                        
                        attributedString  = NSMutableAttributedString (string: text , attributes: standardAttributes)
                        let startLocation = text.distance(from: text.startIndex, to: startLinkElementIndex)
                        attributedString.addAttributes(linkAttributes, range: NSRange(location: startLocation, length: linkText.count))
                        self.attributedText = attributedString
                    }
                }
            }
            
            if let _ = self.text {
                switch type {
                /*case .phone, .email:
                    removeTapGesture()
                    let range1 = (text as NSString).range(of: SupportPhoneNumbers.loyalty)
                    attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: range1)
                    if (range1.length > 0) {
                        setTapGesture()
                        linkAction = {
                            let phoneNumber = "tel://\(SupportPhoneNumbers.loyalty)"
                            if let url = URL(string: phoneNumber) {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                    let range2 = (text as NSString).range(of: "Sign In")
                    attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: range2)
                    let range3 = (text as NSString).range(of: SupportPhoneNumbers.shop)
                    attributedString.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.styleSingle.rawValue, range: range3)
                    if (range3.length > 0) {
                        setTapGesture()
                        linkAction = {
                            let phoneNumber = "tel://\(SupportPhoneNumbers.shop)"
                            if let url = URL(string: phoneNumber) {
                                UIApplication.shared.open(url)
                            }
                        }
                    }*/
                default:
                    break
                }
                self.attributedText = attributedString
            }
        }
    }
    
    func setTapGesture() {
        if self.gestureRecognizers?.count ?? 0 == 0 {
            self.isUserInteractionEnabled = true
            let gesture = UITapGestureRecognizer(target: self, action: #selector(ABErrorLabel.tapAction(_:)))
            gesture.numberOfTapsRequired = 1
            self.addGestureRecognizer(gesture)
        }
    }
    
    func removeTapGesture() {
        gestureRecognizers?.removeAll()
    }
    
    func configureAccessibility() {
        
        self.isAccessibilityElement = true
        self.accessibilityLabel = self.text
    }
    
    @objc func tapAction(_ sender: UITapGestureRecognizer) {
        linkAction()
    }
    
}


//TODO: Refactor this
@IBDesignable class ALBAttributedLabel:UILabel {
    
    @IBInspectable var containsLink:Bool = false
    @IBInspectable var containsBold:Bool = false

    var linkAttributes:[NSAttributedString.Key:Any]?
    var standardAttributes:[NSAttributedString.Key:Any]?
    var boldAttributes:[NSAttributedString.Key:Any]?
    
    var linkAction:()->() = {}
    
    override var text:String? {
        didSet {
            self.setUp()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUp()
    }
    
    
    
    func setUp() {
        
        self.numberOfLines = 0
        if var text = self.text {
            
            
            var attributedString = NSMutableAttributedString (string: text)
            
            if let safeAttributes = standardAttributes {
                attributedString  = NSMutableAttributedString (string: text , attributes: safeAttributes)
            }
            
            if containsLink, let safeAttributes = linkAttributes {
                
                self.isUserInteractionEnabled = true
                
                let gesture = UITapGestureRecognizer(target: self, action: #selector(ABErrorLabel.tapAction(_:)))
                gesture.numberOfTapsRequired = 1
                self.addGestureRecognizer(gesture)
                
                if let startLinkElementIndex = text.range(of: "<li>")?.lowerBound {
                    
                    let linkTextStartIndex = text.index(startLinkElementIndex, offsetBy: 4)
                    text.removeSubrange(startLinkElementIndex..<linkTextStartIndex)
                    
                    
                    if let endLinkElementIndex = text.range(of: "</li>")?.lowerBound {
                        
                        let linkTextEndIndex = text.index(endLinkElementIndex, offsetBy: 5)
                        text.removeSubrange(endLinkElementIndex..<linkTextEndIndex)
                        
                        let linkText = text[startLinkElementIndex..<endLinkElementIndex]
                        
                        attributedString  = NSMutableAttributedString (string: text , attributes: standardAttributes)
                        let startLocation = text.distance(from: text.startIndex, to: startLinkElementIndex)
                        attributedString.addAttributes(safeAttributes, range: NSRange(location: startLocation, length: linkText.count))
                        self.attributedText = attributedString
                    }
                }
            }
            
            if containsBold, let safeAttributes = boldAttributes  {
                
                self.isUserInteractionEnabled = true
                
                let gesture = UITapGestureRecognizer(target: self, action: #selector(ABErrorLabel.tapAction(_:)))
                gesture.numberOfTapsRequired = 1
                self.addGestureRecognizer(gesture)
                
                if let startLinkElementIndex = text.range(of: "<bd>")?.lowerBound {
                    
                    let linkTextStartIndex = text.index(startLinkElementIndex, offsetBy: 4)
                    text.removeSubrange(startLinkElementIndex..<linkTextStartIndex)
                    
                    
                    if let endLinkElementIndex = text.range(of: "</bd>")?.lowerBound {
                        
                        let linkTextEndIndex = text.index(endLinkElementIndex, offsetBy: 5)
                        text.removeSubrange(endLinkElementIndex..<linkTextEndIndex)
                        
                        let linkText = text[startLinkElementIndex..<endLinkElementIndex]
                        
                        attributedString  = NSMutableAttributedString (string: text , attributes: standardAttributes)
                        let startLocation = text.distance(from: text.startIndex, to: startLinkElementIndex)
                        attributedString.addAttributes(safeAttributes, range: NSRange(location: startLocation, length: linkText.count))
                        self.attributedText = attributedString
                    }
                }
            }

        }
    }
    
    func configureAccessibility() {
        
        self.isAccessibilityElement = true
        self.accessibilityLabel = self.text
    }
    
    func tapAction(_ sender: UITapGestureRecognizer) {
        linkAction()
    }
    
}
