//
//  BaseLoginViewController.swift
//  ABAuthenticator
//
//  Created by Michelle Louise Bosque on 10/2/19.
//

import Foundation

public class BaseLoginViewController: UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        registerViewWithKeyboard()
        buildNavigationStyle()
        // To hide the bar button item: 
        navigationItem.leftBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem?.tintColor = UIColor.clear
    }
    
    func buildNavigationStyle() {
        self.title = LogInConstants.Label.forgotPassword
        
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.barTintColor = LogInStyle.Color.defaultScheme
        navigationController?.navigationBar.titleTextAttributes = LogInStyle.Attribute.navigationBar
//
//        if hidesBarButton() {
//            navigationItem.hidesBackButton = true
//            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
//        }
        
        customStyle()
    }
    
    /// Child view controllers can override this function. Place screen configurations here
    func customStyle() {
    }
    
    /// Child view controllers can override this function. Default is false and will show the default back icon. If set to true, will show Cancel button with dismiss action
    func hidesBarButton() -> Bool {
        return false
    }
    
//    @objc func dismissView() {
//        self.dismiss(animated: true, completion: nil)
//
//
//    }
}
