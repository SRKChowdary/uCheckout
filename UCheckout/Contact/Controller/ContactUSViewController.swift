//
//  ContactUSViewController.swift
//  UCheckout
//
//  Created by i2i Innovation on 06/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class ContactUSViewController: BaseViewController {
    
    
    //MARK:- Outlets :
    
    @IBOutlet weak var callUsButtonOutlet: UIButton!
    
    
    let transiton = SlideInTransition()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        callUsButtonOutlet.isHidden = true
        callUsButtonOutlet.isUserInteractionEnabled = false

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationItem.setHidesBackButton(false, animated: false)
        
        
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
    
    private func menuButtonClicked() {
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
    
    
    @IBAction func callUsButtonAction(_ sender: UIButton) {
        
    }
    
    
    @IBAction func emailButtonAction(_ sender: UIButton) {
        let appURL = URL(string: "mailto:ucheckout@albertsons.com")!
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(appURL as URL, options: [:], completionHandler: nil)
        }
        else {
            UIApplication.shared.openURL(appURL as URL)
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


extension ContactUSViewController : MenuTableControllerProtocol {
    func menuClickedWithIndexpath(_ indexpath: IndexPath) {
         super.movetoControllerWithIndexpath(indexpath)
    }
    
    
    
}
extension ContactUSViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        return transiton
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        return transiton
    }
}

