//
//  KeyboardAvoidance.swift
//  UCheckout
//
//  Created by 1521398 on 02/09/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import UIKit
import Foundation

public protocol ScrollingKeyboardAvoidable: class {
    var scrollView: UIScrollView! { get }
    var notificationCenter: NotificationCenter { get }
    
    init(scrollView: UIScrollView, notificationCenter: NotificationCenter?, bottomPadding: CGFloat)
    func unregisterForKeyboardNotifications()
    func registerForKeyboardNotifications()
}

public class PaddedKeyboardAvoider: SimpleKeyboardAvoider {
    var bottomPadding: CGFloat
    
    public required init(scrollView: UIScrollView, notificationCenter: NotificationCenter? = nil, bottomPadding: CGFloat = 0) {
        self.bottomPadding = bottomPadding
        super.init(scrollView: scrollView, notificationCenter: notificationCenter, bottomPadding: bottomPadding)
        
        // Set scrollview bottom padding
        updateBottomInset(bottomInset: bottomPadding)
    }
    
    // Called when the UIKeyboardDidShowNotification is sent.
    @objc override func keyboardWasShown(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let kbSize = keyboardFrame.size
        
        self.updateBottomInset(bottomInset: kbSize.height)
        
    }
    
    private func updateBottomInset(bottomInset: CGFloat) {
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: bottomInset, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
}

public class SimpleKeyboardAvoider: ScrollingKeyboardAvoidable {
    public private(set) weak var scrollView: UIScrollView!
    public let notificationCenter: NotificationCenter
    
    public required init(scrollView: UIScrollView, notificationCenter: NotificationCenter? = nil, bottomPadding: CGFloat) {
        self.scrollView = scrollView
        self.notificationCenter = notificationCenter ?? .default
        self.registerForKeyboardNotifications()
    }
    
    deinit {
        unregisterForKeyboardNotifications()
    }
    
    public func unregisterForKeyboardNotifications() {
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    public func registerForKeyboardNotifications() {
        unregisterForKeyboardNotifications()
        notificationCenter.addObserver(self, selector: #selector(SimpleKeyboardAvoider.keyboardWasShown(_:)), name: UIResponder.keyboardDidShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(SimpleKeyboardAvoider.keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
        
    }
    
    // Called when the UIKeyboardDidShowNotification is sent.
    @objc func keyboardWasShown(_ notification: Notification) {
        guard let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        let kbSize = keyboardFrame.size
        let contentInsets: UIEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        scrollView.scrollRectToVisible(CGRect(x: scrollView.contentSize.width - 1, y: scrollView.contentSize.height - 1, width: 1, height: 1), animated: true)
    }
    
    @objc func keyboardDidHide(_ notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
    
    // Called when the UIKeyboardWillHideNotification is sent
    @objc func keyboardWillBeHidden(_ notification: Notification) {
        scrollView.contentInset = .zero
        scrollView.scrollIndicatorInsets = .zero
    }
}


