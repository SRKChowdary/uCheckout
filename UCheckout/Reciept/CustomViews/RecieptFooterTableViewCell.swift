//
//  RecieptFooterTableViewCell.swift
//  UCheckout
//
//  Created by i2i Innovation on 08/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit

class RecieptFooterTableViewCell: UITableViewCell {
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    
    @IBOutlet weak var totalSavingLabel: UILabel!
    
    @IBOutlet weak var paymentMethodLabel: UILabel!
    
    @IBOutlet weak var approvalNumberLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var transactionStatusLabel: UILabel!
    
    @IBOutlet weak var paymentMethodView: UIStackView!
    
    @IBOutlet weak var approvalNumberView: UIStackView!
    
    @IBOutlet weak var timeView: UIStackView!
    
    @IBOutlet weak var transactionStatusView: UIStackView!
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    
    @IBOutlet weak var pricingStackView: UIStackView!
    
    
    @IBOutlet weak var conten: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        conten.accessibilityElements = [pricingStackView,mainStackView]
    
        mainStackView.accessibilityElements = [paymentMethodView, approvalNumberView, timeView, transactionStatusView]
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func populateCellData(_ receptData : RecieptData) {
        if let totalPrice = receptData.totalAmount {
            let finalPrice = String(format: "%.2f", totalPrice)
            self.totalPriceLabel.text = "$\(finalPrice)"
        }
        if let totalSavings = receptData.receiptJSON?.receiptTotalResult?.totalSavings {
            let finalPrice = String(format: "%.2f", totalSavings)
            self.totalSavingLabel.text = "$\(finalPrice)"
        }
         if let approvalNumber = receptData.receiptJSON?.transactionInfo?.approvalNumber {
            approvalNumberLabel.text = approvalNumber
            approvalNumberLabel.isAccessibilityElement = true
            approvalNumberLabel.accessibilityLabel = "Approval Number is \(approvalNumber)"
        }
        
        if let transactionStatus = receptData.transactionStatus {
            self.transactionStatusLabel.text = transactionStatus
        }
        if let storeTime = receptData.storeTime {
            self.timeLabel.text = storeTime
        }
        
        if let cardType = receptData.receiptJSON?.transactionInfo?.cardType {
            switch cardType {
            case CardType.Amex.rawValue :
                if let card_pan_print = receptData.receiptJSON?.transactionInfo?.cardPanPrint {
                   paymentMethodLabel.text = String(format:"Amex - %@", String(card_pan_print.suffix(4)).capitalized)
                   paymentMethodLabel.isAccessibilityElement = true
                   paymentMethodLabel.accessibilityLabel = "American Express"
                  
                }
            case CardType.DISCOVER.rawValue :
                
                if let card_pan_print = receptData.receiptJSON?.transactionInfo?.cardPanPrint {
                    paymentMethodLabel.text = String(format:"Discover - %@", String(card_pan_print.suffix(4)).capitalized)
                    paymentMethodLabel.isAccessibilityElement = true
                    paymentMethodLabel.accessibilityLabel = "Discover"
                }
                
            case CardType.MASTERCARD.rawValue :
                if let card_pan_print = receptData.receiptJSON?.transactionInfo?.cardPanPrint {
                    paymentMethodLabel.text = String(format:"Mastercard - %@", String(card_pan_print.suffix(4)).capitalized)
                    paymentMethodLabel.isAccessibilityElement = true
                    paymentMethodLabel.accessibilityLabel = "Master Card"
                }
               
            case CardType.VISA.rawValue :
                if let card_pan_print = receptData.receiptJSON?.transactionInfo?.cardPanPrint {
                    paymentMethodLabel.text = String(format:"Visa - %@", String(card_pan_print.suffix(4)).capitalized)
                    paymentMethodLabel.isAccessibilityElement = true
                    paymentMethodLabel.accessibilityLabel = "Visa"
                }
                
            default: break
                
            }
        }
    }

}
