//
//  UIView
//
//  Created by Bobby Williams on 2/19/18.
//  Copyright © 2018 Albertsons. All rights reserved.
//

import UIKit


extension UIViewController {
    /// The view moved up by the `registerViewWithKeyboard()` method
    ///
    /// By default this will use a scroll view on the first level of the view's hierarchy or the view itself when unavailable
    @objc open func viewToMoveWithKeyboard() -> UIView {
        return scrollViewInController ?? view
    }
    
    /**
     Adds observers to the Notification Center to move the view upwards when the keyboard appears
     
     When the keyboard appears, the method will search for a scroll view on first level of the view's hierarchy and scroll it upwards to keep the edited text field in view. The scroll view will add to the bottom of the content's insets as well as the scroll indicators. When there is no scroll view, the main view instead moves upwatd to accomedate. Moving the main view will move the view back down when finished, however scroll views will not unless scrolling upwards has pushed the view past its limits
     
     If the text field is already higher than the keyboard, the view does not move. In compact height situations, if there isn't enough room to show the text field and keyboard, the navigation bar collapses until the keyboard is hidden
     
     - Important: You should remove the observers using ```deregisterViewWithKeyboard()``` when the view is no longer visible
     */
    public func registerViewWithKeyboard() {
        moveViewWithKeyboard(showAction: #selector(UIViewController.keyboardAppearing), hideAction: #selector(UIViewController.keyboardHiding))
    }
    
    func moveViewWithKeyboard(showAction: Selector?, hideAction: Selector?) {
        guard let showAction = showAction, let hideAction = hideAction else { return }
        NotificationCenter.default.addObserver(self, selector: showAction,
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: showAction,
                                               name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: hideAction,
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: hideAction,
                                               name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    /// removes the observers added from the `registerViewWithKeyboard()` method, so the view no longer scrolls up with the keybaord
    public func deregisterViewWithKeyboard() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardDidHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    //
    // MARK: keyboard notification handlers
    //
    @objc func keyboardAppearing(notification: Notification) {
        moveViewUp(notification: notification)
    }
    
    @objc func keyboardHiding(notification: Notification) {
        moveViewDown(notification: notification)
    }
    
    @objc func moveViewUp (notification:Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            guard let tField = view.currentFirstResponder() else { return }
            let keyView:UIView! = UIApplication.shared.keyWindow ?? view
            let origin = (tField.superview ?? tField).convert(tField.frame.origin, to: keyView)
            var bottomY = keyView.frame.maxY - (tField.frame.height + origin.y)
            if let navC = navigationController {
                if !navC.isNavigationBarHidden, keyboardSize.height + tField.frame.height > keyView.frame.height - navC.navigationBar.frame.height - StatusBarFrame.height {
                    navC.setNavigationBarHidden(true, animated: true)
                    navC.navigationBar.isAccessibilityElement = true
                }
                if notification.name != UIResponder.keyboardDidShowNotification && navC.isNavigationBarHidden {
                    bottomY += navC.navigationBar.frame.height
                }
            }
            let height = keyboardSize.height - bottomY
            if let scrollView = viewToMoveWithKeyboard() as? UIScrollView {
                scrollView.contentInset.bottom = keyboardSize.height - (keyView.frame.maxY - viewToMoveWithKeyboard().frame.maxY)
                scrollView.scrollIndicatorInsets.bottom = scrollView.contentInset.bottom
            }
            if height > 0 {
                if let scrollView = viewToMoveWithKeyboard() as? UIScrollView {
                    if notification.name == UIResponder.keyboardDidShowNotification {
                        UIView.animate(withDuration: 0.25) {
                            scrollView.contentOffset.y += height
                        }
                    }
                    else {
                        scrollView.contentOffset.y += height
                    }
                }
                else {
                    if notification.name == UIResponder.keyboardDidShowNotification {
                        UIView.animate(withDuration: 0.25) {
                            self.viewToMoveWithKeyboard().bounds.origin.y = height
                        }
                    }
                    else {
                        viewToMoveWithKeyboard().bounds.origin.y = height
                    }
                }
            } else {
                if notification.name != UIResponder.keyboardDidShowNotification {
                    view.bounds.origin.y = 0
                }
            }
        }
    }
    
    @objc func moveViewDown (notification:Notification) {
        if navigationController?.isNavigationBarHidden == true && navigationController?.navigationBar.isAccessibilityElement == true {
            navigationController?.setNavigationBarHidden(false, animated: true)
            navigationController?.navigationBar.isAccessibilityElement = false
        }
        if let scrollView = viewToMoveWithKeyboard() as? UIScrollView {
            if scrollView.keyboardDismissMode != .interactive {
                scrollView.contentOffset.y = min(scrollView.contentOffset.y, max(scrollView.contentSize.height - scrollView.bounds.size.height, 0))
            }
            scrollView.contentInset.bottom = 0
            scrollView.scrollIndicatorInsets.bottom = scrollView.contentInset.bottom
        }
        view.bounds.origin.y = 0
    }
   
    fileprivate var scrollViewInController: UIScrollView? {
        if let scrollView = view as? UIScrollView { return scrollView }
        return view.subviews.first(where: { $0 is UIScrollView}) as? UIScrollView
    }
    
}

struct StatusBarFrame {
    fileprivate static var height: CGFloat {
        // 40 is the status bar height when a call is ongoing on older iphones, however we can only access 20px of it
        return UIApplication.shared.statusBarFrame.height == 40 ? 20 : UIApplication.shared.statusBarFrame.height
    }
    
}

extension UIView {
    fileprivate func currentFirstResponder() -> UIView? {
        if isFirstResponder {
            return self
        }
        
        for view in subviews {
            if let responder = view.currentFirstResponder() {
                return responder
            }
        }
        return nil
    }
}
