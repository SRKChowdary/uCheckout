//
//  UIStoryboardExtension.swift
//  UCheckout
//
//  Created by i2i innovation on 11/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation
import UIKit



struct Storyboard {
    static let home = "Home"
    static let scan = "Scan"
    static let onBoarding = "OnBoarding"
    static let authentification = "Authentification"
    static let scanHelp = "ScanHelp"
    static let item = "Item"
    static let cart = "Cart"
    static let plu = "PLU"
    static let bag = "Bag"
    static let about = "About"
    static let reciept = "Reciept"
    static let terms = "Terms"
    static let contact = "Contact"
    static let account = "Account"
    static let wallet = "SafewayWallet"
    static let checkout = "Checkout"
    static let helpTutorials = "Help"
    static let feedback = "Feedback"
    static let faq = "FAQ"
    static let signIn = "signIn"
    static let applePayAdded = "applePay"
    
    
}


extension UIStoryboard {
    class var applePayAdded : UIStoryboard{
        return UIStoryboard(name: Storyboard.applePayAdded, bundle: nil)
    }
     class var home: UIStoryboard {
        return UIStoryboard(name: Storyboard.home, bundle: nil)
    }
    class var scan: UIStoryboard {
        return UIStoryboard(name: Storyboard.scan, bundle: nil)
    }
     class var onBoarding: UIStoryboard {
        return UIStoryboard(name: Storyboard.onBoarding, bundle: nil)
    }
     class var authentification: UIStoryboard {
        return UIStoryboard(name: Storyboard.authentification, bundle: nil)
    }
    class var signIn : UIStoryboard
    {
        return UIStoryboard(name: Storyboard.signIn, bundle: nil)
    }
    class var scanHelp: UIStoryboard {
        return UIStoryboard(name: Storyboard.scanHelp, bundle: nil)
    }
    class var item: UIStoryboard {
        return UIStoryboard(name: Storyboard.item, bundle: nil)
    }
    class var cart: UIStoryboard {
        return UIStoryboard(name: Storyboard.cart, bundle: nil)
    }
    class var plu: UIStoryboard {
        return UIStoryboard(name: Storyboard.plu, bundle: nil)
    }
    class var bag: UIStoryboard {
        return UIStoryboard(name: Storyboard.bag, bundle: nil)
    }
    class var about : UIStoryboard {
        return UIStoryboard(name: Storyboard.about, bundle: nil)
    }
    class var reciept : UIStoryboard {
        return UIStoryboard(name: Storyboard.reciept, bundle: nil)
    }
    
    class var terms : UIStoryboard {
        return UIStoryboard(name: Storyboard.terms, bundle: nil)

    }
    class var contact : UIStoryboard {
        return UIStoryboard(name: Storyboard.contact, bundle: nil)
        
    }
    
    class var account : UIStoryboard {
        return UIStoryboard(name: Storyboard.account, bundle: nil)
    }
    // Pranav Bug Fix
    class var wallet : UIStoryboard {
        return UIStoryboard(name: Storyboard.wallet, bundle: nil)
    }
    class var checkout : UIStoryboard {
        return UIStoryboard(name: Storyboard.checkout, bundle: nil)
    }
    
    class var help : UIStoryboard {
        return UIStoryboard(name: Storyboard.helpTutorials, bundle: nil)
    }
    
    class var feedback : UIStoryboard {
        return UIStoryboard(name: Storyboard.feedback, bundle: nil)
    }
    class var faq : UIStoryboard {
        return UIStoryboard(name: Storyboard.faq, bundle: nil)
    }
    
    
    
}
