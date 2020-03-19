//
//  ABPhoneField.swift
//  ABUIKit
//
//  Created by Jonathan Gascoigne on 5/10/19.
//

import Foundation

public class ABPhoneField: ABField {
    public var customLength = false
    var formatter = PhoneFormatter(editingNumber: "")
    override func setup() {
        super.setup()
        type = .phone
        setDefaultsForType(.phone)
    }
    
    func setRawIndex(of text: String, at location: Int, plus count: Int) {
        formatter.setRawIndex(of: text, at: location, plus: count)
    }
    
    func formatNumberAndSetCursor(_ number:String?) -> (text:String, pos:Int) {
        guard let number = number else { return ("", 0) }
        formatter.editingNumber = number
        formatter.formatChange()
        return (formatter.editingNumber, formatter.getFormattedIndex())
    }
    
    func canAddToString(_ text: String, range: NSRange, with string:String) -> Bool {
        guard let textRange = Range(range, in: text) else { return true }
        let updatedText = PhoneFormatter.rawNumbers(text.replacingCharacters(in: textRange, with: string))
        guard updatedText.count > 0 && !customLength else { return true }
        return updatedText.count <= (updatedText[updatedText.startIndex] == "1" ? 11 : 10) // for numbers starting with 1 XXX XXX XXXX
    }
    
    override public func textFieldValueDidChange(_ textField: UITextField) {
        let textAndPos = formatNumberAndSetCursor(text)
        text = textAndPos.text
        setCursorAtPosition(textAndPos.pos)
        super.textFieldValueDidChange(textField)
    }
    
    override public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if self.delegate?.abField?(self, shouldChangeCharactersIn: range, replacementString: string) ?? true {
            if let text = text, canAddToString(text, range: range, with: string) {
                formatter.editingNumber = text
                setRawIndex(of: text, at: range.location, plus: string.count)
                return true
            }
        }
        return false
    }
    
    public func textIsAtMaxLength() -> Bool {
        let updatedText = PhoneFormatter.rawNumbers(text ?? "")
        guard updatedText.count > 0 else { return false }
        return updatedText.count == (updatedText[updatedText.startIndex] == "1" ? 11 : 10) // for numbers starting with 1 XXX XXX XXXX
    }
    
    public func rawNumber() -> String {
        return PhoneFormatter.rawNumbers(text ?? "")
    }
}
