//
//  ValueFormatter.swift
//  UCheckout
//
//  Created by 1521398 on 02/09/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import Foundation
public class ValueFormatter {
    static func formatExpirationDate(date: String) -> String {
        let maxDateCharacter = 5
        let validInput = "0123456789/"
        let cs = NSCharacterSet(charactersIn: validInput).inverted
        var expirationDate = date.components(separatedBy: cs).joined(separator: "")
        if expirationDate.count > maxDateCharacter || expirationDate.last == "/" {
            expirationDate.removeLast()
        }
        if expirationDate.isEmpty || expirationDate.count == maxDateCharacter {
            return expirationDate
        }
        let dateNumbers = expirationDate.replacingOccurrences(of: "/", with: "")
        var result = ""
        var formatCount: Int = 0
        for number in dateNumbers {
            result = "\(result)\(number)"
            formatCount += 1
            if (formatCount == 2) && (formatCount != dateNumbers.count) {
                result = "\(result)/"
            }
        }
        return result
    }
    
    static func formatCreditCard(cardNumber : String) -> String {
        let validInput = "0123456789"
        let cs = NSCharacterSet(charactersIn: validInput).inverted
        let cardNumber = cardNumber.components(separatedBy: cs).joined(separator: "")
        let trimmedString = cardNumber.components(separatedBy: .whitespaces).joined()
        let arrOfCharacters = Array(trimmedString)
        var modifiedCreditCardString = ""
        if(arrOfCharacters.count > 0) {
            for i in 0...arrOfCharacters.count-1 {
                modifiedCreditCardString.append(arrOfCharacters[i])
                if((i+1) % 4 == 0 && i+1 != arrOfCharacters.count){
                    modifiedCreditCardString.append(" ")
                }
            }
        }
        return modifiedCreditCardString
    }
    
    static func formatNumber(text: String) -> String {
        let validInput = "0123456789"
        let cs = NSCharacterSet(charactersIn: validInput).inverted
        let number = text.components(separatedBy: cs).joined(separator: "")
        return number.components(separatedBy: .whitespaces).joined()
    }
}
