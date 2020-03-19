//
//  GeneralHelpViewController.swift
//  UCheckout
//
//  Created by i2i Innovation on 10/24/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class GeneralHelpViewController: BaseViewController {
    
    // Outlets :

    @IBOutlet weak var menuButtonOutlet: UIBarButtonItem!
    
    
    // Variable Declarations :
    
    let transiton = SlideInTransition()
    

    // IB Actions :
    
    @IBAction func menuButtonAction(_ sender: UIBarButtonItem)
    {
        menuButtonClicked()
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)
        if let topItem = self.navigationController?.navigationBar.topItem
        {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationItem.setHidesBackButton(false, animated: true)
        
    }
    
    override func gestureClicked() {
        super.gestureClicked()
        menuButtonClicked()
    }
    
    
    // Private Methods :
    
//    @objc func backButtonClicked() {
//        self.navigationController?.popViewController(animated: true)
//    }
 
    
    private func menuButtonClicked() {
        guard let menuViewController = UIStoryboard.home.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController else { return }
        
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        menuViewController.menuTableControllerProtocol = self
        present(menuViewController, animated: true)
    }
    

}


extension GeneralHelpViewController : MenuTableControllerProtocol {
    func menuClickedWithIndexpath(_ indexpath: IndexPath) {
        super.movetoControllerWithIndexpath(indexpath)
    }
    
    
    
}
extension GeneralHelpViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        return transiton
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        return transiton
    }
}

