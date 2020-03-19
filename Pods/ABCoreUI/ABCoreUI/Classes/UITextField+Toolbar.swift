//
//  UITextField+Toolbar.swift
//  ECommerce
//
//  Created by Ganesh Reddiar on 3/1/17.
//  Copyright © 2017 Albertsons. All rights reserved.
//

import Foundation

protocol AccessoryViewAction {
    func addDoneToolBar()
}

extension AccessoryViewAction where Self: UITextInput & UIView {
    /**
     Adds Done Tool Bar and executes the textfield Did End Editing
     **/
    func addDoneToolBar() {
        addDoneToolBar(target: nil, action: nil)
    }
    func addDoneToolBar(target: Any? = nil, action: Selector? = nil, withTint tintColor:UIColor? = nil) {
        let doneToolBar = UIToolbar()
        doneToolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let barButtonDone = UIBarButtonItem(barButtonSystemItem: .done, target: target ?? self, action: action ?? #selector(resignFirstResponder))
        if let tintColor = tintColor ?? UIApplication.shared.delegate?.window??.tintColor {
            doneToolBar.tintColor = tintColor
        }
        doneToolBar.items = [flexibleSpace, barButtonDone]
        (self as? UITextField)?.inputAccessoryView = doneToolBar
        (self as? UITextView)?.inputAccessoryView = doneToolBar
    }
    
    
    func addUpdateToolBar(target: Any? = nil, action: Selector? = nil, withTint tintColor:UIColor? = nil) {
        let updateToolBar = UIToolbar()
        updateToolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: self, action: nil)
        let barButtonUpdate = UIBarButtonItem(title: "Update", style: .done, target: target ?? self, action: action ?? #selector(resignFirstResponder))
        if let tintColor = tintColor ?? UIApplication.shared.delegate?.window??.tintColor {
            updateToolBar.tintColor = tintColor
        }
        updateToolBar.items = [flexibleSpace, barButtonUpdate]
        (self as? UITextField)?.inputAccessoryView = updateToolBar
        (self as? UITextView)?.inputAccessoryView = updateToolBar
    }
}

extension UITextField: AccessoryViewAction { }
extension UITextView: AccessoryViewAction { }
