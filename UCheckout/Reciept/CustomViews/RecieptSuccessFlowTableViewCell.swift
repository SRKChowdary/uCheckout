//
//  RecieptSuccessFlowTableViewCell.swift
//  UCheckout
//
//  Created by i2i innovation on 06/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class RecieptSuccessFlowTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var itemCountlabel: UILabel!
    
    
    @IBOutlet weak var viewBackground: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateCellData(_ receptData : RecieptData) {
        
        if let item_count = receptData.itemCount {
            itemCountlabel.text = "\(item_count)"
            
        }
         //viewBackground.backgroundColor = UIColor.white
        
        if let transactionCompleteAt = receptData.receiptJSON?.transactionInfo?.transactionCompleteAt {
            if let reciptDate = transactionCompleteAt.toDate() {
                 if reciptDate.isTimeDifference1hr(Date()) {
                   viewBackground.backgroundColor = UIColor(red: 168/255.0, green: 230/255.0, blue: 184/255.0, alpha: 1.0)
                }
                else
                 {
                    viewBackground.backgroundColor = UIColor.white
                }
                
            }
            
        }
        
        
    }

}
