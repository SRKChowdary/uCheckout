//
//  PhoneValidation.swift
//  ABCoreUI
//
//  Created by Jonathan Gascoigne on 9/5/19.
//

import Foundation

/// Structure to handle validation of phone numbers
public struct PhoneNumberValidator {
    
    static let phoneNumberRegex = "^1?(\\W*)[2-9]\\d{2}(\\W*)[2-9]\\d{2}(\\W*)\\d{4}$"
    static let firstNumberErrorRegex = "^1?(\\W*)[0-1]\\d{2}(\\W*)[0-9]\\d{2}(\\W*)\\d{4}$"
    static let fourthNumberErrorRegex = "^1?(\\W*)[2-9]\\d{2}(\\W*)[0-1]\\d{2}(\\W*)\\d{4}$"
    static let errorPhonenumberInvalid = "Please enter a valid phone number."
    static let errorPhoneNumberEmpty = "Please enter a phone number."
    static let errorPhoneNumber4thCannotBeZeroOrOne = "Day phone last 7 digits cannot start with 0 or 1."
    static let errorPhoneNumber1stCannotBeZeroOrOne = "Area code digits cannot start with 0 or 1."
    
    /// Checks if the phone number is valid
    ///
    /// Phone Number regex: `^1?(\W*)[2-9]\d{2}(\W*)[2-9]\d{2}(\W*)\d{4}$`
    /// - Parameter testString: String to be tested
    /// - Returns: tuple with success and the error text
    public static func isValidPhoneNumber(_ testString:String) -> ValidationResult {
        switch testString {
        case _ where NSPredicate(format:"SELF MATCHES %@", phoneNumberRegex).evaluate(with: testString):
            return (true, nil)
        case _ where NSPredicate(format:"SELF MATCHES %@", firstNumberErrorRegex).evaluate(with: testString):
            return (false, errorPhoneNumber1stCannotBeZeroOrOne)
        case _ where NSPredicate(format:"SELF MATCHES %@", fourthNumberErrorRegex).evaluate(with: testString):
            return (false, errorPhoneNumber4thCannotBeZeroOrOne)
        default:
            return (false, errorPhonenumberInvalid)
        }
    }
}

/// Structure to handle formatting of phone numbers
public struct PhoneFormatter {
    
    //MARK: Properties
    var editingNumber:String
    let phoneSeperator:Character = "-"
    let phoneSeperatorOpen:Character = "("
    let phoneSeperatorClose:Character = ")"
    let maxLength = 12
    private var caretPos = 0
    
    init(editingNumber:String) {
        self.editingNumber = editingNumber
    }
    
    //MARK: Utility
    func count() -> Int {
        return editingNumber.count
    }
    
    /// Converts the string of the string to pure digit format XXXXXXXXXX
    /// - Parameter phoneString: String
    /// - Returns: The string with non digit characters removed
    public static func rawNumbers(_ phoneString:String) -> String {
        let components = phoneString.components(separatedBy: CharacterSet.decimalDigits.inverted).filter { !$0.isEmpty }
        return components.joined(separator: "")
    }
    
    public mutating func setRawIndex(of number:String, at range: Int, plus:Int) {
        var index = 0
        for i in 0..<range {
            if "0"..."9" ~= number[i..<i+1] {
                index += 1
            }
        }
        caretPos = index + plus
    }
    
    public func getFormattedIndex() -> Int {
        guard caretPos > 0 else { return 0 }
        var index = 0
        var trueIndex = 0
        for i in 0..<editingNumber.count {
            trueIndex += 1
            if "0"..."9" ~= editingNumber[i..<i+1] {
                index += 1
                if index == caretPos {
                    break
                }
            }
        }
        return trueIndex
    }
    
    
    /// Called when character is added at any index
    /// - parameter digit: Character inserted
    /// - parameter index: Int position where character is added
    
    mutating func insert(_ digit:Character, index:Int) {
        if index < editingNumber.count {
            editingNumber.insert(digit, at: editingNumber.index(editingNumber.startIndex, offsetBy: index))
        }
    }
    
    /// Format the editing phone number in (X )XXX-XXX-XXXX format
    public mutating func format() {
        editingNumber = PhoneFormatter.rawNumbers(editingNumber)
        guard editingNumber.count > 2 else { return }
        var offset = 0
        if editingNumber.starts(with: "1") {
            offset = 2
            insert(" ", index: 1)
        }
        guard editingNumber.count > 3 + offset else { return }
        insert(phoneSeperator, index: 3 + offset)
        guard editingNumber.count > 7 + offset else { return }
        insert(phoneSeperator, index: 7 + offset)
    }
    
    /// Format the editing phone number in # (###) ###-#### / (###) ###-#### format
    public mutating func formatChange() {
        editingNumber = PhoneFormatter.rawNumbers(editingNumber)
        guard editingNumber.count < 12,
            CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: editingNumber)) else { return }
        var offset = 0
        if editingNumber.starts(with: "1") {
            offset = 2
            insert(" ", index: 1)
        }
        guard (3 + offset)...(10 + offset) ~= editingNumber.count else { return }
        insert(phoneSeperatorOpen, index: 0 + offset)
        guard editingNumber.count > 4 + offset else { return }
        insert(phoneSeperatorClose, index: 4 + offset)
        insert(" ", index: 5 + offset)
        guard editingNumber.count > 9 + offset else { return }
        insert(phoneSeperator, index: 9 + offset)
    }
    
    /// Format the phone number in # (###) ###-#### / (###) ###-#### format
    /// - parameter number: The number to be formatted
    /// For example "13424342534" would change to "1 (342) 434-2534". If the string isn't a valid phone number using the regex used in `PhoneNumberValidator.isValidPhoneNumber()`, the string is returned unformatted
    public static func format(number: String) -> String {
        var phoneFormatter = PhoneFormatter(editingNumber: number)
        phoneFormatter.formatChange()
        return phoneFormatter.editingNumber
    }
}
