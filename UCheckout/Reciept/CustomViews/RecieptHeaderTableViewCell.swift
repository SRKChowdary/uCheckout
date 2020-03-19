//
//  RecieptHeaderTableViewCell.swift
//  UCheckout
//
//  Created by i2i innovation on 06/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class RecieptHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var storeAddressLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateCellData(_ receptData : RecieptData) {
        
        if let storeAddress = receptData.storeAddress {
            storeAddressLabel.text = storeAddress
            
        }
        
        
    }

}
