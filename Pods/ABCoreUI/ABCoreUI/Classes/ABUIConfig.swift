//
//  ABUIConfig.swift
//  ABCoreUI
//
//  Created by Jonathan Gascoigne on 9/5/19.
//

import Foundation

public struct ABStyle {
    static var linkText: UIColor? {
        get {
            return linkTextColor ?? UIApplication.shared.delegate?.window??.tintColor
        }
    }
    /// The color used for Buttons without backgrounds (ie UIBarButtons)
    public static var linkTextColor:UIColor?
}

public struct ABConfig {
    public static var maxPasswordLength = 40
    public static var minPasswordLength = 8
    public static var maxFirstNameLength = 20
    public static var maxLastNameLength = 25
    public static var maxMiddleNameLength = 20
    public static var maxStepperValue = 99
}
