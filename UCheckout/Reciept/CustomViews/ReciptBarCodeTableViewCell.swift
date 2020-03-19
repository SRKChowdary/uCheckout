//
//  ReciptBarCodeTableViewCell.swift
//  UCheckout
//
//  Created by i2i innovation on 06/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class ReciptBarCodeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var barCodeImage: UIImageView!
    
    @IBOutlet weak var barcodeLabel: UILabel!
    
    @IBOutlet weak var totalItemCountLabel: UILabel!
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func populateCellData(_ receptData : RecieptData) {
        if let retrieveBarcodeValue = receptData.orderID {
            barcodeLabel.text = retrieveBarcodeValue
            barCodeImage.image = UIImage.generateBarcode(from: retrieveBarcodeValue)
        }
        
        if let totalAmount = receptData.totalAmount {
            let finalPrice = String(format: "%.2f", totalAmount)
            totalPriceLabel.text = "$\(finalPrice)"
            
        }
        if let item_count = receptData.itemCount {
            totalItemCountLabel.text = "Total (\(item_count) items)"
            
        }
        
        if let storeTime = receptData.storeTime
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yy h:mm a"
            let dateObj = dateFormatter.date(from: storeTime)
            dateFormatter.dateFormat = "MM/dd h:mm a"
           // dateFormatter.amSymbol = "am"
           // dateFormatter.pmSymbol = "pm"
            if let dateObj = dateObj {
                self.timeLabel.text = dateFormatter.string(from: dateObj)
                
            }
            else {
                self.timeLabel.text = storeTime
            }
            
        }
        
//        if let storeTime = receptData.storeTime {
//            //yyyy-MM-dd'T'HH:mm:ssZ"
//            if let date = storeTime.toDate(format: "MM/dd/yy h:mm a") {
//                if let formattedDateString = date.toString(format: "MM/dd   h:mm a") {
//                    timeLabel.text = formattedDateString
//
//                }
//            }
//            timeLabel.text = storeTime
//
//
//        }
    }

}

