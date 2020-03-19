//
//  ABTextView.swift
//  ECommerce
//
//  Created by Jonathan Gascoigne on 4/1/19.
//  Copyright © 2019 Albertsons. All rights reserved.
//

import Foundation

open class ABTextView: ABField {
    var textView:UITextView = UITextView()
    var placeholderLabel = UILabel()
    
    /// The text displayed by the text field.
    override public var text: String? {
        get {
            return textView.text
        }
        set {
            textView.text = newValue
        }
    }
    
    /// The styled text displayed by the text view.
    override public var attributedText: NSAttributedString? {
        get {
            return textView.attributedText
        }
        set {
            textView.attributedText = newValue
        }
    }
    
    /**
     Pressing return on the keyboard will return a new line instead of closing the keyboard
     
     When called, this also adds a done button to the keyboard on top
     */
    @discardableResult public func supportNewLine() -> ABTextView {
        supportsNewLine = true
        addDoneOnTopOfKeyboard()
        returnKeyType = .default
        return self
    }
    var supportsNewLine = false
    var customFieldHeight:CGFloat = 120
    override var fieldHeight: CGFloat {
        return customFieldHeight
    }
    
    /** Set the height of the TextView
 
    When called, the constraints of the text view will automatically adjust*/
    public func changeFieldHeight(_ height:CGFloat) {
        customFieldHeight = height
        layoutBorderConstraints()
    }
    
    override func setPlaceholder() {
        placeholderLabel.text = placeholder
        placeholderLabel.isHidden = !textView.text.isEmpty
        setTextViewAccessiblity()
    }
    
    func setTextViewAccessiblity() {
        textView.accessibilityLabel = textView.text.isEmpty ? placeholder : nil
    }
    
    override public func addDoneOnTopOfKeyboard() {
       textView.addDoneToolBar()
    }
    
    override public func removeToolbarFromKeyboard() {
        textView.inputAccessoryView = nil
    }
    
    @discardableResult override open func becomeFirstResponder() -> Bool {
        return textView.becomeFirstResponder()
    }
    
    @discardableResult override open func resignFirstResponder() -> Bool {
        return textView.resignFirstResponder()
    }
    
    override open var isFirstResponder: Bool {
        return textView.isFirstResponder
    }
    
    override func configureAccessibleElements() {
        super.configureAccessibleElements()
        self.textView.isAccessibilityElement = true
        self.placeholderLabel.isAccessibilityElement = false
    }
    
    
    override func buildHierarchy() {
        addSubview(borderView)
        borderView.addSubview(textView)
        addSubview(imageLabel)
        borderView.addSubview(placeholderLabel)
    }
    
    override func setup() {
        super.setup()
        textField.isHidden = true
        textField.removeFromSuperview()
    }
    
    override func buildStyle() {
        super.buildStyle()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        textView.tintColor = textField.tintColor
        textView.textColor = textField.textColor
        textView.layer.sublayerTransform = CATransform3DMakeTranslation(1, 0, 0)
        textView.font = textField.font
        placeholderLabel.font = textField.font
        placeholderLabel.numberOfLines = 0
        placeholderLabel.textColor = universal_B1B1B1
    }
    
    override func buildConstraints() {
        super.buildConstraints()
        placeholderLabel.snp.makeConstraints { (make) in
            make.left.equalTo(textView).offset(5)
            make.right.equalTo(textView)
            make.top.equalTo(textView).offset(8.25)
        }
    }
    
    override func layoutImageLabelConstraints() {
        imageLabel.snp.remakeConstraints { make in
            make.left.equalTo(textView.snp.right).offset(-8)
            make.right.equalTo(extraButton?.snp.left ?? borderView.snp.right).offset(-8)
            make.width.equalTo(imageLabel.isHidden ? 0 : 20)
            make.height.equalTo(20)
            make.top.equalTo(borderView).offset(8)
        }
    }
    
    override func layoutTextFieldConstraints() {
        textView.snp.remakeConstraints { make in
            make.left.equalTo(borderView)
            make.right.equalTo(imageLabel.snp.left).offset(-8)
            make.top.equalTo(borderView)
            make.bottom.equalTo(borderView)
        }
    }
    
    /// Layout Label Constraints
    override func layoutErrorLabelConstraints() {
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutBorderConstraints()
        errorLabel.snp.remakeConstraints { make in
            make.top.equalTo(borderView.snp.bottom).offset(5)
            make.left.equalTo(textView).offset(5)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        errorLabel.layoutIfNeeded()
    }
    
    override func setDefaultsForType(_ type:ABFieldType) {
        super.setDefaultsForType(type)        
        textView.autocorrectionType = textField.autocorrectionType
        textView.autocapitalizationType = textField.autocapitalizationType
    }
    
    override public var returnKeyType:UIReturnKeyType {
        get {
            return textView.returnKeyType
        }
        set {
            textView.returnKeyType = newValue
        }
    }
    
    override public var textContentType:UITextContentType! {
        get {
            return textView.textContentType
        }
        set {
            textView.textContentType = newValue
        }
    }
    
    override public var keyboardType:UIKeyboardType {
        get {
            return textView.keyboardType
        }
        set {
            textView.keyboardType = newValue
        }
    }
    
    /// A succinct label that identifies the accessibility element of the text view, in a localized string.
    override open var accessibilityLabel:String? {
        get {
            return textView.accessibilityLabel
        }
        set {
            textView.accessibilityLabel = newValue
        }
    }
    
    /// A brief description of the result of performing an action on the accessibility element (text view), in a localized string.
    override open var accessibilityHint:String? {
        get {
            return textView.accessibilityHint
        }
        set {
            textView.accessibilityHint = newValue
        }
    }
    
    override public func setCursorAtPosition(_ location:Int) {
        let beginPosition = self.textView.beginningOfDocument
        let textPosition = self.textView.position(from: beginPosition, offset: location)
        
        if let textPosition = textPosition {
            let newTextRange = self.textView.textRange(from: textPosition, to: textPosition)
            self.textView.selectedTextRange = newTextRange
        }
        
    }
    
    override public func selectAll() {
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.endOfDocument)
    }
    
    override func changeTint() {
        textView.inputAccessoryView?.tintColor = tintColor
    }
}

extension ABTextView {
    public func textViewDidChange(_ textView: UITextView) {
        guard textView == self.textView else { return }
        if !supportsNewLine { textView.text = text?.replacingOccurrences(of: "\n", with: " ") }
        if var newText = textView.text, let limit = self.maxLength {
            if newText.count > limit {
                newText = String(newText[newText.index(newText.startIndex, offsetBy: limit)...])
                textView.text = newText
            }
        }
        placeholderLabel.isHidden = !textView.text.isEmpty
        setTextViewAccessiblity()
        delegate?.abFieldValueDidChange?(self)
    }
    
    public func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView == self.textView else { return }
        if state == .inactive {
            state = .active
        }
        delegate?.abFieldDidStartEditing?(self)
    }
    
    public func textViewDidEndEditing(_ textView: UITextView) {
        guard textView == self.textView else { return }
        text = text?.trimmingCharacters(in: .whitespaces)
        state = .inactive
        delegate?.abFieldDidEndEditing?(self)
    }
    
    public func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard textView == self.textView else { return true }
        if !supportsNewLine && text == "\n" {
            resignFirstResponder()
            return false
        }
        return true
    }
}
