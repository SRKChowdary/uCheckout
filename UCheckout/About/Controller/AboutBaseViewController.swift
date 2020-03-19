//
//  AboutBaseViewController.swift
//  UCheckout
//
//  Created by i2i innovation on 05/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class AboutBaseViewController: BaseViewController {
    
    @IBOutlet weak var bottomFooterLaebl: UILabel!
    
    
    let transiton = SlideInTransition()


    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

        // Do any additional setup after loading the view.
    }
    
    private func updateUI(){
        bottomFooterLaebl.text = "Safeway U checkout for iPhone Version: \(UIDevice().appShortVersion) © 2019 Albertsons Companies, Inc."
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    @IBAction func menuButtonAction(_ sender: UIBarButtonItem) {
        
        guard let menuViewController = UIStoryboard.home.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController else { return }
        
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        menuViewController.menuTableControllerProtocol = self
        present(menuViewController, animated: true)
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



extension AboutBaseViewController : MenuTableControllerProtocol {
    func menuClickedWithIndexpath(_ indexpath: IndexPath) {
         super.movetoControllerWithIndexpath(indexpath)
    }
    
    
    
}
extension AboutBaseViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        return transiton
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        return transiton
    }
}
