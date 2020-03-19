//
//  WalletTableViewCell.swift
//  UCheckout
//
//  Created by 1521398 on 07/09/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import UIKit

protocol WalletTableViewCellDelegate: class {
    func trashIconTapped(from cell: WalletTableViewCell, indexPath: IndexPath?)
}

class WalletTableViewCell: UITableViewCell {

    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var cardImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var indexPath: IndexPath?
    weak var delegate: WalletTableViewCellDelegate?
    
    @IBOutlet weak var statusLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupGestures()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    @IBAction func onClickTrashIcon(_ sender: Any) {
        delegate?.trashIconTapped(from: self, indexPath: self.indexPath)
    }
    
    
    func setupGestures() {
//        //Left swipe - Show trash view
//        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(hideTrashView(_:)))
//        swipeLeft.direction = .left
//        self.addGestureRecognizer(swipeLeft)
//
//        //Right swipe - Hide trash view
//        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(showTrashView(_:)))
//        swipeRight.direction = .left
//        self.addGestureRecognizer(swipeRight)
    }
    
//    @objc func showTrashView(_ recognizer: UISwipeGestureRecognizer) {
//        DispatchQueue.main.async {
//            self.trashView.isHidden = false
//        }
//    }
//
//    @objc func hideTrashView(_ recognizer: UISwipeGestureRecognizer) {
//        DispatchQueue.main.async {
//            self.trashView.isHidden = true
//        }
//    }
    
}
