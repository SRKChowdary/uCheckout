//
//  GBViewController.swift
//  UCheckout
//
//  Created by i2i innovation on 19/08/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class GBViewController: UIViewController {
    var didDismiss: (() -> Void)?
    override func dismiss(animated flag: Bool, completion: (() -> Void)?)
    {
        super.dismiss(animated: flag, completion:completion)
        didDismiss?()
    }
    override var prefersStatusBarHidden: Bool {
        return true
    }
}

class GlobalPresenter {
    var globalWindow: UIWindow?
    static let shared = GlobalPresenter()
    
    private init() {
    }
    
    func present(controller: UIViewController) {
        globalWindow = UIWindow(frame: UIScreen.main.bounds)
        let root = GBViewController()
        root.didDismiss = {
            self.globalWindow?.resignKey()
            self.globalWindow = nil
        }
        globalWindow!.rootViewController = root
        globalWindow!.windowLevel = UIWindow.Level.alert + 1
        globalWindow!.makeKeyAndVisible()
        globalWindow!.rootViewController?.present(controller, animated: true, completion: nil)
    }
}
