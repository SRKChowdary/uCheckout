//
//  MiniRecieptViewController.swift
//  UCheckout
//
//  Created by i2i innovation on 11/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit
import Firebase

class MiniRecieptViewController: UIViewController {
    
    
      // MARK: - IB Outlet Connection
    
    @IBOutlet weak var cartCountLabel: UILabel!
    @IBOutlet weak var timeLbael: UILabel!
    @IBOutlet weak var barcodeImageView: UIImageView!
    @IBOutlet weak var barCodeLabel: UILabel!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var totallabel: UILabel!
    
    @IBOutlet weak var bagCountLabel: UILabel!
    
    var bagCount : Int?
    var isBarcodeScanned : Bool = false
    
      // MARK: - Variable Declaration
   
    var reciptData : RecieptData?
    
  


      // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismiss(animated: false, completion: nil)
        cartCountLabel.isAccessibilityElement = true
        cartCountLabel.accessibilityLabel = "\(String(describing: cartCountLabel))"
        
       
 
        
      
        updateUI()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        UIApplication.shared.statusBarView?.backgroundColor = UIColor.init(red: 110.0/255.0, green: 214.0/255.0, blue: 136.0/255.0, alpha: 0.6)
        navigationController?.navigationBar.barStyle = .default
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
          self.navigationController?.navigationBar.isHidden = false
        UIApplication.shared.statusBarView?.backgroundColor = GlobalColor.KAppRedColor
        navigationController?.navigationBar.barStyle = .black
    }
   
     // MARK: - Private Methods
    
    private func updateUI(){
        guard let recpt = self.reciptData else {
            return
        }
        if let barCode = recpt.orderID {
            self.barCodeLabel.text = barCode
            self.barcodeImageView.image = UIImage.generateBarcode(from: barCode)
            
            // Firebase Event :
            FirebaseEventmanger.logEventWithName("BarcodeScannedByAttendant", andCustomAttributes: ["guid": UcheckoutSingleton.shared.userData?.guid ?? 0])
            
            Analytics.setUserProperty("\(String(describing: UcheckoutSingleton.shared.userData?.firstName))", forName: "first_name")
            Analytics.setUserProperty("\(String(describing: UcheckoutSingleton.shared.userData?.lastName))", forName: "last_name")
            Analytics.setUserProperty("\(String(describing: UcheckoutSingleton.shared.userData?.guid))", forName: "user_guid")
            
        }
        
        // Pranav Bug Fix
        if let totalAmount = recpt.totalAmount {
            let final = String(format: "%.2f", totalAmount)
            totalPriceLabel.text = "$\(final)"
            
        }
        if let item_count = recpt.itemCount {
            cartCountLabel.text = "\(item_count)"
            totallabel.text = "Total (\(item_count) items)"
            
        }
        if let bagCount = bagCount {
            self.bagCountLabel.text = "\(bagCount)"
        }
        else
        {
            self.bagCountLabel.text = "0"
        }
        
//        if let storeTime = recpt.storeTime
//        {
//            //yyyy-MM-dd'T'HH:mm:ssZ"
//            // "MM/dd/yy HH:mm"
//           // if let date = storeTime.toShortDate(format: "MM/dd/YYYY HH:mm")
//            if let date = storeTime.toDate(format: "MM/dd/YYYY HH:mm a")
//            {
//
//                if let formattedDateString = date.toString(format: "MM/dd   h:mm a")
//                {
//                    timeLbael.text = formattedDateString
//
//                }
//            }
//            timeLbael.text = storeTime
//MMM d, yyyy h:mma
//
//        }
        
        // Back end is formatting the time and sending it.
        if let storeTime = recpt.storeTime {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy h:mm a"
            let dateObj = dateFormatter.date(from: storeTime)
            dateFormatter.dateFormat = "MM/dd h:mm a"
           // dateFormatter.amSymbol = "AM"
           // dateFormatter.pmSymbol = "PM"
            if let dateObj = dateObj {
                self.timeLbael.text = dateFormatter.string(from: dateObj)
                
            }
            else {
                self.timeLbael.text = storeTime
            }
            
        }
    

    }
    
    
      // MARK: - Button Action
    
    @IBAction func viewFullRecieptAction(_ sender: UIButton) {
        
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            if let recieptVC = UIStoryboard.reciept.instantiateViewController(withIdentifier: "RecieptViewController") as? RecieptViewController {
                recieptVC.reciptData = self.reciptData
                navigationController.pushViewController(recieptVC, animated: true)
            }
        }
    }
    
    @IBAction func donebUttonAction(_ sender: UIButton) {
        let viewController = RecieptDonePopUpViewController(nibName: "RecieptDonePopUpViewController", bundle: nil)
        viewController.show()
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
