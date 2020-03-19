//
//  ABStepperView.swift
//  ECommerce
//  Custom Control for products to increment and decrement quantity
//  This view is made up for three main components 
//  Button + TextField + Button
//  Created by Ganesh Reddiar on 6/3/16.
//  Copyright © 2016 Albertsons. All rights reserved.
//

import Foundation

@IBDesignable
public class ABStepperView:UIView {
    public var quantity:Int = 0 {
        didSet {
            tempQuantity = quantity
            hideSpinner()
            if quantity == 0 {
                addAddButton()
            }
            else {
                removeAddButton()
                textField.text = "\(quantity) in cart"
                setPlusButtonBackground()
            }
            accessibilityValue = "\(quantity) in cart"
            configAccessibility()
        }
    }
    public var tempQuantity:Int = 0 {
        didSet {
            textField.text = "\(tempQuantity)"
            setPlusButtonBackground(forQuantity: tempQuantity)
            accessibilityValue = "\(tempQuantity)"
            configAccessibility()
        }
    }
    
    var minusButton = UIButton()
    var plusButton = UIButton()
    var addButton:UIButton?
    var textField = UITextField()
    var timer:Timer?
    var activitySpinner:UIActivityIndicatorView?
    
    public var actionForUpdateQuantity : ((Int)->())?
    public var actionForAdd : (()->())?
    public var canEditCart: (()->(Bool))?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        build()
    }
    
    
    override public func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        build()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        build()
    }
    
    
    func build() {
        buildViewHeirarchy()
        buildConstraints()
        buildStyle()
        buildActions()
        configAccessibility()
        addAddButton()
    }
    
    public func showSpinner() {
        isUserInteractionEnabled = false
        addButton?.setTitle("", for: .normal)
        textField.text = ""
        activitySpinner = UIActivityIndicatorView(style: .gray)
        insertSubview(activitySpinner!, belowSubview: minusButton)
        activitySpinner?.snp.makeConstraints { (make) in
            make.center.equalTo(textField)
        }
        activitySpinner?.startAnimating()
    }
    
    public func hideSpinner() {
        isUserInteractionEnabled = true
        addButton?.setTitle("ADD", for: .normal)
        textField.text = "\(quantity) in cart"
        activitySpinner?.removeFromSuperview()
        activitySpinner = nil
    }
    
    public func showCheckBox() {
        isUserInteractionEnabled = false
        let checkLabel = UILabel()
        addSubview(checkLabel)
        checkLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        addButton?.titleLabel?.alpha = 0
        textField.alpha = 0
        checkLabel.text = "✓"
        checkLabel.font = .systemFont(ofSize: 17, weight: .heavy)
        checkLabel.textAlignment = .center
        checkLabel.textColor = quantity == 0 ? plusButton.titleColor(for: .normal) : .black
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.4, execute: {
            UIView.animate(withDuration: 0.2, animations: {
                checkLabel.alpha = 0
                if self.quantity == 0 {
                    self.addButton?.titleLabel?.alpha = 1
                }
                else {
                    self.textField.alpha = 1
                }
            }, completion: { _ in
                self.isUserInteractionEnabled = true
                checkLabel.removeFromSuperview()
            })
        })
    }
    
    func buildViewHeirarchy() {
        addSubview(textField)
        addSubview(minusButton)
        addSubview(plusButton)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        if activitySpinner == nil && addButton != nil && minusButton.superview != nil {
            minusButton.snp.updateConstraints { make in
                make.width.equalTo(frame.width/2)
            }
            plusButton.snp.updateConstraints { make in
                make.width.equalTo(frame.width/2)
            }
        }
    }
    
    func buildConstraints() {
        
        minusButton.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalToSuperview()
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        plusButton.snp.makeConstraints { make in
            make.width.equalTo(40)
            make.height.equalToSuperview()
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        textField.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().offset(-80)
            make.height.equalToSuperview()
        }
    }
    
    /// Shows the add button and hidees the minus/plus button and number of items in cart
    ///
    /// This is automatically called when the quantity is 0
    public func addAddButton() {
        guard addButton == nil else {
            addButton?.setTitle("ADD", for: .normal)
            return            
        }
        textField.alpha = 0
        minusButton.titleLabel?.alpha = 0
        plusButton.titleLabel?.alpha = 0
        textField.isUserInteractionEnabled = false
        minusButton.isUserInteractionEnabled = false
        plusButton.isUserInteractionEnabled = false
        minusButton.snp.updateConstraints { make in
            make.width.equalTo(frame.width/2)
        }
        plusButton.snp.updateConstraints { make in
            make.width.equalTo(frame.width/2)
        }
        addButton = UIButton()
        addButton?.setTitle("ADD", for: .normal)
        if tintColor?.isLight() == true {
            addButton?.setTitleColor(.black, for: .normal)
        }
        else {
            addButton?.setTitleColor(.white, for: .normal)
        }
        addButton?.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .init(rawValue: 900))
        addButton?.isUserInteractionEnabled = true
        addSubview(addButton!)
        addButton?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        addButton?.addTarget(self, action: #selector(didTapOnAdd), for: .touchUpInside)
    }
    
    /// Remove the add button and show the minus/plus button and number of items in cart
    ///
    /// This is automatically called when the quantity is greater than 0
    public func removeAddButton() {
        textField.alpha = 1
        minusButton.titleLabel?.alpha = 1
        plusButton.titleLabel?.alpha = 1
        textField.isUserInteractionEnabled = true
        minusButton.isUserInteractionEnabled = true
        plusButton.isUserInteractionEnabled = true
        minusButton.snp.updateConstraints { make in
            make.width.equalTo(40)
        }
        plusButton.snp.updateConstraints { make in
            make.width.equalTo(40)
        }
        guard let addButton = addButton else { return }
        addButton.removeFromSuperview()
        self.addButton = nil
    }
    
    public override func tintColorDidChange() {
        setPlusButtonBackground()
        minusButton.backgroundColor = tintColor
        if tintColor?.isLight() == true {
            minusButton.setTitleColor(.black, for: .normal)
            plusButton.setTitleColor(.black, for: .normal)
            addButton?.setTitleColor(.black, for: .normal)
        }
        else {
            minusButton.setTitleColor(.white, for: .normal)
            plusButton.setTitleColor(.white, for: .normal)
            addButton?.setTitleColor(.white, for: .normal)
        }
        layer.borderColor = tintColor.cgColor
        textField.inputAccessoryView?.tintColor = tintColor
    }
    
    func setPlusButtonBackground(forQuantity customQuantity: Int? = nil) {
        if (customQuantity ?? quantity) >= ABConfig.maxStepperValue {
            if tintColor?.isLight() == true {
                plusButton.backgroundColor = tintColor.darken(by: 50)
            }
            else {
                plusButton.backgroundColor = tintColor.lighten(by: 50)
            }
        } else {
            plusButton.backgroundColor = tintColor
        }
    }
    
    func buildStyle() {
        layer.borderWidth = 1.0
        
        minusButton.setTitle("-", for: .normal)
        plusButton.setTitle("+", for: .normal)
        
        minusButton.titleLabel?.font = .systemFont(ofSize: 20)
        plusButton.titleLabel?.font = .systemFont(ofSize: 20)
        
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        
        textField.font = .systemFont(ofSize: 14, weight: .bold)
    }
    
    func buildActions() {
        textField.delegate = self
        textField.addTarget(
            self,
            action: #selector(textFieldDidChange(_:)),
            for: .editingChanged
        )
        minusButton.addTarget(
            self,
            action: #selector(onTap(decrement:)),
            for: .touchUpInside
        )
        plusButton.addTarget(
            self,
            action: #selector(onTap(increment:)),
            for: .touchUpInside
        )
    }
    
    func switchToEditing () {
        guard canEditCart?() ?? true else { return }
        textField.addUpdateToolBar(target: self, action: #selector(onTap(update:)))
        textField.text = "\(quantity)"
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }
    
    @objc func onTap(update button:UIButton) {
        guard let value = textField.text else {return}
        textField.endEditing(true)
        if let quantity = Int(value) {
            updateQuantity(with: quantity)
        }
        else if value.isEmpty {
            updateQuantity(with: 0)
        }
    }
    
    @objc func onTap(decrement button:UIButton) {
        guard canEditCart?() ?? true, tempQuantity > 0 else { return }
        restartTimer()
        tempQuantity = max(tempQuantity - 1, 0)
        if UIAccessibility.isVoiceOverRunning {
            UIAccessibility.post(notification: .announcement, argument: "\(tempQuantity)")
        }
    }
    
    @objc func onTap(increment button:UIButton) {
        guard canEditCart?() ?? true, tempQuantity < ABConfig.maxStepperValue else { return }
        restartTimer()
        tempQuantity = min(tempQuantity + 1, ABConfig.maxStepperValue)
        if UIAccessibility.isVoiceOverRunning {
            UIAccessibility.post(notification: .announcement, argument: "\(tempQuantity)")
        }
    }
    
    func restartTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: UIAccessibility.isVoiceOverRunning ? 2 : 1, repeats: false) { [weak self] timer in
            guard let safeSelf = self else { return }
            safeSelf.updateQuantity(with: safeSelf.tempQuantity)
        }
    }
    
    @objc func didTapOnAdd() {
        guard canEditCart?() ?? true else { return }
        if let action = actionForAdd {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
                self.removeAddButton()
                self.layoutIfNeeded()
            })
            action()
            textField.text = nil
            return
        }
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.quantity = 1
            self.layoutIfNeeded()
        })
        UIAccessibility.post(notification: UIAccessibility.Notification.announcement, argument: "\(quantity) now in cart")
    }
    
    func updateQuantity(with value:Int) {
        if let action = actionForUpdateQuantity {
            action(value)
            textField.text = nil
            return
        }
        quantity = value
        textFieldDidEndEditing(textField)
        UIAccessibility.post(notification: UIAccessibility.Notification.announcement, argument: "\(quantity) now in cart")
    }
    
    func configAccessibility() {
        isAccessibilityElement = true
        if quantity > 0 {
            accessibilityTraits = .adjustable
            accessibilityLabel = ""
            accessibilityHint = "Double tap to manually edit value"
        }
        else {
            accessibilityTraits = .button
            accessibilityLabel = "Add"
            accessibilityValue = nil
            accessibilityHint = "Double tap to add to cart"
        }
    }
    
    public override func accessibilityActivate() -> Bool {
        if quantity == 0 {
            didTapOnAdd()
        }
        else {
            textField.becomeFirstResponder()
        }
        return true
    }
    
    public override func accessibilityDecrement() {
        onTap(decrement: minusButton)
    }
    
    public override func accessibilityIncrement() {
        onTap(increment: plusButton)
    }
}

