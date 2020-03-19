//
//  TermsTableViewController.swift
//  UCheckout
//
//  Created by i2i Innovation on 05/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class TermsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        self.tableView.delegate = self


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          if indexPath.section == 1 && indexPath.row == 3 {
            if let scanVC = UIStoryboard.about.instantiateViewController(withIdentifier: "ThirdPartyViewController") as? ThirdPartyViewController {
                self.navigationController?.pushViewController(scanVC, animated: true)
            }
        }
          else if indexPath.section == 1  && indexPath.row == 1 {
            let vc = WebkitViewController.loadFromNib()
            vc.urlString = "https://www.albertsonscompanies.com/about-us/our-policies/terms-of-use.html"
            vc.screenTitle = "Terms of use"
            self.navigationController?.pushViewController(vc, animated: true)
          }
          else if indexPath.section == 1  && indexPath.row == 2{
            let vc = WebkitViewController.loadFromNib()
            vc.urlString = "https://www.albertsonscompanies.com/about-us/our-policies/privacy-policy.html"
            vc.screenTitle = "Privacy policy"
            self.navigationController?.pushViewController(vc, animated: true)
          }
          else if indexPath.section == 1  && indexPath.row == 0 {
            
            let vc = WebkitViewController.loadFromNib()
            vc.urlString = "https://scanandgoterms.azurewebsites.net"
            vc.screenTitle = "Terms And Conditions"
            self.navigationController?.pushViewController(vc, animated: true)
            
//            let vc = TermsAndConditonViewController.loadFromNib()
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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
