
//
//  AboutTableViewController.swift
//  UCheckout
//
//  Created by i2i innovation on 04/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class AboutTableViewController: UITableViewController {
    
    
    @IBOutlet weak var SafewayUCheckoutView: UIView!
    
    @IBOutlet weak var safewayImageOutlet: UIImageView!
    
    
    @IBOutlet weak var uCheckoutLabel: UILabel!
    
    
    
    


  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        
       // safewayImageOutlet.isAccessibilityElement = true

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        // Accessibility Order :
        
        //self.SafewayUCheckoutView.accessibilityElements = [safewayImageOutlet,uCheckoutLabel]
    }
    
   
    
   
    // MARK: - Table view data source

   
    
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
    
    // MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 && indexPath.row == 0 {
            if let scanVC = UIStoryboard.terms.instantiateViewController(withIdentifier: "TermsBaseViewController") as? TermsBaseViewController {
                self.navigationController?.pushViewController(scanVC, animated: true)
            }
        }
            
        else if indexPath.section == 1 && indexPath.row == 0 {
            
            if let scanVC = UIStoryboard.help.instantiateViewController(withIdentifier: "GeneralHelpViewController") as? GeneralHelpViewController
            {
                self.navigationController?.pushViewController(scanVC, animated: true)
            }
                
        }
        else if indexPath.section == 1 && indexPath.row == 1 {
            
            if let scanVC = UIStoryboard.faq.instantiateViewController(withIdentifier: "FAQCategoryTableViewController") as? FAQCategoryTableViewController
            {
                self.navigationController?.pushViewController(scanVC, animated: true)
            }
            
        }
            
        else if indexPath.section == 1 && indexPath.row == 2 {
            
            if let scanVC = UIStoryboard.feedback.instantiateViewController(withIdentifier: "FeedbackViewController") as? FeedbackViewController
            {
                self.navigationController?.pushViewController(scanVC, animated: true)
            }
            
        }
       
       else  if indexPath.section == 1 && indexPath.row == 3 {
            if let scanVC = UIStoryboard.contact.instantiateViewController(withIdentifier: "ContactUSViewController") as? ContactUSViewController
            {
                self.navigationController?.pushViewController(scanVC, animated: true)
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


