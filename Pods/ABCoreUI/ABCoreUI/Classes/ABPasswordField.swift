//
//  ABPasswordField.swift
//  MasterApp
//
//  Created by Ganesh Reddiar on 12/13/15.
//  Copyright © 2015 Safeway. All rights reserved.
//

import UIKit
/**
 Based on ABField, with password entry protection, an extra button to toggle protection, and validation to compare password to another field
 */
public class ABPasswordField:ABField {
    
    var showButton = UIButton(type: .system)
    static let buttonAttributes:[NSAttributedString.Key:Any] = [.underlineStyle: NSUnderlineStyle.single.rawValue,
                                                         .font: UIFont.systemFont(ofSize: 14),
                                                         .foregroundColor: #colorLiteral(red: 0.3960784314, green: 0.3921568627, blue: 0.3960784314, alpha: 1)]
    private let underLineShowString = NSAttributedString(string: "Show", attributes: buttonAttributes)
    
    private let underLineHideString = NSAttributedString(string: "Hide", attributes: buttonAttributes)
    /// field to compare passwords against when validating
    public weak var fieldToComparePassword:ABField?
    
    override func setup() {
        super.setup()
        setUpShowButton()
        isSecureTextEntry = true
        self.textField.accessibilityLabel = "Password"
        routines = [PasswordValidator.isValidPassword]
        type = .password
        setDefaultsForType(.password)
    }
    
    /// Identifies whether the text object should disable text copying and in some cases hide the text being entered.
    ///
    /// For this field, this value is set to `true` by default
    public var isSecureTextEntry:Bool {
        get {
            return textField.isSecureTextEntry
        }
        set {
            textField.isSecureTextEntry = newValue
        }
    }
    
    /// Runs the validation routines assigned to the field
    /// - Parameter shouldShowError: After running, this value decides to show the error message on failure, or a checkmark on success (if enabled)
    /// - Returns: The success or failure of the result
    ///
    /// If the field has field to compare to for password confirmation, it will validate if the passwords match as well. After running the validation, this calls its delegate to alert it of the field's sucess or failure
    @discardableResult override public func validate(shouldShowError showError: Bool = true) -> Bool {
        if let password = fieldToComparePassword?.text {
            return validate(shouldShowError: showError, shouldMatchPassword: password)
        }
        return super.validate(shouldShowError: showError)
    }
    
    /// Runs the validation routines assigned to the field
    /// - Parameter shouldShowError: After running, this value decides to show the error message on failure, or a checkmark on success (if enabled)
    /// - Parameter shouldMatchPassword: An extra validation check to check if the text matches the string provided
    /// - Returns: The success or failure of the result
    ///
    /// After running the validation, this calls its delegate to alert it of the field's sucess or failure
    @discardableResult public func validate(shouldShowError showError: Bool = true, shouldMatchPassword password:String) -> Bool {
        var isSuccess = true
        if let routines = routines, routines.count > 0 {
            for routine in routines {
                if !self.executeValidationBlock(routine:routine, showError:showError) {
                    isSuccess = false
                    break
                }
            }
        }
        if isSuccess, text != password {
            isSuccess = false
            hideImageLabel(true)
            if showError {
                errorText = "Sorry, the passwords you entered do not match."
            }
        }
        validationSuccess = isSuccess
        delegate?.abField?(self, validationSuccess: isSuccess)
        return isSuccess
    }
    
    func setUpShowButton() {
        
        self.showButton = UIButton(type: .custom)
        self.showButton.accessibilityLabel = "Show Password"
        extraButtonAction = passwordActionButtonTouched
        self.showButton.translatesAutoresizingMaskIntoConstraints = false
        self.showButton.titleLabel?.textAlignment = .right
        self.showButton.contentHorizontalAlignment = .right
        self.showButton.isHidden = false
        showButton.setAttributedTitle(underLineShowString, for: .normal)
        setupExtraButton(showButton)
    }
    
    override func setupState() {
        super.setupState()
        switch state {
        case .active: showButton.setAttributedTitle(underLineShowString, for: .normal)
        case .inactive: break
        case .error: break
        }
    }
    
    func passwordActionButtonTouched(_ sender:UIButton) {
        if (self.textField.isSecureTextEntry) {
            showButton.setAttributedTitle(underLineHideString, for: .normal)
            showButton.accessibilityLabel = "Hide Password"
            isSecureTextEntry = false
            
        } else {
            showButton.setAttributedTitle(underLineShowString, for: .normal)
            showButton.accessibilityLabel = "Show Password"
            isSecureTextEntry = true
        }
    }
    
    //MARK : GestureRecognizer Delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if let view = touch.view, view.isDescendant(of: self.showButton) {
            return false
        }
        return true
    }
    
}
