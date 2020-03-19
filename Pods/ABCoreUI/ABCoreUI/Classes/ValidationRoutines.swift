//
//  ValidationRoutines.swift
//  ECommerce
//
//  Created by Ganesh Reddiar on 4/20/16.
//  Copyright © 2016 Albertsons. All rights reserved.
//

import Foundation

// MARK: TYPE ALIASES

/// Type alias to represent the output of the validation routines, returns a tuple with the result and the error text if it exists
public typealias ValidationResult = (isSuccess:Bool, text:String?)

/// Type alias for the validation routine, takes the text to validate and returns a ValidationResult Tuple
public typealias ValidationRoutine = (String) -> ValidationResult

/// Structure to handle validation of emails
public struct EmailValidator {
    
    /// Error messages
    static let errorEmailInvalid = "Please enter a valid email address."
    static let errorEmailEmpty = "Email is required."
    static let emailRegex = "[\\w._%+-]+@[\\w.-]+\\.[a-zA-Z]{2,}"
    
    
    /// Checks if the email is valid based on the email regex
    ///
    /// Email regex: `[\w._%+-]+@[\w.-]+\.[a-zA-Z]{2,}`
    /// - Parameter testString: String to be tested
    /// - Returns: tuple with success and the error text
    public static func isValidEmail(_ testString:String) -> ValidationResult {        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        if !emailTest.evaluate(with: testString) {
            return (false, errorEmailInvalid)
        }
        return (true, nil)
    }
    
    /// Checks if the email is empty or not
    /// - Parameter testString: String to be tested
    /// - Returns: tuple with success and the error text
    public static func checkLength (_ testString:String) -> ValidationResult {
        if testString.count == 0 {
            return (false, errorEmailEmpty)
        }
        return (true, nil)
    }
}

/// Structure to handle validation of passwords
///
/// In ABConfig class, you can change the min and max length of password validation by using `ABConfig.minPasswordLength` and `ABConfig.minPasswordLength` respectively
public struct PasswordValidator {
    
    static let errorPasswordLength = "Password must be %@-%@ characters long."
    static let errorPasswordSpecialCharacters = "Character < not allowed."
    static let passwordRegex = "^[^<]{%@,%@}$"
    
    /// Checks if the password has valid characters and is valid length
    ///
    /// Password regex:  `^[^<]{[ABConfig.minPasswordLength],[ABConfig.maxPasswordLength]}$`
    /// - Parameter testString: String to be tested
    /// - Returns: tuple with success and the error text
    static func isValidPassword(_ testString:String) -> ValidationResult {
        let minLength = ABConfig.minPasswordLength
        let maxLength = ABConfig.maxPasswordLength
        switch testString {
        case _ where (testString.count < minLength || testString.count > maxLength):
            return (false, String(format: errorPasswordLength, "\(minLength)", "\(maxLength)"))
        case _ where !NSPredicate(format:"SELF MATCHES %@", String(format: passwordRegex, "\(minLength)", "\(maxLength)")).evaluate(with: testString):
            return (false, errorPasswordSpecialCharacters)
        default:
            return (true, nil)
        }
    }
}

/// Structure to handle validation of credit card's CVVs
///
/// Has general methods for any type of card as well as one for Amex CVVs and other cards
struct CvvValidator {
    static let cvvRegex = "^\\d{3,4}$"
    static let cvvGeneralRegex = "^\\d{3}$"
    static let cvvAmexRegex = "^\\d{4}$"
    static let errorInvalidCVV = "Please enter a Valid CVV."
    
    /// Checks if the cvv is of valid length
    ///
    /// Length must be between 3 and 4
    /// - Parameter testString: String to be tested
    /// - Returns: tuple with success and the error text
    static func isValidLength(_ testString:String) -> ValidationResult {
        let cvvValidCheck = NSPredicate(format:"SELF MATCHES %@", cvvRegex)
        if !cvvValidCheck.evaluate(with: testString) {
            return (false, errorInvalidCVV)
        }
        return (true, nil)
    }
    
    /// Checks if the cvv is of valid length (for most card types)
    ///
    /// Length must be 3
    /// - Parameter testString: String to be tested
    /// - Returns: tuple with success and the error text
    static func isValidGeneralLength(_ testString:String) -> ValidationResult {
        let cvvValidCheck = NSPredicate(format:"SELF MATCHES %@", cvvGeneralRegex)
        if !cvvValidCheck.evaluate(with: testString) {
            return (false, errorInvalidCVV)
        }
        return (true, nil)
    }
    