//MARK:- UITextFieldDelegate - Implementations
//======================================================================

extension ABStepperView:UITextFieldDelegate {
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return activitySpinner == nil && !(timer?.isValid == true)
    }
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        switchToEditing()
    }
    
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.text = "\(quantity) in cart"
        configAccessibility()
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        onTap(update: plusButton)
        return true
    }
    
    @objc public func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, let value = Int(text) {
            if value > ABConfig.maxStepperValue {
                textField.text = String(ABConfig.maxStepperValue)
                textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
            }
            else if text.first == "0" && text.count > 1 {
                textField.text = String(value)
            }
        }
    }
}


extension UIColor {
    
    /// Check if the color is light or dark, as defined by the injected lightness threshold.
    func isLight(threshold: Float = 0.5) -> Bool? {
        let originalCGColor = self.cgColor
        
        // Now we need to convert it to the RGB colorspace. UIColor.white / UIColor.black are greyscale and not RGB.
        // If you don't do this then you will crash when accessing components index 2 below when evaluating greyscale colors.
        let RGBCGColor = originalCGColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil)
        guard let components = RGBCGColor?.components else {
            return nil
        }
        guard components.count >= 3 else {
            return nil
        }
        
        let brightness = Float(((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000)
        return (brightness > threshold)
    }
    
    fileprivate func lighten(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    fileprivate func darken(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    private func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
}
