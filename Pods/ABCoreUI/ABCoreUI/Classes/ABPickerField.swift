//
//  ABPickerField.swift
//  ECommerce
//
//  Created by Jonathan Gascoigne on 4/3/19.
//  Copyright © 2019 Albertsons. All rights reserved.
//

import Foundation

public class ABPickerField: ABField {
    public var textFieldFormat = "%@" {
        didSet {
            setPickerDefaults()
        }
    }
    public var pickerValues:[[String]] = [["1", "2", "3", "4", "5", "6"]] {
        didSet {
            setPickerDefaults()
        }
    }
    private var pickerView = UIPickerView()
    var toolbarTitle = UILabel()
    /// This boolean value defines if the first value in the picker is used as a placeholder
    ///
    /// Set this if the first value is non-empty placeholder text. By default this is false, however the first value is automatically used as a placeholder if it is empty
    public var firstValueIsPlaceholder = false {
        didSet {
            setPickerDefaults()
        }
    }
    
    public convenience init(withTitle title:String, placeholder:String? = nil, values:[[String]], format: String? = nil)
    {
        self.init(withTitle: title, placeholder: placeholder)
        pickerValues = values
        textFieldFormat = format ?? "%@"
    }
    
    public convenience init(_ values:[[String]], format: String? = nil)
    {
        self.init()
        pickerValues = values
        textFieldFormat = format ?? "%@"
    }
    
    func setPickerDefaults() {
        guard pickerValues.first?.count ?? 0 > 0 else { return }
        pickerView.reloadAllComponents()
        textField.isEnabled = pickerValues.first?.count ?? 0 > 1
        textField.accessibilityTraits = textField.isEnabled ? .none : .staticText
        extraButton?.isHidden = !textField.isEnabled
        if firstValueIsPlaceholder {
            for i in 0..<pickerValues.count {
                pickerView.selectRow(0, inComponent: i, animated: false)
            }
            setText()
            placeholder = pickerText()
        }
    }
    
    override func buildStyle() {
        super.buildStyle()
        textField.isAccessibilityElement = true
        textField.tintColor = UIColor.clear
        let dropDownButton = UIButton()
        let image = UIImage(named: "Expand Chevron", in: resourceBundle(), compatibleWith: nil)
        dropDownButton.setImage(image, for: .normal)
        setupExtraButton(dropDownButton)
        extraButtonAction = { button in
            self.becomeFirstResponder()
        }
        addDoneOnTopOfKeyboard()
        textField.inputView = pickerView
        textField.inputAssistantItem.leadingBarButtonGroups = []
        textField.inputAssistantItem.trailingBarButtonGroups = []
        textField.autocorrectionType = .no
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    override func configureAccessibleElements() {
        super.configureAccessibleElements()
        extraButton?.isAccessibilityElement = false
    }
    
    override func setPlaceholder() {
        super.setPlaceholder()
        toolbarTitle.textColor = universal_B1B1B1
        toolbarTitle.text = placeholder
    }
    
    override public func addDoneOnTopOfKeyboard() {
        if textField.inputAccessoryView == nil {
            let doneToolBar = UIToolbar()
            doneToolBar.sizeToFit()
            let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let button = UIBarButtonItem(customView: toolbarTitle)
            toolbarTitle.text = placeholder
            let flexibleSpace2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
            let barButtonDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didTouchDone))
            doneToolBar.tintColor = UIApplication.shared.delegate?.window??.tintColor
            doneToolBar.items = [flexibleSpace, button, flexibleSpace2, barButtonDone]
            textField.inputAccessoryView = doneToolBar
        }
    }
    
    @objc func didTouchDone() {
        if UIAccessibility.isVoiceOverRunning {
            UIAccessibility.post(notification: UIAccessibility.Notification.screenChanged, argument: textField)
        }
        resignFirstResponder()
    }
    
    public func selectRow(_ row: Int, inComponent component: Int, animated: Bool = true) {
        pickerView.selectRow(row, inComponent: component, animated: animated)
        if row == -1 {
            text = ""
        }
        else {
            setText()
        }
    }
    
    override public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return pickerValues.first?.count ?? 0 > 1
    }
    
    func setText() {
        guard pickerValues.count > 0 else { return }
        guard pickerView.selectedRow(inComponent: 0) > -1 else { text = ""; return }
        if (firstValueIsPlaceholder || pickerValues[0][0].isEmpty) && pickerView.selectedRow(inComponent: 0) == 0 {
            text = ""
            // the value will be used as the placeholder, but if subsequential components are changed, the placeholder text must be updated
            if pickerValues.count > 1 {
                placeholder = pickerText()
            }
        }
        else {
            text = pickerText()
        }
    }
    
    public override func textFieldDidEndEditing(_ textField: UITextField) {
        setText()
        super.textFieldDidEndEditing(textField)
    }
    
    func pickerText() -> String {
        let values = pickerValues.enumerated().map { $0.element[pickerView.selectedRow(inComponent: $0.offset)] }
        return String(format: textFieldFormat, arguments: values)
    }
}

extension ABPickerField:UIPickerViewDelegate, UIPickerViewDataSource, UIPickerViewAccessibilityDelegate {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return pickerValues.count
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        setText()
        textFieldValueDidChange(textField)
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerValues[component].count
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerValues[component][row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, accessibilityHintForComponent component: Int) -> String? {
        guard pickerValues.count > 1 else { return nil }
        return "Component \(component + 1) of \(pickerValues.count)"
    }
}
