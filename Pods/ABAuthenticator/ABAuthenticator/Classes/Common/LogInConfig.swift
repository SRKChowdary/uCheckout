//
//  LogInConfig.swift
//  ABAuthenticator
//
//  Created by Michelle Louise Bosque on 9/30/19.
//

import Foundation

public protocol LogInConfiguration  {
    var banner: String? {get}
    var bannerImage: UIImage? {get}
    var createAccountHeaderTitle: String? {get}
    var scheme: UIColor? {get}
}

struct LogInStyle {
    struct Color {
        static let defaultScheme = #colorLiteral(red: 0.8666666667, green: 0.1176470588, blue: 0.1450980392, alpha: 1)
    }
    
    struct Attribute {
        static let link: [NSAttributedString.Key: Any] =
            [.font: UIFont.systemFont(ofSize: 15.0, weight: .regular),
             .underlineStyle: NSUnderlineStyle.single.rawValue]
        static let button: [NSAttributedString.Key: Any] =
            [.font: UIFont.systemFont(ofSize: 13.0, weight: .bold),
             .foregroundColor: UIColor.white]
        static let indicator: [NSAttributedString.Key: Any] =
            [.font: UIFont.systemFont(ofSize: 13.0, weight: .bold),
             .foregroundColor: UIColor.gray]
        static let header: [NSAttributedString.Key: Any] =
            [.font: UIFont.systemFont(ofSize: 24.0, weight: .regular),
             .foregroundColor: #colorLiteral(red: 0.3664600253, green: 0.3623583317, blue: 0.3663590252, alpha: 1)]
        static let text: [NSAttributedString.Key: Any] =
            [.font: UIFont.systemFont(ofSize: 18.0, weight: .regular),
             .foregroundColor: #colorLiteral(red: 0.3664600253, green: 0.3623583317, blue: 0.3663590252, alpha: 1)]
        static let subtext: [NSAttributedString.Key: Any] =
            [.font: UIFont.systemFont(ofSize: 14.0, weight: .regular),
             .foregroundColor: #colorLiteral(red: 0.3664600253, green: 0.3623583317, blue: 0.3663590252, alpha: 1)]
        static let navigationBar: [NSAttributedString.Key: Any] =
            [.foregroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)]

    }
}

struct LogInConstants {
    struct Label {
        static let signIn = "Sign In"
        static let submit = "SUBMIT"
        static let email = "Email"
        static let emailAddress = "Email Address"
        static let password = "Password"
        static let forgotPassword = "Forgot Password"
        static let createAccount = "Create Account"
        static let signingIn = "SIGNING IN"
        static let onlineOrdering = "New to Online Ordering?"
        static let forgotPasswordSubtext = "Please enter the email address linked to your account."
    }
}
