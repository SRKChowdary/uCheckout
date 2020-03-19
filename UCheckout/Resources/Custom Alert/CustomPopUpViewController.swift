//
//  CustomPopUpViewController.swift
//  UCheckout
//
//  Created by i2i Innovation on 30/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit
import SwiftPopup

class CustomPopupData  : NSObject{
    var removeButtonTitle : String = "Remove"
     var cancelButtonTitle : String = "Cancel"
     var descTextView : String = "Are you sure you want to empty your cart. This action cannot be undone. You will need to re-scan each item to continue shopping."
    var headerTitle : String = "Your cart will be emptied."
    var erroImageView : String = "imageErrorFlow"
    var removeButton : Bool = false
    var cancelButton : Bool = false
    var errorImageViewOne : String = "pluhelperOne"
    var errorImageViewTwo : String = "pluclubCard"
    var firstImageHidden : Bool = true
    var secondImageHidden : Bool = true
   // var cancelButton : Bool = false
}


protocol CustomPopUpViewActionProtocol {
    func cancelButtonClick()
    func removeButtonClick()
}



class CustomPopUpViewController: SwiftPopup {
    
    
       // MARK: - IBOutlet Connection
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var errorImageView: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    @IBOutlet weak var errorImageViewOne: UIImageView!
    
    @IBOutlet weak var errorImageViewTwo: UIImageView!
    
     // MARK: - Variable Decleration
    
    var customPopupDelegate : CustomPopUpViewActionProtocol?
    var customPopupData = CustomPopupData()
    
    
    
    
     // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        populateUI()

        // Do any additional setup after loading the view.
    }
    
     // MARK: - Populate Data
    
    private func populateUI(){
        self.headerLabel.text = customPopupData.headerTitle
        self.descriptionTextView.text = customPopupData.descTextView
        self.removeButton.setTitle(customPopupData.removeButtonTitle, for: .normal)
        self.cancelButton.setTitle(customPopupData.cancelButtonTitle, for: .normal)
        self.errorImageView.image = UIImage(named: customPopupData.erroImageView)
        self.removeButton.isHidden = customPopupData.removeButton
        self.cancelButton.isHidden = customPopupData.cancelButton
        self.errorImageViewOne.image = UIImage(named: customPopupData.errorImageViewOne)
        self.errorImageViewTwo.image = UIImage(named: customPopupData.errorImageViewTwo)
        self.errorImageViewOne.isHidden = customPopupData.firstImageHidden
        self.errorImageViewTwo.isHidden = customPopupData.secondImageHidden
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    @IBAction func removeButtonAction(_ sender: UIButton) {
        // FireBase Event :
        FirebaseEventmanger.logEventWithName("ContinueButton_Pressed", andCustomAttributes: ["build_number":UIDevice().appShortVersion,"page":"CartBaseViewController","event_day_of_week":UcheckoutManager.getDay()])
        
        customPopupDelegate?.removeButtonClick()
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        customPopupDelegate?.cancelButtonClick()
    }
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
