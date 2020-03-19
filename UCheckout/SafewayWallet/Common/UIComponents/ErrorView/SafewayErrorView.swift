//
//  SafewayErrorView.swift
//  UCheckout
//
//  Created by 1521398 on 04/09/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import UIKit

@IBDesignable public class SafewayErrorView: BaseReusableView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    required override public init(frame: CGRect) {
        super.init(frame: frame) // calls designated initializer
        self.backgroundColor = .white
        self.commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func commonInit() {
        updateConstraints()
    }
    
    override public func updateConstraints() {
        super.updateConstraints()
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0).isActive = true
        self.widthAnchor.constraint(equalToConstant: 325).isActive = true
        self.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        self.heightAnchor.constraint(equalToConstant: 170)
    }
    
    func createPopOverController(sender: UIView) -> UIViewController {
        let controller = UIViewController()
        controller.preferredContentSize = CGSize(width: 325, height: 170)
        controller.modalPresentationStyle = UIModalPresentationStyle.popover
        controller.view.addSubview(self)
        let popController = controller.popoverPresentationController
        popController?.permittedArrowDirections = .any
        popController?.sourceView = sender
        popController?.sourceRect = CGRect(x: 60, y: sender.bounds.origin.y - 5, width: sender.bounds.size.width, height: sender.bounds.size.height)
        popController?.presentedView?.layer.shadowColor = UIColor.clear.cgColor
        popController?.backgroundColor = .white
        return controller
    }

}
