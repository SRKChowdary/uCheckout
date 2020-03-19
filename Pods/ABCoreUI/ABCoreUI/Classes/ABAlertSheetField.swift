//
//  ABDropDownField.swift
//  MasterApp
//
//  Created by Ganesh Reddiar on 12/18/15.
//  Copyright © 2015 Safeway. All rights reserved.
//

import UIKit

public class ABAlertSheetField: ABField {
    
    public var shouldShowCancel = true
    public var dropdownValues:[String] = ["1", "2", "3", "4", "5", "6"] {
        didSet {
            textField.accessibilityTraits = dropdownValues.count > 1 ? UIAccessibilityTraits.none : UIAccessibilityTraits.staticText
        }
    }
    
    var headerTitle:String?
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if dropdownValues.count > 1 {
            state = .active
        }
        return false
    }
    
    override func setupState() {
        super.setupState()
        if state == .active {
            if let window = UIApplication.shared.keyWindow {
                showInView(window)
            }
        }
    }
    
    override func setup() {
        super.setup()
        let dropDownButton = UIButton()
        //dropDownButton.setImage(#imageLiteral(resourceName: "Expand Chevron"), for: .normal)
        setupExtraButton(dropDownButton)
        textField.isAccessibilityElement = true
        extraButtonAction = { button in
            self.becomeFirstResponder()
        }
    }
    
    override func configureAccessibleElements() {
        super.configureAccessibleElements()
        extraButton?.isAccessibilityElement = false
    }
    
    func showInView(_ view:UIView) {
        guard let viewController = parentViewController else {
            return
        }
        
        delegate?.abFieldDidStartEditing?(self)
       
        let sheet = UIAlertController(title: headerTitle ?? placeholder, message: nil, preferredStyle: .actionSheet)
        for value in dropdownValues {
            sheet.addAction(UIAlertAction(title: value, style: .default, handler: { action in self.text = value }))
        }
        if shouldShowCancel {
            sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        }
        viewController.present(sheet, animated: true)
    }
    
    private var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

