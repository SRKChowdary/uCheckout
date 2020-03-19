//
//  TermsAndConditonViewController.swift
//  UCheckout
//
//  Created by i2i innovation on 10/10/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class TermsAndConditonViewController: BaseViewController {
    
    
    let transiton = SlideInTransition()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //updateUI()

        // Do any additional setup after loading the view.
    }
    
//    private func updateUI(){
//        let rightBtn = UIBarButtonItem(image: UIImage(named: "menuIcon"), style: .plain, target: self, action: #selector(menuButtonClicked))
//        self.navigationItem.rightBarButtonItem = rightBtn
//        self.title = "Terms And Conditions"
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)
        if let topItem = self.navigationController?.navigationBar.topItem {
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
    
    @objc private func menuButtonClicked() {
        guard let menuViewController = UIStoryboard.home.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController else { return }
        
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        menuViewController.menuTableControllerProtocol = self
        present(menuViewController, animated: true)
    }
    
    // MARK :- IBActions :
    
    
    @IBAction func menuButtonAction(_ sender: UIBarButtonItem) {
        menuButtonClicked()
    }
    

}
extension TermsAndConditonViewController : MenuTableControllerProtocol {
    func menuClickedWithIndexpath(_ indexpath: IndexPath) {
        super.movetoControllerWithIndexpath(indexpath)
    }
    
    
    
}
extension TermsAndConditonViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        return transiton
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        return transiton
    }
}
