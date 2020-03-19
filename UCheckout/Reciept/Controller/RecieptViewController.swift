//
//  RecieptViewController.swift
//  UCheckout
//
//  Created by i2i innovation on 06/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//
//

import UIKit

class RecieptViewController: UIViewController {
    
    
    @IBOutlet weak var recieptTableView: UITableView!
    
    
    
    var reciptData : RecieptData?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Receipt"
        registerTableView()
        
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
    
    private  func registerTableView(){
        
        
        recieptTableView.register(UINib(nibName: TableResuableIdenifier.RecieptTableViewCell, bundle: nil), forCellReuseIdentifier: TableResuableIdenifier.RecieptTableViewCell)
        recieptTableView.tableFooterView = UIView()
        recieptTableView.rowHeight = UITableView.automaticDimension
        recieptTableView.estimatedRowHeight = 70
        
        
        
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

extension RecieptViewController : UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableResuableIdenifier.RecieptHeaderTableViewCell, for: indexPath) as? RecieptHeaderTableViewCell else {
                fatalError()
            }
            if let recptData = reciptData {
                cell.populateCellData(recptData)
                
            }
            
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableResuableIdenifier.RecieptSuccessFlowTableViewCell, for: indexPath) as? RecieptSuccessFlowTableViewCell else {
                fatalError()
            }
            if let recptData = reciptData {
                cell.populateCellData(recptData)
                
            }
            
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableResuableIdenifier.ReciptBarCodeTableViewCell, for: indexPath) as? ReciptBarCodeTableViewCell else {
                fatalError()
            }
            if let recptData = reciptData {
                cell.populateCellData(recptData)
                
            }
            
            
            return cell
        case 3:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableResuableIdenifier.ReciptViewTableViewCell, for: indexPath) as? ReciptViewTableViewCell else {
                fatalError()
            }
            if let recpt = reciptData?.receipt {
                cell.receiptDetailsLabel.text = recpt
            }
            
            
            return cell
        case 4:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableResuableIdenifier.RecieptFooterTableViewCell, for: indexPath) as? RecieptFooterTableViewCell else {
                fatalError()
            }
            if let recptData = reciptData {
                cell.populateCellData(recptData)
                
            }
            
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableResuableIdenifier.RecieptHeaderTableViewCell, for: indexPath) as? RecieptHeaderTableViewCell else {
                fatalError()
            }
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