    /// Checks if the cvv is of valid length (for American Express Cards)
    ///
    /// Length must be 4
    /// - Parameter testString: String to be tested
    /// - Returns: tuple with success and the error text
    static func isValidAmexLength(_ testString:String) -> ValidationResult {
        let cvvValidCheck = NSPredicate(format:"SELF MATCHES %@", cvvAmexRegex)
        if !cvvValidCheck.evaluate(with: testString) {
            return (false, errorInvalidCVV)
        }
        return (true, nil)
    }
}

/// Structure to handle validation of American zip codes
public struct ZipCodeValidator {
    
    static let zipCodeMaxLength         = 5
    static let zipCodeRegex             = "^\\d{5}$"
    static let error_zipcode_empty      = "Please enter a zip code."
    static let error_zipcode_invalid    = "Please enter a valid zip code."
    static let zipcode_invalid          = "00000"
    
    /// Checks if the zip code is valid
    ///
    /// Zip code regex: `^\d{5}$`
    /// - Parameter testString: String to be tested
    /// - Returns: tuple with success and the error text
    public static func isValidLength(_ testString:String) -> ValidationResult  {
        switch testString {
        case zipcode_invalid:
            return (false, error_zipcode_invalid)
        case _ where testString.count == 0:
            return (false, error_zipcode_empty)
        case _ where NSPredicate(format:"SELF MATCHES %@", zipCodeRegex).evaluate(with: testString):
            return (true, nil)
        default:
            return (false, error_zipcode_invalid)
        }
    }
}

/// Structure to handle validation of addresses
public struct AddressValidator {
    
    static let error_address_empty = "Address is required"
    static let error_address_invalid_characters = "Address contains invalid characters"
    static let address_regex = "^[\\w-\\/\\\\@., ]+$"
    static let secondary_address_regex = "^[\\w-\\/\\\\@., ]*$"
    
    /// Checks if the address is valid based on the address regex
    ///
    /// Address regex: `^[\w-\/\\@., ]+$`
    /// - Parameter testString: String to be tested
    /// - Returns: tuple with success and the error text
    public static func isValidAddress(_ testString:String) -> ValidationResult {
        switch testString {
        case _ where testString.count == 0:
            return (false, error_address_empty)
        case _ where NSPredicate(format:"SELF MATCHES %@", address_regex).evaluate(with: testString):
            return (true, nil)
        default:
            return (false, error_address_invalid_characters)
        }
    }
    
    /// Checks if the address is valid based on the address regex or if its empty
    ///
    /// Address regex: `^[\w-\/\\@., ]*$`
    /// - Parameter testString: String to be tested
    /// - Returns: tuple with success and the error text
    public static func isValidSeconaryAddress(_ testString:String) -> ValidationResult {
        let nameTest = NSPredicate(format:"SELF MATCHES %@", secondary_address_regex)
        if !nameTest.evaluate(with: testString) {
            return (false, error_address_invalid_characters)
        }
        return (true, nil)
    }
}

public struct PickerValidator {
    
    public static let error_value_needed = "Pick a value"
    /// Checks if the string is empty
    /// - Parameter testString: String to be tested
    /// - Returns: tuple with success and the error text
    public static func isValidLength(_ testString:String) -> ValidationResult {
        if testString.count > 0 {
            return (true, nil)
        }
        return (false, error_value_needed)
    }
}

/// Structure to handle validation of names
///
/// In ABConfig class, you can change the max length of names by using `ABConfig.maxFirstNameLength`, `ABConfig.maxMiddleNameLength`, `ABConfig.maxLastNameLength`
public struct NameValidator {
    
    public enum Name:String {
        case none = ""
        case first = "First "
        case last = "Last "
        case middle = "Middle "
    }
    
    static let name_empty = "Please enter a %@Name."
    static let name_length = "%@Name must be 2-%@ characters."
    static let name_regex = "^[A-Za-z-]{2,%@}$"
    static let name_invalid_characters = "%@Name contains invalid characters or white space."
    public static func checkEmpty(_ testObject:AnyObject?) -> ValidationResult {
        
        if let test = testObject as? String, (test.count > 0 ) {
            return (true, nil)
        }
        return (false, name_empty)
    }
    
