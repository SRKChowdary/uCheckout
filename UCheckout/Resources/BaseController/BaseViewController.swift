//
//  BaseViewController.swift
//  UCheckout
//
//  Created by i2i innovation on 09/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         UIApplication.shared.statusBarView?.backgroundColor = GlobalColor.KAppRedColor
        navigationController?.navigationBar.barStyle = .black
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        setSwiipeGesture()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
         self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    private func setSwiipeGesture(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view!.addGestureRecognizer(swipeRight)
        
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer)  {
        switch gesture.direction {
        case UISwipeGestureRecognizer.Direction.right:
             gestureClicked()
            
        default:
            break
        }
        
    }
    
    internal func gestureClicked(){
        
    }
    
    func movetoControllerWithIndexpath(_ indexpath: IndexPath) {
        switch indexpath.row {
        case 1:moveToHomeMenu()
        case 2 : moveToCartMenu()
        case 3:moveToAccount()
        case 4 : movetoSafewayWallet()
        case 5: moveToRecieptMenu()
        case 6 : moveToAboutMenu()
        case 7:logOut()
            
        default:
            break
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension BaseViewController {
    
    
    func moveToAboutMenu(){
        var isFound = false
        if let vcArray = self.navigationController?.viewControllers , vcArray.count != 0{
            for item in vcArray {
                if item.isKind(of: AboutBaseViewController.self) {
                    isFound = true
                    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                        navigationController.popToViewController(item, animated: true)
                        
                    }
                }
            }
        }
        if !isFound {
            if let scanVC = UIStoryboard.about.instantiateViewController(withIdentifier: "AboutBaseViewController") as? AboutBaseViewController {
                if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                    navigationController.pushViewController(scanVC, animated: true)
                }
            }
        }
    }
    
    func moveToCartMenu(){
        var isFound = false
        if let vcArray = self.navigationController?.viewControllers , vcArray.count != 0{
            for item in vcArray {
                if item.isKind(of: CartBaseViewController.self) {
                    isFound = true
                    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                        navigationController.popToViewController(item, animated: true)
                        
                    }
                }
            }
        }
        if !isFound {
            if let scanVC = UIStoryboard.cart.instantiateViewController(withIdentifier: "CartBaseViewController") as? CartBaseViewController {
                if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                    navigationController.pushViewController(scanVC, animated: true)
                    
                }
            }
        }
    }
    
    func moveToRecieptMenu(){
        var isFound = false
        if let vcArray = self.navigationController?.viewControllers , vcArray.count != 0{
            for item in vcArray {
                if item.isKind(of: RecieptBaseViewController.self) {
                    isFound = true
                    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                        navigationController.popToViewController(item, animated: true)
                        
                    }
                }
            }
        }
        if !isFound {
            if let scanVC = UIStoryboard.reciept.instantiateViewController(withIdentifier: "RecieptBaseViewController") as? RecieptBaseViewController {
                if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                    navigationController.pushViewController(scanVC, animated: true)
                    
                }
            }
        }
    }
    func moveToHomeMenu(){
        var isFound = false
        if let vcArray = self.navigationController?.viewControllers , vcArray.count != 0{
            for item in vcArray {
                if item.isKind(of: HomeViewController.self) {
                    isFound = true
                    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                        navigationController.popToViewController(item, animated: true)
                        
                    }
                }
            }
        }
        if !isFound {
            if let scanVC = UIStoryboard.home.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                    navigationController.pushViewController(scanVC, animated: true)
                    
                }
            }
        }
    }
    
    func logOut(){
        // Pranav Bug Fix
        let alert = UIAlertController(title: "Logout", message: "Are you sure if you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            if let scanVC = UIStoryboard.authentification.instantiateViewController(withIdentifier: "LoginSDKViewController") as? LoginSDKViewController {
                LocalDataStore.signoutUser()
                let navController = UINavigationController(rootViewController: scanVC)
                UIApplication.shared.keyWindow?.rootViewController = navController
                
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in

        }))

        self.present(alert, animated: true, completion: nil)
    }
    
    func movetoSafewayWallet(){
        let vc = SafewayWalletListRouter.createModule()
         if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            navigationController.present(vc, animated: true, completion: nil)
        }
    }
    
    func moveToAccount() {
        var isFound = false
        if let vcArray = self.navigationController?.viewControllers , vcArray.count != 0{
            for item in vcArray {
                if item.isKind(of: AccountBasViewController.self) {
                    isFound = true
                    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                        navigationController.popToViewController(item, animated: true)

                    }
                }
            }
        }
        if !isFound {
            if let scanVC = UIStoryboard.account.instantiateViewController(withIdentifier: "AccountBasViewController") as? AccountBasViewController {
                if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                    navigationController.pushViewController(scanVC, animated: true)

                }
            }
        }


    }
    
   
    
    
}


