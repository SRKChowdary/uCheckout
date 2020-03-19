
//
//  RecieptTableViewCell.swift
//  UCheckout
//
//  Created by i2i innovation on 05/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class RecieptTableViewCell: UITableViewCell {
    
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    @IBOutlet weak var storeTimeLabel: UILabel!
    
    @IBOutlet weak var storeAddressLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateData(_ reciept : RecieptData)  {
        if let totalAmount = reciept.totalAmount {
            let price = totalAmount
            let finalPrice = String(format: "%.2f", price)
            self.totalAmountLabel.text = "$\(finalPrice)"
            
        }
        
        if let storeAdress = reciept.storeAddress {
              self.storeAddressLabel.text = storeAdress
        }

        if let store_time = reciept.storeTime {
            //print("storeTime is -------------------------------->\(store_time)")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy h:mm a"
            let dateObj = dateFormatter.date(from: store_time)
            dateFormatter.dateFormat = "MMM d, yyyy h:mma"
           // dateFormatter.amSymbol = "am"
           // dateFormatter.pmSymbol = "pm"
            if let dateObj = dateObj {
                self.storeTimeLabel.text = dateFormatter.string(from: dateObj)
               // print("storeTimeLabel is ------------------------>\(storeTimeLabel.text)")

            }
            else {
                self.storeTimeLabel.text = reciept.storeTime
            }
           
        }
        
    }
    
}
