//
//  MenuHeaderTableViewCell.swift
//  UCheckout
//
//  Created by i2i Innovation on 28/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class MenuHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var safewayLogoOutlet: UIImageView!
    
    @IBOutlet weak var uCheckoutLabelText: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = UITableViewCell.SelectionStyle.none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
     func updateUserInfoo(){
        var userName = ""
        let shared = UcheckoutSingleton.shared
        if let user = shared.userData {
            if let firstName = user.firstName {
                userName = "\(firstName) "
            }
            if let lastName = user.lastName {
                userName.append(lastName)
            }
            
        }
        self.userNameLabel.text = userName
    }

}
