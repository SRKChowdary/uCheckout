//
//  WebkitViewController.swift
//  UCheckout
//
//  Created by i2i innovation on 03/10/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit
import WebKit

class WebkitViewController: BaseViewController {
    
     @IBOutlet var wkWebView: WKWebView!
     var urlString : String?
    var screenTitle : String?
    
    
    let transiton = SlideInTransition()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        MBProgressIndicator.showIndicator(self.view)
        wkWebView.navigationDelegate = self
        loadWebkit()
      
       
        // Do any additional setup after loading the view.
    }
    
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
    
    private func loadWebkit(){
        guard let urlStr = urlString else {
            return
        }
        guard let url = URL(string: urlStr) else {
            return
        }
        let request = URLRequest(url: url)
        wkWebView.load(request)
        
        
    }
    
    private func updateUI(){
        let rightBtn = UIBarButtonItem(image: UIImage(named: "menuIcon"), style: .plain, target: self, action: #selector(menuButtonClicked))
        self.navigationItem.rightBarButtonItem = rightBtn
        self.title = screenTitle ?? ""
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
extension WebkitViewController : MenuTableControllerProtocol {
    func menuClickedWithIndexpath(_ indexpath: IndexPath) {
        super.movetoControllerWithIndexpath(indexpath)
    }
    
    
    
}
extension WebkitViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        return transiton
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        return transiton
    }
}

extension  WebkitViewController : WKNavigationDelegate,WKUIDelegate {
    
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
         MBProgressIndicator.hideIndicator(self.view)
        MBProgressIndicator.showIndicator(self.view)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        MBProgressIndicator.hideIndicator(self.view)
    }
    
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        MBProgressIndicator.hideIndicator(self.view)
    }
    
}
