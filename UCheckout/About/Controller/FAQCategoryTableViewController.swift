//
//  FAQCategoryTableViewController.swift
//  UCheckout
//
//  Created by Nilesh Jha on 06/11/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class FAQCategoryTableViewController: BaseViewController {
    
    
    
    // MARK: - IB Outlet
    @IBOutlet weak var menuButtonOutlet: UIBarButtonItem!
     @IBOutlet weak var tableView: UITableView!

    
    // MARK: - Variable Declartion
    var fAQViewModel = FAQViewModel()
    let transiton = SlideInTransition()

    var categoryArray = [FAQCategoryModel]()
    
    
      // MARK: - View Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
         self.tableView.tableFooterView = UIView()
        self.title = "FAQ"
        fetchFAQData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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
    
   
    
      // MARK: - Private Methods
    
    private func menuButtonClicked() {
        guard let menuViewController = UIStoryboard.home.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController else { return }
        
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        menuViewController.menuTableControllerProtocol = self
        present(menuViewController, animated: true)
    }
    
    private func fetchFAQData(){
        let hardCodeURL = "https://retail-api.azure-api.net/retailoperations/faqs?app=ucheckout&banner=general"

        fAQViewModel.getAllFAQs(strUrl: hardCodeURL, parentViewController: self) { (success, response, message) in
            DispatchQueue.main.async {
                if success {
                    if let response = response {
                        if let ack = response.ack {
                            if ack == "0" {
                                if let faqArray = response.faqs {
                                    let categoryDict = Dictionary(grouping: faqArray) {$0.category}
                                    for (key,value) in categoryDict {
                                        let categoryObj = FAQCategoryModel()
                                        categoryObj.category = key
                                        categoryObj.faq = value
                                        self.categoryArray.append(categoryObj)
                                    }
                                    
                                    self.tableView.reloadData()
                                    

                                }
                                
                            }
                            else if ack == "1"{
                                 SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: message! , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                            }
                        }
                    }
                }
                else {
                    SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: message! , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                }
            }
            
        }
    }
    
      // MARK: - IB Action Methods
    
    @IBAction func menuButtonAction(_ sender: UIBarButtonItem)
    {
        menuButtonClicked()
    }

    // MARK: - Table view data source

   
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension FAQCategoryTableViewController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 68
    }
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.categoryArray.count
    }
    
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FAQCategoryTableViewCell", for: indexPath) as? FAQCategoryTableViewCell else {
            fatalError()
        }
        cell.faqCategoryLabel.text = categoryArray[indexPath.row].category ?? ""
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let scanVC = UIStoryboard.faq.instantiateViewController(withIdentifier: "FAQViewController") as? FAQViewController {
            if let faqArray  = categoryArray[indexPath.row].faq {
                 scanVC.faqArray = faqArray
            }
            scanVC.category = categoryArray[indexPath.row].category ?? ""
           
            self.navigationController?.pushViewController(scanVC, animated: true)
        }
    }
}

extension FAQCategoryTableViewController : MenuTableControllerProtocol {
    func menuClickedWithIndexpath(_ indexpath: IndexPath) {
        super.movetoControllerWithIndexpath(indexpath)
    }
    
    
    
}
extension FAQCategoryTableViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        return transiton
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        return transiton
    }
}

