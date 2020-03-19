//
//  MenuTableViewController.swift
//  UCheckout
//
//  Created by i2i innovation on 09/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

protocol MenuTableControllerProtocol {
    func menuClickedWithIndexpath(_ indexpath : IndexPath)
}

class MenuTableViewController: UITableViewController {
    
    var menuTableViewModel = MenuTableViewModel()
    var menuModelArray = [MenuModel]()
    var menuTableControllerProtocol : MenuTableControllerProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMenuScreenData()
        setSwiipeGesture()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    private func getMenuScreenData(){
        menuModelArray = menuTableViewModel.getMenuData()
        tableView.reloadData()
    }
    
    private func setSwiipeGesture(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .left
        self.view!.addGestureRecognizer(swipeRight)
        
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer)  {
        switch gesture.direction {
        case UISwipeGestureRecognizer.Direction.left:
            dismiss(animated: true, completion: nil)
            
        default:
            break
        }
        
    }
    
   
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuModelArray.count + 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
             return 150
        }
        else {
            return 54
        }
    }
    
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            
            guard let headerCell = tableView.dequeueReusableCell(withIdentifier: "MenuHeaderTableViewCell") as? MenuHeaderTableViewCell else {
                fatalError()
            }
            headerCell.updateUserInfoo()
            return headerCell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableViewCell", for: indexPath) as? MenuTableViewCell else  {
                fatalError()
            }
            let menuItem = menuModelArray[indexPath.row - 1]
           cell.populateData(menuItem)
            return cell
        }
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) { [weak self] in
            switch indexPath.row
            {
            case 0 :break
             
            default: self?.menuTableControllerProtocol?.menuClickedWithIndexpath(indexPath)
                
            }
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
