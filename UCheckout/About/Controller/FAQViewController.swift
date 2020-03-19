//
//  FAQViewController.swift
//  UCheckout
//
//  Created by Nilesh Jha on 05/11/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class FAQViewController: BaseViewController {
    
    
    @IBOutlet weak var menuButtonOutlet: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    var faqArray = [FAQ]()
    var category = String()
    let transiton = SlideInTransition()


    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
        self.title = category

        // Do any additional setup after loading the view.
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
    
    
    private func setTableView(){
        tableView.estimatedSectionHeaderHeight = 70
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        let headerNib = UINib.init(nibName: "QuestionSectionView", bundle: Bundle.main)
        tableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "QuestionSectionView")
        tableView.tableFooterView = UIView()
        
    }
    
    private func menuButtonClicked() {
        guard let menuViewController = UIStoryboard.home.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController else { return }
        
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        menuViewController.menuTableControllerProtocol = self
        present(menuViewController, animated: true)
    }
    
    @objc private func sectionDropDownButtonclicked(_ sender: UIButton) {
        if let isExpanded = faqArray[sender.tag].isExpanded , isExpanded {
           faqArray[sender.tag].isExpanded = false
        }
        else {
            faqArray[sender.tag].isExpanded = true
        }
        tableView.reloadSections(IndexSet(integer: sender.tag), with: .automatic)
        
    }
    
    @IBAction func menuButtonAction(_ sender: UIBarButtonItem)
    {
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

extension FAQViewController : UITableViewDataSource,UITableViewDelegate {
    
     func numberOfSections(in tableView: UITableView) -> Int {
        return faqArray.count
    }
    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let isExpanded = faqArray[section].isExpanded , isExpanded {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FAQAnswerTableViewCell", for: indexPath) as? FAQAnswerTableViewCell else {
            fatalError()
        }
        cell.faqAnswerLabel.text = faqArray[indexPath.section].answer ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "QuestionSectionView") as? QuestionSectionView else {
            fatalError()
        }
        if let isExpanded = faqArray[section].isExpanded , isExpanded {
            headerView.dropDownButton.setImage(UIImage(named: "upArrow"), for: .normal)
        }
        else {
             headerView.dropDownButton.setImage(UIImage(named: "downArrow"), for: .normal)
        }
        
        headerView.questionLabel.text = faqArray[section].question ?? ""
        headerView.dropDownButton.tag = section
        headerView.dropDownButton.addTarget(self, action: #selector(sectionDropDownButtonclicked(_:)), for: .touchUpInside)
        
        return headerView
    }
    

}
extension FAQViewController : MenuTableControllerProtocol {
    func menuClickedWithIndexpath(_ indexpath: IndexPath) {
        super.movetoControllerWithIndexpath(indexpath)
    }
    
    
    
}
extension FAQViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        return transiton
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        return transiton
    }
}