    /// Checks if the name is of valid length and has valid characters
    ///
    /// Name regex: `^[A-Za-z-]{2,20}$`
    /// - Parameter testString: String to be tested
    /// - Returns: tuple with success and the error text
    public static func isValidName(_ testString:String) -> ValidationResult {
        return validateName(testString)
    }
    
    /// Checks if the name is of valid length and has valid characters
    ///
    /// Errors will specify this is the first name
    /// Name regex: `^[A-Za-z-]{2,[ABConfig.maxFirstNameLength]}$`
    /// - Parameter testString: String to be tested
    /// - Returns: tuple with success and the error text
    public static func isValidFirstName(_ testString:String) -> ValidationResult {
        return validateName(testString, nameType: .first, nameLength: ABConfig.maxFirstNameLength)
    }
    
    /// Checks if the name is of valid length and has valid characters
    ///
    /// Errors will specify this is the last name
    /// Name regex: `^[A-Za-z-]{2,[ABConfig.maxLastNameLength]}$`
    /// - Parameter testString: String to be tested
    /// - Returns: tuple with success and the error text
    public static func isValidLastName(_ testString:String) -> ValidationResult {
        return validateName(testString, nameType: .last, nameLength: ABConfig.maxLastNameLength)
    }
    
    /// Checks if the name is of valid length and has valid characters
    ///
    /// Errors will specify this is the middle name
    /// Name regex: `^[A-Za-z-]{2,[ABConfig.maxMiddleNameLength]}$`
    /// - Parameter testString: String to be tested
    /// - Returns: tuple with success and the error text
    public static func isValidMiddleName(_ testString:String) -> ValidationResult {
        return validateName(testString, nameType: .middle, nameLength: ABConfig.maxMiddleNameLength)
    }
    
    /// Checks if the name is of valid length and has valid characters
    ///
    /// Name regex: `^[A-Za-z-]{2,[nameLength]}$`
    /// - Parameter testString: String to be tested
    /// - Parameter nameType: The type of name to display for error cases
    /// - Parameter nameLength: maximum amount of characters a name can have, default is 20. The error will specify the length as well
    /// - Returns: tuple with success and the error text
    public static func validateName(_ testString:String, nameType: NameValidator.Name = .none, nameLength:Int = 20) -> ValidationResult {
        switch testString {
        case _ where testString.isEmpty:
            return (false, String(format: name_empty, nameType.rawValue))
        case _ where (testString.count < 2 || testString.count > nameLength):
            return (false, String(format: name_length, nameType.rawValue, "\(nameLength)"))
        case _ where NSPredicate(format:"SELF MATCHES %@", String(format: name_regex, "\(nameLength)")).evaluate(with: testString):
            return (true, nil)
        default:
            return (false, String(format: name_invalid_characters, nameType.rawValue))
        }
    }
}


/// Structure to handle validation of comments in feedback
public struct CommentsValidator {
    static let comments_empty = "Please enter a Comment."
    static let comments_length = "Comment must be 2-1000 characters."
    static let comments_regex = "^[^`~!$%\\^+=\\{\\}\\[\\]/\\\\|:;\"']{2,1000}$"
    static let comments_invalid_characters = "Comments contains invalid characters."
    
    /// Checks if the comments are of valid length and has valid characters
    ///
    /// Comments regex: `^[^`~!$%\^+=\{\}\[\]\/\\|:;"']{2,1000}$`
    /// - Parameter testString: String to be tested
    /// - Returns: tuple with success and the error text
    public static func isValidComment(_ testString:String) -> ValidationResult  {
        switch testString {
        case _ where testString.count == 0:
            return (false, comments_empty)
        case _ where (testString.count < 2 || testString.count > 1000):
            return (false, comments_length)
        case _ where NSPredicate(format:"SELF MATCHES %@", comments_regex).evaluate(with: testString):
            return (true, nil)
        default:
            return (false, comments_invalid_characters)
        }
    }
}

extension String {
    subscript (bounds: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: bounds.lowerBound)
        let end = index(startIndex, offsetBy: bounds.upperBound)
        return String(self[start..<end])
    }
    private func getIndex(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
}

