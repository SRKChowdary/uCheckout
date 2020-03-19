//
//  MenuTableViewCell.swift
//  UCheckout
//
//  Created by i2i Innovation on 28/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {
    
    @IBOutlet weak var menuImageView: UIImageView!
    

    @IBOutlet weak var menuDescLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
         selectionStyle = UITableViewCell.SelectionStyle.none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateData(_ menuModel : MenuModel) {
        menuImageView.image = UIImage(named: menuModel.menuImage)
        if menuModel.menuDesc == "Cart"{
           upDateUI()
        }
        else {
            menuDescLabel.text = menuModel.menuDesc

        }
        
        
    }
    
    private func upDateUI()
    {
        var count = 0
        let shared = UcheckoutSingleton.shared

        if let viewCartArray = shared.viewCart {
            count = viewCartArray.totalQuantity ?? 0
        }
        if count == 0 {
            menuDescLabel.text = "Cart"
        }
        else {
            menuDescLabel.text = "Cart (\(count))"
        }
        
        
        self.enable(on: false)
        if  let stores = shared.getprofileModelData?.stores {
            if let sngHr = shared.getprofileModelData?.sngStoreHours , sngHr == false {
                self.enable(on: true)
            }
            if let value = UcheckoutSingleton.shared.isInStoreRegion , value == true {
                self.enable(on: true)
            }
        }
        
        
        
    }

}
extension UITableViewCell {
    func enable(on: Bool) {
        self.isUserInteractionEnabled = on
        for view in contentView.subviews {
            self.isUserInteractionEnabled = on
            view.alpha = on ? 1 : 0.5
        }
    }
}
