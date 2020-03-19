//
//  UIButtonExtension.swift
//  UCheckout
//
//  Created by i2i innovation on 03/10/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation

extension UIButton {
    func underlineText() {
        guard let title = title(for: .normal) else { return }
        
        let titleString = NSMutableAttributedString(string: title)
        titleString.addAttribute(
            .underlineStyle,
            value: NSUnderlineStyle.single.rawValue,
            range: NSRange(location: 0, length: title.count)
        )
        setAttributedTitle(titleString, for: .normal)
    }
}
