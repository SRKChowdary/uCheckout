//
//  CartTableViewCell.swift
//  UCheckout
//
//  Created by i2i Innovation on 29/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit
import SwipeCellKit
import SDWebImage

class CartTableViewCell: UITableViewCell {

    @IBOutlet weak var cartView: UIView!
    
    @IBOutlet weak var quantityLabel: UILabel!
    
    @IBOutlet weak var dropDownButton: RoundButton!
    
    @IBOutlet weak var itemNameLabel: UILabel!
    
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var couponLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var downArrowImageView: UIImageView!
    
    @IBOutlet weak var regularPriceLabel: UILabel!
    
    @IBOutlet weak var couponCheckIcon: UIImageView!
    
    

    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dropDownButton.layer.borderColor = GlobalColor.k87BlackColor.cgColor
        cartView.layer.borderColor = GlobalColor.k87BlackColor.cgColor
        //quantityLabel.layer.borderColor = GlobalColor.k87BlackColor.cgColor
        downArrowImageView.layer.borderColor = GlobalColor.k87BlackColor.cgColor
        dropDownButton.layer.borderWidth = 1.0
        //selectionStyle = .none
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    internal func populateData(itemElement : ItemElement){
        
        guard let item = itemElement.item else {
            return
        }
        
        guard let j4uCoupons = item.jfuOfferCount else {
            return
        }
//
//        guard let viewCartClubPrice = item.clubPrice else {
//            return
//        }

//        guard let promoMethod = item.clubPrice?.promoMethod else {
//            return
//        }

        if let sellPrice = item.sellPrice {
            if  let weightStatus  = item.weightItem, weightStatus
            {
                self.regularPriceLabel.isHidden = true
                 if let weight = itemElement.weight
                 {
                     let value = sellPrice * weight
                   // let value = sellPrice
                    let finalPrice = String(format: "%.2f", value)
                     self.priceLabel.text = "$\(finalPrice)"
                }
               
                
            }
            else {
                if item.clubPrice?.offerMessage == "false" {
                    self.priceLabel.text = "$\(String(format: "%.2f", sellPrice))"
                    self.regularPriceLabel.isHidden  = true
                    if j4uCoupons == 0 {
                        couponLabel.isHidden = true
                        couponCheckIcon.isHidden = true
                    }
                    else {
                        couponLabel.text = "\(j4uCoupons) Coupons Clipped"
                        couponCheckIcon.isHidden = false
                    }
                }
                else {
                    if let itemPrice = item.item_price {
                        
                        if itemPrice == sellPrice {
                            self.priceLabel.text = "$\(String(format: "%.2f", itemPrice))"
                            self.regularPriceLabel.isHidden  = true
                            if j4uCoupons == 0 {
                                couponLabel.isHidden = true
                                couponCheckIcon.isHidden = true
                            }
                            else {
                                couponLabel.text = "\(j4uCoupons) Coupons Clipped"
                                couponCheckIcon.isHidden = false
                            }
                        }
                        else {
                            self.priceLabel.text = "$\(String(format: "%.2f", itemPrice))"
                            self.regularPriceLabel.attributedText = "$\(String(format: "%.2f", sellPrice))".strikeThrough()
                            if j4uCoupons == 0 {
                                couponLabel.isHidden = true
                                couponCheckIcon.isHidden = true
                            }
                            else {
                                couponLabel.text = "\(j4uCoupons) Coupons Clipped"
                                couponCheckIcon.isHidden = false
                            }
                        }
                    }
                }
                
                
                
                
                
//                switch promoMethod {
//
//                case "PE":
//                print("Case PE")
//
//                    if let quant = itemElement.quantity{
//                        if let promoPrice = item.clubPrice?.promoPrice{
//                            let finalClubPrice = quant * promoPrice
//                            self.priceLabel.text = String(format: "%.2f", finalClubPrice)
//                        }
//                    }
//
//                case "CE":
//                    print("Case CE")
//
//                    if let quant = itemElement.quantity{
//                        if let promoPrice = viewCartClubPrice.promoPrice{
//                            let finalClubPrice = quant * promoPrice
//                            self.priceLabel.text = String(format: "%.2f", finalClubPrice)
//                        }
//                    }
//
//                default:
//                    break
//
//                }
//                 if let qunt = itemElement.quantity
//                 {
//                    let value = sellPrice * qunt
//                   // let value = sellPrice
//                    let finalPrice = String(format: "%.2f", value)
//                    self.priceLabel.text = "$\(finalPrice)"
//                 }
                
                
                
//                if item.clubPrice?.promoMethod == "PE"{
//
//                    if let quant = itemElement.quantity{
//                        if let promoPrice = item.clubPrice?.promoPrice{
//                            let finalClubPrice = quant * promoPrice
//                            self.priceLabel.text = String(format: "%.2f", finalClubPrice)
//                        }
//                    }
//
////                    if let promoPrice = item.clubPrice?.promoPrice {
////                        if let quant = itemElement.quantity{
////                            let clubSellPrice = (sellPrice * Double(quant)) * (promoPrice/100)
////                            let finalSellPrice = sellPrice - clubSellPrice
////                            self.priceLabel.text = String(format: "%.2f", finalSellPrice)
////                        }
////                    }
//
//                }
                
            }
            
        }

        if let itemImageURL = item.imageURL {
            itemImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            itemImageView.sd_setImage(with: URL(string: itemImageURL), placeholderImage: nil)
        }
        if let itemName = item.posDescription {
            self.itemNameLabel.text = itemName
        }
        
        // Drop down button should not be enabled for weight items.
        
        if  let weightStatus  = item.weightItem, weightStatus {
            
            if let weight = itemElement.weight {
                quantityLabel.attributedText = UcheckoutManager.getAtttributedStringForQuantWithString1("Lbs", string2: "\(weight)")
                downArrowImageView.isHidden = true
                dropDownButton.isEnabled = false
            }
            else {
                quantityLabel.attributedText = UcheckoutManager.getAtttributedStringForQuantWithString1("Lbs", string2: "0.0")
                downArrowImageView.isHidden = true
                dropDownButton.isEnabled = false
                if let scancod = itemElement.scanCode {
                    if scancod.substring(start: 0, offsetBy: 2) == "02" {
                        downArrowImageView.isHidden = true
                        dropDownButton.isEnabled = false
                    }
                }
            }
        }
        else {
            if let qunt = itemElement.quantity {
                quantityLabel.attributedText = UcheckoutManager.getAtttributedStringForQuantWithString1("Qty", string2: "\(Int(qunt))")
                downArrowImageView.isHidden = false
            }
           
                if let scancod = itemElement.scanCode {
                    if scancod.substring(start: 0, offsetBy: 2) == "02" {
                        downArrowImageView.isHidden = true
                        dropDownButton.isEnabled = false
                    }
                }
            
        }
        
        
    }
    
}
