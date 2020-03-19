//
//  RecieptBaseViewController.swift
//  UCheckout
//
//  Created by i2i innovation on 05/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class RecieptBaseViewController: BaseViewController {
    
    
    @IBOutlet weak var recieptTableView: UITableView!
    
    
    
    let transiton = SlideInTransition()
    var recieptViewModel = RecieptViewModel()
    var recieptArray :[RecieptData]?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        getRecipetData()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
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
    
    private  func registerTableView(){
        
        
        recieptTableView.register(UINib(nibName: TableResuableIdenifier.RecieptTableViewCell, bundle: nil), forCellReuseIdentifier: TableResuableIdenifier.RecieptTableViewCell)
        recieptTableView.register(UINib(nibName: TableResuableIdenifier.RecentRecieptTableViewCell, bundle: nil), forCellReuseIdentifier: TableResuableIdenifier.RecentRecieptTableViewCell)
        recieptTableView.tableFooterView = UIView()
        recieptTableView.rowHeight = UITableView.automaticDimension
        recieptTableView.estimatedRowHeight = 70
        
        
        
    }
    
    
    
    private func getRecipetData(){
        recieptViewModel.getRecieptHistory(strUrl: UcheckoutManager.getCompleteURl("/getReceiptHistory"), parentViewController: self) { (success, receipetDataArray, message) in
            DispatchQueue.main.async {
                if success {
                    self.recieptTableView.dataSource = self
                    if let response = receipetDataArray {
                        if let ack = response.ack {
                            if ack == "0" {
                                
                                if let recpitData = response.data {
                                    self.recieptArray = recpitData
                                }
                                self.recieptTableView.reloadData()

                                
                                
                            }
                            else if ack == "1"{
                                if let message = response.messsage {
                                   SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: message , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                                }
                            }
                        }
                        else {
                        }
                    }
                }
                else {
                    SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: message! , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                }
            }
        }
        
    }
    
    @IBAction func menuButtonAction(_ sender: UIButton) {
        
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

extension RecieptBaseViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let recptArray = recieptArray {
            return recptArray.count
        }
        else {
            recieptTableView.isHidden = true
            return 0
    
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let shared = UcheckoutSingleton.shared
        if let value = shared.isInStoreRegion , value == true {
            if let transactionCompleteAt = recieptArray?[indexPath.row].receiptJSON?.transactionInfo?.transactionCompleteAt {
                if let reciptDate = transactionCompleteAt.toDate() {
                    if reciptDate.isTimeDifference1hr(Date()) {
                        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableResuableIdenifier.RecentRecieptTableViewCell, for: indexPath) as? RecentRecieptTableViewCell else {
                            fatalError()
                        }
                        if let item = recieptArray?[indexPath.row] {
                            cell.populateData(item)
                            
                        }
                        return cell
                    }
                }
                
            }
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableResuableIdenifier.RecieptTableViewCell, for: indexPath) as? RecieptTableViewCell else {
            fatalError()
        }
        if let item = recieptArray?[indexPath.row] {
            cell.populateData(item)
            
        }
        
        return cell
       
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let recieptVC = UIStoryboard.reciept.instantiateViewController(withIdentifier: "RecieptViewController") as? RecieptViewController {
            recieptVC.reciptData = self.recieptArray?[indexPath.row]
            self.navigationController?.pushViewController(recieptVC, animated: true)
        }
    }
    
    
}



extension RecieptBaseViewController : MenuTableControllerProtocol {
    func menuClickedWithIndexpath(_ indexpath: IndexPath) {
         super.movetoControllerWithIndexpath(indexpath)
    }
    
    
    
}
extension RecieptBaseViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        return transiton
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        return transiton
    }
}

