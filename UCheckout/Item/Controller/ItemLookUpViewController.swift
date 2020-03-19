//
//  ItemLookUpViewController.swift
//  UCheckout
//
//  Created by i2i innovation on 23/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit
import SDWebImage
import Firebase

enum CartCaseState : String{
    case Update = "update"
    case Add = "add"
}





class ItemLookUpViewController: BaseViewController {
    
    // MARK: - IBOutLet Connections
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var dropDownButton: RoundButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var bottomButtomContainerStackView: UIStackView!
    @IBOutlet weak var pickerViewContainer: UIView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var qyantityNameLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var weightUpdateMessageLabel: UILabel!
    @IBOutlet weak var itemIncartLabel: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var downArrowImageView: UIImageView!
    @IBOutlet weak var labelBottomConstraints: NSLayoutConstraint!
    @IBOutlet weak var stackViewBottomConstaints: NSLayoutConstraint!
    @IBOutlet weak var weightQuantityView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var customNavBarView: CustomNavigationBarView!
    @IBOutlet weak var cartCountLabel: CircularLabel!
    @IBOutlet weak var clubCardPriceLabel: UILabel!
    @IBOutlet weak var regularPriceLabel: UILabel!
    @IBOutlet weak var ClubOrRegularPriceLabel: UILabel!
    @IBOutlet weak var couponsAvailableLabel: UILabel!
    @IBOutlet weak var clubStackView: UIStackView!
    
    @IBOutlet weak var clubOfferView: UIView!
    
    @IBOutlet weak var offersImageView: UIImageView!
    
    @IBOutlet weak var offersFreeLabel: UILabel!
    
    // MARK:- Constraint Label :
    @IBOutlet weak var weightLabelConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var leftOfferImageConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var rightOfferImageConstraint: NSLayoutConstraint!
    
    
    
    
    
    // IB Actions :
    
   
    
    
    private var registeredToBackgroundEvents = false

    
    
    // MARK: - Variable Declerations
    var scrollPositionvalue = 0.0
    
    var itemDetail : ItemDetail?
    var cartCaseState : CartCaseState?
    var isItemWeightable = false
    var itemWeight : String?
    var itemQuantity : String?
    var sellMultiple : Int?
    var upcType : UPCType?
    var itemLookUpViewModel = ItemLookUpViewModel()
    var itemElement : ItemElement?
    var quant = 0
    var isFromScanPage = false
    var isFromPluPage = false
    private var itemElementArray : [ItemElement]?
    private var homeViewModel = HomeViewModel()
    private var viewCartData : ViewCartData?
    var clubPrices : ClubPrices?
    var storeClubPrice : Double?
    //var itemlookUpModel = ItemLookUpModel()
    var j4uCoupons : Int?
    
    
    
    let transiton = SlideInTransition()
    
    
    
    
    // MARK: - View Life Cycle  Methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        updateButtonLayer()
        itemIncartLabel.isHidden = true
        customNavBarView.customNavBarProtocolDelegate = self
       // ClubCardtextColor()
       // scrollView.contentSize = CGSize(width: 640, height: <#T##CGFloat#>)
 
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
         getViewCartData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    override func gestureClicked() {
        super.gestureClicked()
        menuButtonClicked()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        switch UIDevice().type {
        case .iPhoneSE,.iPhone5,.iPhone5S,.iPhone5C:
            scrollPositionvalue = 180
            labelBottomConstraints.constant = 30
            
       // case .iPhone6,.iPhone7,.iPhone8,.iPhone6S, .iPhone6Plus, .iPhoneX, .iPhone7Plus :
           // labelBottomConstraints.constant = 30
           // scrollPositionvalue = 100
            
        default:
            scrollPositionvalue = 0
        }
        
        
        
        
    }
    
    // Bug Fix : as per New UI :
    private func upDateData(){
       // change required
        self.customNavBarView.cartCountLabel.text = "\(viewCartData?.totalQuantity ?? 0)"
        
        
    }
    
    
    // MARK: - Private Methods

    @objc func backButtonClicked() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // UcheckoutManager.getCompleteURl
    // UcheckoutManager.getScanAndGoDevJSCompleteURl
    private func getViewCartData()
    {
        homeViewModel.getviewCart(strUrl: UcheckoutManager.getScanAndGoDevJSCompleteURl("/viewCart"), parentViewController: self) { (success, response, message) in
            
            DispatchQueue.main.async {
                if success {
                    if let response = response {
                        if let ack = response.ack {
                            if ack == "0" {
                                
                                if let viewCartData = response.data {
                                    self.viewCartData = viewCartData
                                    self.itemElementArray = viewCartData.items
                                    let shared = UcheckoutSingleton.shared
                                    shared.viewCart = viewCartData
                                    shared.itemElementArray = self.itemElementArray
                                    self.upDateData()
                                }
                                
                                
                            }
                            else if ack == "1"{
                                self.upDateData()
                                if let message = response.message {
                                    
                                    SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: message , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                                }
                            }
                        }
                        else {
                            self.upDateData()
                        }
                    }
                }
                else {
                    self.upDateData()
                    SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: message! , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                }
            }
            
        }
    }
    
    private func updateButtonLayer(){
        if isItemWeightable {
            weightQuantityView.layer.borderColor = GlobalColor.klightGreyColor.cgColor
            qyantityNameLabel.textColor = UIColor.gray
            
        }
        else {
            weightQuantityView.layer.borderColor = GlobalColor.k87BlackColor.cgColor
            qyantityNameLabel.layer.borderColor = GlobalColor.k87BlackColor.cgColor
            dropDownButton.layer.borderColor = GlobalColor.k87BlackColor.cgColor
            downArrowImageView.layer.borderColor = GlobalColor.k87BlackColor.cgColor
            dropDownButton.layer.borderWidth = 1.0
            
        }
    }
    
    
    private func updateUI(){
        // Bug Fix : As per new UI Design
        customNavBarView.deleteButtton.setImage(UIImage(named: "backArrow"), for: .normal)
        customNavBarView.deleteButtton.isHidden = false
        customNavBarView.deleteButtton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)

        
        if let cartCaseState = cartCaseState {
            
            switch cartCaseState {
            case .Add:
                self.itemIncartLabel.isHidden = true
                self.updateButton.setTitle("Add", for: .normal)
                self.weightUpdateMessageLabel.isHidden = true
                updateUIForAdd()
                print("*******Item Add*******")
            case .Update:
                self.itemIncartLabel.isHidden = true
                self.weightUpdateMessageLabel.isHidden = true
                self.updateButton.setTitle("Update", for: .normal)
                updateUIForUpdate()
                print("*******Item Update*******")
            }
            
        }
        
        
        
       // dropDownButton.layer.borderColor = GlobalColor.klightGreyColor.cgColor
        dropDownButton.layer.borderWidth = 1.0
        
        cancelButton.layer.borderColor = GlobalColor.klightGreyColor.cgColor
        cancelButton.layer.borderWidth = 1.0
    
       // clubStackView.addBackground(color: .yellow)
        
//        clubStackView.layer.borderColor = GlobalColor.kYellowColor.cgColor
//        clubStackView.layer.borderWidth = 1.0

    }
    
    private func updateUIForAdd(){
        
        guard let itemDetail = self.itemDetail  else {
            return
        }

        if let weightItem = itemDetail.weightItem , weightItem {
            isItemWeightable = true
            self.dropDownButton.isUserInteractionEnabled = false
            self.downArrowImageView.isHidden = true
          }
        if isItemWeightable {
            if let itemWeight = itemWeight {
                self.qyantityNameLabel.text = "Lbs : \(itemWeight)"
                // J4U coupons for weightable items :
                if j4uCoupons == 0 || j4uCoupons == nil {
                    couponsAvailableLabel.isHidden = true
                }
                else{
                    couponsAvailableLabel.text = "\(j4uCoupons!) Coupons Clipped"
                }
            }
            else {
                self.qyantityNameLabel.text = "Lbs : "
                
//                if j4uCoupons == 0 || j4uCoupons == nil {
//                    couponsAvailableLabel.isHidden = true
//                }
//                else{
//                    couponsAvailableLabel.text = "\(j4uCoupons!) Coupons Clipped"
//                }
            }
            
        }
        else {
            
            if let qunt = itemQuantity {
                qyantityNameLabel.attributedText = UcheckoutManager.getAtttributedStringForQuantWithString1("Qty", string2: "\(qunt)")
            }
            else {
                itemQuantity = "1"
                self.qyantityNameLabel.text = "Qty : 1"
            }
            
        }
        if let scancod = itemDetail.scanCode {
            if scancod.substring(start: 0, offsetBy: 2) == "02" {
                self.dropDownButton.isUserInteractionEnabled = false
                self.dropDownButton.layer.borderColor = GlobalColor.klightGreyColor.cgColor
                self.downArrowImageView.isHidden = true
            }
        }
        
        
        if let itemDesc = itemDetail.posDescription {
            self.itemDescriptionLabel.text = itemDesc
        }
        if let itemImageURL = itemDetail.imageURL {
            
            itemImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            itemImageView.sd_setImage(with: URL(string: itemImageURL), placeholderImage: nil)
           // itemImageView.dropShadow()

        }

        if upcType!.rawValue == "PLU"{
            
            if j4uCoupons == nil{
                couponsAvailableLabel.isHidden = true
            }
            else if j4uCoupons == 0{
                couponsAvailableLabel.isHidden = true
            }
            else{
                couponsAvailableLabel.text = "\(j4uCoupons!) Coupons Clipped"
            }
        }
        else if upcType!.rawValue == "UPCA"{
            if j4uCoupons == nil{
                couponsAvailableLabel.isHidden = true
            }
            else if j4uCoupons == 0{
                couponsAvailableLabel.isHidden = true
            }
            else{
                couponsAvailableLabel.text = "\(j4uCoupons!) Coupons Clipped"
            }
        }
        else {
            if j4uCoupons == 0{
                couponsAvailableLabel.isHidden = true
            }
            else{
                couponsAvailableLabel.text = "\(j4uCoupons!) Coupons Clipped"
            }
        }

        updatePriceForAdd(itemDetail: itemDetail)
        
    }
    
    
    
    private func updatePriceForAdd(itemDetail : ItemDetail){
        
        guard let sellPrice = itemDetail.sellPrice else {
            return
        }
        guard let offerMessage = clubPrices?.offerMessage else {
            return
        }
        if offerMessage == "false" {
            //self.clubCardPriceLabel.isHidden = true
            if isItemWeightable {
                self.regularPriceLabel.isHidden = true
                self.clubCardPriceLabel.text = "Regular Price"
                self.offersImageView.isHidden = true
                self.offersFreeLabel.isHidden = true
                self.clubCardPriceLabel.text = "$\(String(format: "%.2f", sellPrice))/lb"
                if let itemWt = itemWeight {
                    // Not showing total Price Label :
                   // self.totalPriceLabel.text =  "$\(String(format: "%.2f", (sellPrice * itemWt.toDouble())))"
                }
               
            }
            else {
               // self.offersImageView.isHidden = true
                self.offersFreeLabel.isHidden = true
                self.regularPriceLabel.isHidden = true
                self.clubCardPriceLabel.text = "Regular Price"
                self.offersImageView.isHidden = true
                self.clubCardPriceLabel.text = "$\(String(format: "%.2f", sellPrice))/ea"
                if let quants = itemQuantity{
                    // self.totalPriceLabel.text = "$\(String(format: "%.2f", (sellPrice * quants.toDouble())))"
                }

            }
           // self.regularPriceLabel.textColor = UIColor.black
            self.ClubOrRegularPriceLabel.text = "Regular Price"
           //  self.ClubOrRegularPriceLabel.textColor = UIColor.black
        } else {
            getClubCardPriceForAdd(itemDetail: itemDetail)
        }
        
    
    }
    
    private func getClubCardPriceForAdd(itemDetail : ItemDetail) {
        guard let promoMethod = clubPrices?.promoMethod else {
            return
        }
        guard let promoPrice = clubPrices?.promoPrice else {
            return
        }
        
        
        guard let ClubOfferMessage = clubPrices?.offerMessage else {
            return
        }
        
        if isItemWeightable {
            self.clubCardPriceLabel.text = "$\(String(format: "%.2f", promoPrice))/lb"
            self.weightUpdateMessageLabel.isHidden = false
            self.weightUpdateMessageLabel.text = clubPrices?.offerMessage
            self.regularPriceLabel.attributedText = "$\(String(format: "%.2f", itemDetail.sellPrice ?? 0))/lb".strikeThrough()
            self.regularPriceLabel.textColor = UIColor.gray
            //self.ClubOrRegularPriceLabel.text = "Club Card Price"
            
        } else {
            switch promoMethod {
            case "PE":
                print("Case PE")
                if let quants = itemDetail.sellMultiple {
                    if let clubSellPrice = itemDetail.sellPrice {
                        
                        // Checking for Must buy two or more kind of offers.
                        // This is regular Price with Offer Message :
                        if clubSellPrice == promoPrice{
                          self.ClubOrRegularPriceLabel.text = "Regular Price"
                          self.regularPriceLabel.isHidden = true
                          self.clubCardPriceLabel.text = "$\(String(format: "%.2f", clubSellPrice))/ea"
                          self.weightUpdateMessageLabel.isHidden = false
                          self.offersImageView.isHidden = false
                          self.clubOfferView.bringSubviewToFront(weightUpdateMessageLabel)
                          self.clubOfferView.sendSubviewToBack(offersImageView)
                            
                            // MARK:- Offer Message Strcuture :
                            
                            if (clubPrices?.offerMessage?.contains("FREE"))! {
                                if let endIndex = ClubOfferMessage.range(of: "-")?.lowerBound {
                                    let newString = ClubOfferMessage[..<endIndex]
                                    print(newString)
                                    let end = String.Index(encodedOffset: ClubOfferMessage.count)
                                    var substring = String(ClubOfferMessage[endIndex..<end])
                                    substring.removeFirst()
                                    print(substring)
                                    
                                    self.weightUpdateMessageLabel.attributedText = UcheckoutManager.getSecondAttributedString(String(newString))
                                    

                                    
                                    
                                    self.offersFreeLabel.attributedText = UcheckoutManager.getOneAttributedString(String(substring))
                                    
                                 //   self.offersFreeLabel.attributedText
                                    
                                    print(offersFreeLabel.text)
                                    
                                    
                                }
                                
                            }
                            else {
                                if let endIndex = ClubOfferMessage.range(of: "-")?.lowerBound {
                                    let newString = ClubOfferMessage[..<endIndex]
                                    print(newString)
                                    let end = String.Index(encodedOffset: ClubOfferMessage.count)
                                    var substring = String(ClubOfferMessage[endIndex..<end])
                                    substring.removeFirst()
                                    print(substring)
                                    
                                    self.weightUpdateMessageLabel.attributedText = UcheckoutManager.getSecondAttributedString(String(newString))
                                    
                                    self.offersFreeLabel.attributedText = UcheckoutManager.getOneAttributedString(String(substring))
                                    self.offersFreeLabel.font = offersFreeLabel.font.withSize(30)
                                    
                                    print(offersFreeLabel.text)
                                    
                                    
                                }
                            }
                        
                          
                        }
                            // This is clubPrice with Offer Message :
                        else {
                          self.clubCardPriceLabel.text = "$\(String(format: "%.2f", promoPrice))/ea"
                          self.regularPriceLabel.textColor = UIColor.gray
                          self.regularPriceLabel.attributedText = "$\(String(format: "%.2f", itemDetail.sellPrice ?? 0))/ea".strikeThrough()
                          self.weightUpdateMessageLabel.isHidden = false
                            
                            if (clubPrices?.offerMessage?.contains("FREE"))! {
                                if let endIndex = ClubOfferMessage.range(of: "-")?.lowerBound {
                                    let newString = ClubOfferMessage[..<endIndex]
                                    print(newString)
                                    let end = String.Index(encodedOffset: ClubOfferMessage.count)
                                    var substring = String(ClubOfferMessage[endIndex..<end])
                                    substring.removeFirst()
                                    print(substring)
                                    
                                    self.weightUpdateMessageLabel.attributedText = UcheckoutManager.getSecondAttributedString(String(newString))
                                    
                                    self.offersFreeLabel.attributedText = UcheckoutManager.getOneAttributedString(String(substring))
                                    
                                    print(offersFreeLabel.text)
                                    
                                    
                                }
                                
                            }
                            else if ClubOfferMessage.contains("Save"){
                               
                                self.weightUpdateMessageLabel.text = "\(ClubOfferMessage)"
                                self.weightUpdateMessageLabel.font = weightUpdateMessageLabel.font.withSize(30)
                                self.weightLabelConstraint.constant = 40
                                
                                
                                self.offersFreeLabel.isHidden = true
                            }
                            else {
                                if let endIndex = ClubOfferMessage.range(of: "-")?.lowerBound {
                                    let newString = ClubOfferMessage[..<endIndex]
                                    print(newString)
                                    let end = String.Index(encodedOffset: ClubOfferMessage.count)
                                    var substring = String(ClubOfferMessage[endIndex..<end])
                                    substring.removeFirst()
                                    print(substring)
                                    
                                    self.weightUpdateMessageLabel.attributedText = UcheckoutManager.getSecondAttributedString(String(newString))
                                    
                                    self.offersFreeLabel.attributedText = UcheckoutManager.getOneAttributedString(String(substring))
                                    
                                    print(offersFreeLabel.text)
                                    
                                    
                                }
                            }
                            
                         // self.weightUpdateMessageLabel.text = "Offer: \(clubPrices?.offerMessage ?? " ")"
                          self.weightUpdateMessageLabel.textColor = UIColor.black
                          self.weightUpdateMessageLabel.layer.borderColor = GlobalColor.k87BlackColor.cgColor
                        }
                        

                        
                        
                        self.storeClubPrice = promoPrice
                    }
                    
                }
            case "CE":
                print("Case CE")
                if let clubSellPrice = itemDetail.sellPrice {
                    
                    if clubSellPrice == promoPrice{
                        self.ClubOrRegularPriceLabel.text = "Regular Price"
                        self.regularPriceLabel.isHidden = true
                        self.clubCardPriceLabel.text = "$\(String(format: "%.2f", clubSellPrice))/ea"
                        self.weightUpdateMessageLabel.isHidden = false
                        self.offersImageView.isHidden = false
                        self.clubOfferView.bringSubviewToFront(weightUpdateMessageLabel)
                        self.clubOfferView.sendSubviewToBack(offersImageView)
                        
                        //  MARK:- To view the offer message :
                        
                        if (clubPrices?.offerMessage?.contains("FREE"))! {
                            if let endIndex = ClubOfferMessage.range(of: "-")?.lowerBound {
                                let newString = ClubOfferMessage[..<endIndex]
                                print(newString)
                                let end = String.Index(encodedOffset: ClubOfferMessage.count)
                                var substring = String(ClubOfferMessage[endIndex..<end])
                                substring.removeFirst()
                                print(substring)
                                
                                self.weightUpdateMessageLabel.attributedText = UcheckoutManager.getSecondAttributedString(String(newString))
                                
                                self.offersFreeLabel.attributedText = UcheckoutManager.getOneAttributedString(String(substring))
                                
                                print(offersFreeLabel.text)
                                
                                
                            }
                            
                        }
                        else if ClubOfferMessage.contains("Save"){
                            self.weightUpdateMessageLabel.text = "\(ClubOfferMessage)"
                            self.weightUpdateMessageLabel.font = weightUpdateMessageLabel.font.withSize(30)
                            self.offersFreeLabel.isHidden = true
                        }
                        else {
                            if let endIndex = ClubOfferMessage.range(of: "-")?.lowerBound {
                                let newString = ClubOfferMessage[..<endIndex]
                                print(newString)
                                let end = String.Index(encodedOffset: ClubOfferMessage.count)
                                var substring = String(ClubOfferMessage[endIndex..<end])
                                substring.removeFirst()
                                print(substring)
                                
                                self.weightUpdateMessageLabel.text = "\(newString)"
                                print(weightUpdateMessageLabel.text)
                                self.offersFreeLabel.text = "\(substring)"
                                print(offersFreeLabel.text)
                            }
                        }
                        
                        self.weightUpdateMessageLabel.textColor = UIColor.black
                       self.weightUpdateMessageLabel.layer.borderColor = GlobalColor.k87BlackColor.cgColor
                    }
                    else {
                        self.clubCardPriceLabel.text = "$\(String(format: "%.2f", promoPrice))/ea"
                        self.regularPriceLabel.textColor = UIColor.gray
                        self.regularPriceLabel.attributedText = "$\(String(format: "%.2f", itemDetail.sellPrice ?? 0))/ea".strikeThrough()
                        self.weightUpdateMessageLabel.isHidden = false
                        
                        // MARK :- Offer Message Structure :
                        if (clubPrices?.offerMessage?.contains("FREE"))! {
                            if let endIndex = ClubOfferMessage.range(of: "-")?.lowerBound {
                                let newString = ClubOfferMessage[..<endIndex]
                                print(newString)
                                let end = String.Index(encodedOffset: ClubOfferMessage.count)
                                var substring = String(ClubOfferMessage[endIndex..<end])
                                substring.removeFirst()
                                print(substring)
                                
                                self.weightUpdateMessageLabel.attributedText = UcheckoutManager.getSecondAttributedString(String(newString))
                                
                                self.offersFreeLabel.attributedText = UcheckoutManager.getOneAttributedString(String(substring))
                                
                                print(offersFreeLabel.text)
                                
                                
                            }
                            
                        }
                        else if ClubOfferMessage.contains("Save"){
                            self.weightUpdateMessageLabel.text = "\(ClubOfferMessage)"
                            self.weightUpdateMessageLabel.font = weightUpdateMessageLabel.font.withSize(30)
                            weightLabelConstraint.constant = 40
                            leftOfferImageConstraint.constant = 67
                            rightOfferImageConstraint.constant = 67
                            
                            self.offersFreeLabel.isHidden = true
                        }
                        else {
                            if let endIndex = ClubOfferMessage.range(of: "-")?.lowerBound {
                                let newString = ClubOfferMessage[..<endIndex]
                                print(newString)
                                let end = String.Index(encodedOffset: ClubOfferMessage.count)
                                var substring = String(ClubOfferMessage[endIndex..<end])
                                substring.removeFirst()
                                print(substring)
                                
                                self.weightUpdateMessageLabel.text = "\(newString)"
                                print(weightUpdateMessageLabel.text)
                                self.offersFreeLabel.text = "\(substring)"
                                print(offersFreeLabel.text)
                            }
                        }
                        
                        self.weightUpdateMessageLabel.textColor = UIColor.black
                        self.weightUpdateMessageLabel.layer.borderColor = GlobalColor.k87BlackColor.cgColor
                    }

                    self.storeClubPrice = promoPrice
                }
                
            case "NE":
                print("Case NE")
                
               if let clubSellPrice = itemDetail.sellPrice {
                
                if clubSellPrice == promoPrice{
                    self.ClubOrRegularPriceLabel.text = "Regular Price"
                    self.regularPriceLabel.isHidden = true
                    self.clubCardPriceLabel.text = "$\(String(format: "%.2f", clubSellPrice))/ea"
                    self.weightUpdateMessageLabel.isHidden = false
                    self.offersImageView.isHidden = false
                    self.clubOfferView.bringSubviewToFront(weightUpdateMessageLabel)
                    self.clubOfferView.sendSubviewToBack(offersImageView)

                    
                    // TO check if the offer message has FREE keyword
                    
                    // Offer Message Structure :
                    if (clubPrices?.offerMessage?.contains("FREE"))! {
                        if let endIndex = ClubOfferMessage.range(of: "-")?.lowerBound {
                            let newString = ClubOfferMessage[..<endIndex]
                            print(newString)
                            let end = String.Index(encodedOffset: ClubOfferMessage.count)
                            var substring = String(ClubOfferMessage[endIndex..<end])
                            substring.removeFirst()
                            print(substring)
                            
                        self.weightUpdateMessageLabel.attributedText = UcheckoutManager.getSecondAttributedString(String(newString))
                            
                        self.offersFreeLabel.attributedText = UcheckoutManager.getOneAttributedString(String(substring))
                            
                            self.offersFreeLabel.font = offersFreeLabel.font.withSize(35)
                            self.leftOfferImageConstraint.constant = 67
                            self.rightOfferImageConstraint.constant = 67
                            
                           print(offersFreeLabel.text)
                            

                        }
                        
                    }

                    else {
                    if let endIndex = ClubOfferMessage.range(of: "-")?.lowerBound {
                        let newString = ClubOfferMessage[..<endIndex]
                        print(newString)
                        let end = String.Index(encodedOffset: ClubOfferMessage.count)
                        var substring = String(ClubOfferMessage[endIndex..<end])
                        substring.removeFirst()
                        print(substring)
                        
                        self.weightUpdateMessageLabel.text = "\(newString)"
                        print(weightUpdateMessageLabel.text)
                        self.offersFreeLabel.text = "\(substring)"
                        print(offersFreeLabel.text)
                    }

                    }

                  //  self.weightUpdateMessageLabel.text = "Offer: \(clubPrices?.offerMessage ?? " ")"
                    self.weightUpdateMessageLabel.textColor = UIColor.black
                    self.weightUpdateMessageLabel.layer.borderColor = GlobalColor.k87BlackColor.cgColor
                    self.couponsAvailableLabel.isHidden = false
                    if j4uCoupons == 0 {
                        self.couponsAvailableLabel.isHidden = true
                    }
                    else if j4uCoupons == 1 {
                        self.couponsAvailableLabel.text = "\(j4uCoupons!) Coupon Clipped"
                    }
                    else {
                        self.couponsAvailableLabel.text = "\(j4uCoupons!) Coupons Clipped"
                    }
 
                }
                else {
                    
                    self.clubCardPriceLabel.text = "$\(String(format: "%.2f", promoPrice))/ea"
                    self.regularPriceLabel.textColor = UIColor.gray
                    self.regularPriceLabel.attributedText = "$\(String(format: "%.2f", itemDetail.sellPrice ?? 0))/ea".strikeThrough()
                    self.weightUpdateMessageLabel.isHidden = false
                    self.offersFreeLabel.isHidden = false

                    self.clubOfferView.bringSubviewToFront(weightUpdateMessageLabel)
                    self.clubOfferView.sendSubviewToBack(offersImageView)
                    self.weightUpdateMessageLabel.sizeToFit()
                    
                    if let endIndex = ClubOfferMessage.range(of: "-")?.lowerBound {
                        let newString = ClubOfferMessage[..<endIndex]
                        print(newString)
                        let end = String.Index(encodedOffset: ClubOfferMessage.count)
                        var substring = String(ClubOfferMessage[endIndex..<end])
                        substring.removeFirst()
                        print(substring)
                        
                       // self.weightUpdateMessageLabel.attributedText = UcheckoutManager.getSecondAttributedString(String(newString))
                        self.weightUpdateMessageLabel.text = "\(newString)"
                        self.weightUpdateMessageLabel.font = weightUpdateMessageLabel.font.withSize(25)
                        self.offersFreeLabel.text = "\(substring)"
                        self.offersFreeLabel.font = offersFreeLabel.font.withSize(30)
                        self.leftOfferImageConstraint.constant = 67
                        self.rightOfferImageConstraint.constant = 67
                      //  self.weightLabelConstraint.constant = 30
                       // self.offersFreeLabel.attributedText = UcheckoutManager.getOneAttributedString(String(substring))
                        
                        
                    }
                    
                 //   self.weightUpdateMessageLabel.text = "\(clubPrices?.offerMessage ?? " ")"
                  
                    self.weightUpdateMessageLabel.textColor = UIColor.black
                    self.weightUpdateMessageLabel.layer.borderColor = GlobalColor.k87BlackColor.cgColor
                }
                
                self.storeClubPrice = promoPrice
             //   if let clubSellPrice = clubPrices?.promoPrice{
                    
                    
                    
                    
//                    if let promoFactor = clubPrices?.promoFactor{
//
//                        if clubPrices?.promoPrice == 0{
//                            self.ClubOrRegularPriceLabel.text = "Regular Price"
//                            self.clubCardPriceLabel.text = "$\(String(format: "%.2f", itemDetail.sellPrice!))/ea"
//                            self.regularPriceLabel.isHidden = true
//                        }
//                        else {
//                        if promoFactor == "1"{
//                            self.clubCardPriceLabel.text = "$\(String(format: "%.2f", clubSellPrice))/ea"
//                        }
//                        else{
//                            // Show each price :
//                            let finalClubPrice = clubSellPrice/Double(promoFactor)!
//                            self.clubCardPriceLabel.text = "$\(String(format: "%.2f", finalClubPrice))/ea"
//                        }
//                        }
//                    }
//                    if clubPrices?.promoFactor == "2"{
//                        self.clubCardPriceLabel.text = "$\(String(format: "%.2f", clubSellPrice))/\(clubPrices?.promoFactor)"
//                    }
//                    else {
//                        self.clubCardPriceLabel.text = "$\(String(format: "%.2f", clubSellPrice))/each"
//                    }
                    
                    

//                    self.regularPriceLabel.textColor = UIColor.gray
//                    self.regularPriceLabel.attributedText = "$\(String(format: "%.2f", itemDetail.sellPrice ?? 0))/ea".strikeThrough()
//                    self.weightUpdateMessageLabel.isHidden = false
//                  //  self.weightUpdateMessageLabel.layer.backgroundColor = (UIColor(hexString: "ffff00") as! CGColor)
//                    self.weightUpdateMessageLabel.text = "Offer: \(clubPrices?.offerMessage ?? " ")"
//                    self.weightUpdateMessageLabel.textColor = UIColor.green
//                   // self.totalPriceLabel.isHidden = true
                
//                    clubStackView.layer.borderColor = GlobalColor.kYellowColor.cgColor
//                    clubStackView.layer.borderWidth = 1.0
                }
                
            case "NW":
                print("Case NW")
                
                if let clubSellPrice = itemDetail.sellPrice{
                    if clubSellPrice == promoPrice{
                        self.ClubOrRegularPriceLabel.text = "Regular Price"
                        self.regularPriceLabel.isHidden = true
                        self.clubCardPriceLabel.text = "$\(String(format: "%.2f", clubSellPrice))/lb"
                        self.weightUpdateMessageLabel.isHidden = false
                        self.offersImageView.isHidden = false
                        self.clubOfferView.bringSubviewToFront(weightUpdateMessageLabel)
                        self.clubOfferView.sendSubviewToBack(offersImageView)
                        // MARK :- Offer Message Structure :
                        if (clubPrices?.offerMessage?.contains("FREE"))! {
                            if let endIndex = ClubOfferMessage.range(of: "-")?.lowerBound {
                                let newString = ClubOfferMessage[..<endIndex]
                                print(newString)
                                let end = String.Index(encodedOffset: ClubOfferMessage.count)
                                var substring = String(ClubOfferMessage[endIndex..<end])
                                substring.removeFirst()
                                print(substring)
                                
                                self.weightUpdateMessageLabel.attributedText = UcheckoutManager.getSecondAttributedString(String(newString))
                                
                                self.offersFreeLabel.attributedText = UcheckoutManager.getOneAttributedString(String(substring))
                                
                                print(offersFreeLabel.text)
                                
                                
                            }
                            
                        }
                        else {
                            if let endIndex = ClubOfferMessage.range(of: "-")?.lowerBound {
                                let newString = ClubOfferMessage[..<endIndex]
                                print(newString)
                                let end = String.Index(encodedOffset: ClubOfferMessage.count)
                                var substring = String(ClubOfferMessage[endIndex..<end])
                                substring.removeFirst()
                                print(substring)
                                
                                self.weightUpdateMessageLabel.attributedText = UcheckoutManager.getSecondAttributedString(String(newString))
                                
                                self.offersFreeLabel.attributedText = UcheckoutManager.getOneAttributedString(String(substring))
                                
                                print(offersFreeLabel.text)
                                
                                
                            }
                        }
                       
                        self.weightUpdateMessageLabel.textColor = UIColor.green
                        self.weightUpdateMessageLabel.layer.borderColor = GlobalColor.k87BlackColor.cgColor
                    }
                    else {
                        self.clubCardPriceLabel.text = "$\(String(format: "%.2f", promoPrice))/lb"
                        self.regularPriceLabel.textColor = UIColor.gray
                        self.regularPriceLabel.attributedText = "$\(String(format: "%.2f", itemDetail.sellPrice ?? 0))/lb".strikeThrough()
                        self.weightUpdateMessageLabel.isHidden = false
                        // MARK:- Offer Message Strucure :
                        
                        if (clubPrices?.offerMessage?.contains("FREE"))! {
                            if let endIndex = ClubOfferMessage.range(of: "-")?.lowerBound {
                                let newString = ClubOfferMessage[..<endIndex]
                                print(newString)
                                let end = String.Index(encodedOffset: ClubOfferMessage.count)
                                var substring = String(ClubOfferMessage[endIndex..<end])
                                substring.removeFirst()
                                print(substring)
                                
                                self.weightUpdateMessageLabel.attributedText = UcheckoutManager.getSecondAttributedString(String(newString))
                                
                                self.offersFreeLabel.attributedText = UcheckoutManager.getOneAttributedString(String(substring))
                                
                                print(offersFreeLabel.text)
                                
                                
                            }
                            
                        }
                        else {
                            if let endIndex = ClubOfferMessage.range(of: "-")?.lowerBound {
                                let newString = ClubOfferMessage[..<endIndex]
                                print(newString)
                                let end = String.Index(encodedOffset: ClubOfferMessage.count)
                                var substring = String(ClubOfferMessage[endIndex..<end])
                                substring.removeFirst()
                                print(substring)
                                
                                self.weightUpdateMessageLabel.attributedText = UcheckoutManager.getSecondAttributedString(String(newString))
                                
                                self.offersFreeLabel.attributedText = UcheckoutManager.getOneAttributedString(String(substring))
                                
                                print(offersFreeLabel.text)
                                
                                
                            }
                        }
                        
                        self.weightUpdateMessageLabel.textColor = UIColor.black
                        self.weightUpdateMessageLabel.layer.borderColor = GlobalColor.k87BlackColor.cgColor
                    }
                    
                    self.storeClubPrice = promoPrice
                }
//                if let clubSellPrice = clubPrices?.promoPrice{
//                    if let promoFactor = clubPrices?.promoFactor{
//                        if promoFactor == "1"{
//                            self.clubCardPriceLabel.text = "$\(String(format: "%.2f", clubSellPrice))/lb"
//                        }
//                        else{
//                            self.clubCardPriceLabel.text = "$\(String(format: "%.2f", clubSellPrice))/\(promoFactor) lbs"
//                        }
//                    }
//                   // self.clubCardPriceLabel.text = "$\(String(format: "%.2f", clubSellPrice))/each"
//                    self.regularPriceLabel.textColor = UIColor.gray
//                    self.regularPriceLabel.attributedText = "$\(String(format: "%.2f", itemDetail.sellPrice ?? 0))/ea".strikeThrough()
//                    self.weightUpdateMessageLabel.isHidden = false
//                    self.weightUpdateMessageLabel.text = "Offer: \(clubPrices?.offerMessage ?? " ")"
//                    self.weightUpdateMessageLabel.textColor = UIColor.green
//                   // self.totalPriceLabel.isHidden = true
                
//                }
                
            default:
                break;
            }
        }
        
    }
    
    
    
    private func updateUIForUpdate(){
        
        guard let itemElement = self.itemElement  else {
            return
        }
        guard let item = itemElement.item  else {
            return
        }
        
       
        if let weightItem = item.weightItem , weightItem {
            isItemWeightable = true
            self.weightUpdateMessageLabel.isHidden = false
            self.itemIncartLabel.isHidden = false
            self.weightUpdateMessageLabel.isHidden = false
            self.dropDownButton.isUserInteractionEnabled = false
            self.dropDownButton.layer.borderColor = GlobalColor.klightGreyColor.cgColor
            self.downArrowImageView.isHidden = true
          
            self.updateButton.setTitle("Re-weigh", for: .normal)
           
        }
        if isItemWeightable {
            if isFromScanPage {
                if let itemWeight = itemWeight {
                    self.qyantityNameLabel.text = "Lbs : \(itemWeight)"
                    self.itemIncartLabel.text = "\(itemWeight) lbs in cart"
                     self.updateButton.setTitle("Update", for: .normal)
                    
                }
                else {
                    self.itemIncartLabel.text = " lbs in cart"
                    self.qyantityNameLabel.text = "Lbs : "
                }
            }
            else {
                if let itemWeight = itemElement.weight {
                    self.itemIncartLabel.text = "\(itemWeight) lbs in cart"
                    self.qyantityNameLabel.text = "Lbs : \(itemWeight)"
                }
                else {
                    self.qyantityNameLabel.text = "Lbs : "
                    self.itemIncartLabel.text = " lbs in cart"
                }
            }
            
            
        }
        else {
            
            if  let locItemDetail = itemDetail   {
                if let scancod = locItemDetail.scanCode {
                    if scancod.substring(start: 0, offsetBy: 2) == "02" {
                        self.dropDownButton.isUserInteractionEnabled = false
                        self.dropDownButton.layer.borderColor = GlobalColor.klightGreyColor.cgColor
                        self.downArrowImageView.isHidden = true
                    }
                }
            }
            else {
                if let scancod = itemElement.scanCode {
                    if scancod.substring(start: 0, offsetBy: 2) == "02" {
                        self.dropDownButton.isUserInteractionEnabled = false
                        self.dropDownButton.layer.borderColor = GlobalColor.klightGreyColor.cgColor
                        self.downArrowImageView.isHidden = true
                    }
                }
            }
            
            
          
            if let qunt = itemElement.quantity {
                if isFromScanPage {
                    self.quant = Int(qunt + 1)
                    qyantityNameLabel.attributedText = UcheckoutManager.getAtttributedStringForQuantWithString1("Qty", string2: "\(Int(quant))")
                }
                else if isFromPluPage {
                    self.quant = Int(qunt + 1)
                    qyantityNameLabel.attributedText = UcheckoutManager.getAtttributedStringForQuantWithString1("Qty", string2: "\(Int(quant))")
                }
                else {
                    self.quant = Int(qunt)
                    qyantityNameLabel.attributedText = UcheckoutManager.getAtttributedStringForQuantWithString1("Qty", string2: "\(Int(quant))")
                    self.updateButton.isUserInteractionEnabled = false
                    self.updateButton.alpha = 0.5
                }
               
            }
            else {
                self.qyantityNameLabel.text = "Qty : 1"
            }
            
        }
        if let itemDesc = item.posDescription {
            self.itemDescriptionLabel.text = itemDesc
        }
        if let itemImageURL = item.imageURL {
            
            itemImageView.sd_imageIndicator = SDWebImageActivityIndicator.gray
            itemImageView.sd_setImage(with: URL(string: itemImageURL), placeholderImage: nil)
            
        }
        getPriceForUpdate()
    }
    
    
    private func getPriceForUpdate(){
        guard let itemElement = self.itemElement  else {
            return
        }
        guard let item = itemElement.item  else {
            return
        }
        
        guard  let sellPrice = item.sellPrice else {
            return
        }
        
//        guard let offerMessage = clubPrices?.offerMessage else {
//            return
//        }
        
        guard let offerMessage = item.clubPrice?.offerMessage else {
            return
        }
        
        
        if offerMessage == "false" {
            self.clubCardPriceLabel.isHidden = true
            if isItemWeightable {
                self.regularPriceLabel.text = "$\(String(format: "%.2f", sellPrice))/lb"
                if isFromScanPage {
                    if let itemWt = itemWeight?.toDouble() {
                        let value = (sellPrice * itemWt)
                       // self.totalPriceLabel.text =  "$\(String(format: "%.2f", value))"
                    }
                    else {
                       // self.totalPriceLabel.text =  "$\(String(format: "%.2f", sellPrice))"
                    }
                    
                }
                    
                    
                else if let itemWt = itemElement.weight {
                    self.regularPriceLabel.text =  "$\(String(format: "%.2f", (sellPrice * itemWt)))"
                }
                else {
                    self.regularPriceLabel.text =  "$\(String(format: "%.2f", sellPrice))"
                }
                
            }
            else {
                self.regularPriceLabel.text = "$\(String(format: "%.2f", sellPrice))/ea"
                if let quant = itemElement.quantity {
                    if isFromScanPage {
                        self.regularPriceLabel.text = "$\(String(format: "%.2f", (sellPrice * (quant + 1))))"
                    }
                    else {
                        self.regularPriceLabel.text = "$\(String(format: "%.2f", (sellPrice * (quant))))"
                    }
                }
                else {
                    self.regularPriceLabel.text = "$\(String(format: "%.2f", sellPrice))"
                }
                
            }
            self.clubCardPriceLabel.isHidden = true
            self.regularPriceLabel.textColor = UIColor.black
            self.ClubOrRegularPriceLabel.text = "Regular Price"
            self.ClubOrRegularPriceLabel.textColor = UIColor.black
            self.offersFreeLabel.isHidden = true
            self.clubOfferView.isHidden = true
            
            if let updatej4uCoupons = item.jfuOfferCount {
                if updatej4uCoupons == 0 {
                    self.couponsAvailableLabel.isHidden = true
                }
                else if updatej4uCoupons == 1 {
                    self.couponsAvailableLabel.text = "\(updatej4uCoupons) Coupon Clipped"
                }
                else {
                    self.couponsAvailableLabel.text = "\(updatej4uCoupons) Coupons Clipped"
                }
            }
            
        } else {
            getClubCardPriceForUpdate()
        }
        
       
        
        
    }
    
    private func getClubCardPriceForUpdate() {
        
        guard let itemElement = self.itemElement  else {
            return
        }
        guard let item = itemElement.item  else {
            return
        }
        
        guard let promoMethod = item.clubPrice?.promoMethod else {
            return
        }
        
        guard let promoPrice = item.clubPrice?.promoPrice else {
            return
        }
        
        guard let updateOfferMessage = item.clubPrice?.offerMessage else {
            return
        }
        
        guard let UpdateRegularPrice = item.regular_price else {
            return
        }

        self.weightUpdateMessageLabel.isHidden = false
        // MARK:- To be worked on :
       // self.weightUpdateMessageLabel.text = clubPrices?.offerMessage ?? ""
        self.regularPriceLabel.attributedText = "$\(String(format: "%.2f", item.sellPrice ?? 0))".strikeThrough()
        self.regularPriceLabel.textColor = UIColor.gray
      //  self.ClubOrRegularPriceLabel.text = "Club Card Price"

        
        if isItemWeightable {
            self.clubCardPriceLabel.text = "$\(String(format: "%.2f", promoPrice))"
            
        } else {
            switch promoMethod {
            case "PE":
                print("Case PE")
                if let quants = item.sellMultiple {
                    if let clubSellPrice = item.sellPrice {
                        if clubSellPrice == promoPrice {
                            self.ClubOrRegularPriceLabel.text = "Regular Price"
                            self.clubCardPriceLabel.text = "$\(String(format: "%.2f", clubSellPrice))/ea"
                            self.regularPriceLabel.isHidden = true
                            self.weightUpdateMessageLabel.isHidden = false
                            self.offersImageView.isHidden = false
                            self.clubOfferView.bringSubviewToFront(weightUpdateMessageLabel)
                            self.clubOfferView.sendSubviewToBack(offersImageView)
                            // MARK:- Offer Messge Strucure :
                            if (updateOfferMessage.contains("FREE")) {
                                if let endIndex = updateOfferMessage.range(of: "-")?.lowerBound {
                                    let newString = updateOfferMessage[..<endIndex]
                                    print(newString)
                                    let end = String.Index(encodedOffset: updateOfferMessage.count)
                                    var substring = String(updateOfferMessage[endIndex..<end])
                                    substring.removeFirst()
                                    print(substring)
                                    
                                    self.weightUpdateMessageLabel.attributedText = UcheckoutManager.getSecondAttributedString(String(newString))
                                    
                                    self.offersFreeLabel.attributedText = UcheckoutManager.getOneAttributedString(String(substring))
                                    
                                    print(offersFreeLabel.text)
                                    
                                    
                                }
                                
                            }
                                
                            else if updateOfferMessage.contains("Save"){
                                self.weightUpdateMessageLabel.text = "\(updateOfferMessage)"
                                self.offersFreeLabel.isHidden = true
                            }
                            else {
                                if let endIndex = updateOfferMessage.range(of: "-")?.lowerBound {
                                    let newString = updateOfferMessage[..<endIndex]
                                    print(newString)
                                    let end = String.Index(encodedOffset: updateOfferMessage.count)
                                    var substring = String(updateOfferMessage[endIndex..<end])
                                    substring.removeFirst()
                                    print(substring)
                                    
                                    self.weightUpdateMessageLabel.attributedText = UcheckoutManager.getSecondAttributedString(String(newString))
                                    
                                    self.offersFreeLabel.attributedText = UcheckoutManager.getOneAttributedString(String(substring))
                                    self.offersFreeLabel.font = offersFreeLabel.font.withSize(30)
                                    
                                    print(offersFreeLabel.text)
                                    
                                    
                                }
                            }
                            
                            self.weightUpdateMessageLabel.textColor = UIColor.black
                            self.weightUpdateMessageLabel.layer.borderColor = GlobalColor.k87BlackColor.cgColor
                            self.couponsAvailableLabel.isHidden = false
                            
                            if let updatej4uCoupons = item.jfuOfferCount {
                                if updatej4uCoupons == 0 {
                                    self.couponsAvailableLabel.isHidden = true
                                }
                                else if updatej4uCoupons == 1 {
                                    self.couponsAvailableLabel.text = "\(updatej4uCoupons) Coupon Clipped"
                                }
                                else {
                                    self.couponsAvailableLabel.text = "\(updatej4uCoupons) Coupons Clipped"
                                }
                            }
                            
                        }
                        
                        else if promoPrice == UpdateRegularPrice {
                            self.ClubOrRegularPriceLabel.text = "Regular Price"
                            self.clubCardPriceLabel.text = "$\(String(format: "%.2f", promoPrice))/ea"
                            self.regularPriceLabel.isHidden = true
                            
                            // Display Offer Messages :
                            self.weightUpdateMessageLabel.isHidden = false
                            self.offersImageView.isHidden = false
                            self.clubOfferView.bringSubviewToFront(weightUpdateMessageLabel)
                            self.clubOfferView.sendSubviewToBack(offersImageView)
                            // MARK: - Offer Message Structure :
                            if (updateOfferMessage.contains("FREE")) {
                                if let endIndex = updateOfferMessage.range(of: "-")?.lowerBound {
                                    let newString = updateOfferMessage[..<endIndex]
                                    print(newString)
                                    let end = String.Index(encodedOffset: updateOfferMessage.count)
                                    var substring = String(updateOfferMessage[endIndex..<end])
                                    substring.removeFirst()
                                    print(substring)
                                    
                                    self.weightUpdateMessageLabel.attributedText = UcheckoutManager.getSecondAttributedString(String(newString))
                                    
                                    self.offersFreeLabel.attributedText = UcheckoutManager.getOneAttributedString(String(substring))
                                    
                                    print(offersFreeLabel.text)
                                    
                                    
                                }
                                
                            }
                                
                            else if updateOfferMessage.contains("Save"){
                                self.weightUpdateMessageLabel.text = "\(updateOfferMessage)"
                                self.offersFreeLabel.isHidden = true
                            }
                                
                            else {
                                if let endIndex = updateOfferMessage.range(of: "-")?.lowerBound {
                                    let newString = updateOfferMessage[..<endIndex]
                                    print(newString)
                                    let end = String.Index(encodedOffset: updateOfferMessage.count)
                                    var substring = String(updateOfferMessage[endIndex..<end])
                                    substring.removeFirst()
                                    print(substring)
                                    
                                    self.weightUpdateMessageLabel.attributedText = UcheckoutManager.getSecondAttributedString(String(newString))
                                    
                                    self.offersFreeLabel.attributedText = UcheckoutManager.getOneAttributedString(String(substring))
                                    
                                    print(offersFreeLabel.text)
                                    
                                    
                                }
                            }
                            self.weightUpdateMessageLabel.textColor = UIColor.black
                            self.weightUpdateMessageLabel.layer.borderColor = GlobalColor.k87BlackColor.cgColor
                            self.couponsAvailableLabel.isHidden = false
                            
                            if let updatej4uCoupons = item.jfuOfferCount {
                                if updatej4uCoupons == 0 {
                                    self.couponsAvailableLabel.isHidden = true
                                }
                                else if updatej4uCoupons == 1 {
                                    self.couponsAvailableLabel.text = "\(updatej4uCoupons) Coupon Clipped"
                                }
                                else {
                                    self.couponsAvailableLabel.text = "\(updatej4uCoupons) Coupons Clipped"
                                }
                            }
                            
                        }
                        else {
                            self.ClubOrRegularPriceLabel.text = "Club Price"
                            self.clubCardPriceLabel.text = "$\(String(format: "%.2f", promoPrice))/ea"
                            self.regularPriceLabel.attributedText = "$\(String(format: "%.2f", UpdateRegularPrice))/ea".strikeThrough()
                            
                            // MARK:- To Display Offer Messages :
                            
                            if (updateOfferMessage.contains("FREE")) {
                                if let endIndex = updateOfferMessage.range(of: "-")?.lowerBound {
                                    let newString = updateOfferMessage[..<endIndex]
                                    print(newString)
                                    let end = String.Index(encodedOffset: updateOfferMessage.count)
                                    var substring = String(updateOfferMessage[endIndex..<end])
                                    substring.removeFirst()
                                    print(substring)
                                    
                                    self.weightUpdateMessageLabel.attributedText = UcheckoutManager.getSecondAttributedString(String(newString))
                                    
                                    self.offersFreeLabel.attributedText = UcheckoutManager.getOneAttributedString(String(substring))
                                    
                                    print(offersFreeLabel.text)
                                    
                                    
                                }
                                
                            }
                            else if updateOfferMessage.contains("Save"){
                                self.weightUpdateMessageLabel.text = "\(updateOfferMessage)"
                                self.offersFreeLabel.isHidden = true
                            }
                            else {
                                
                                if let endIndex = updateOfferMessage.range(of: "-")?.lowerBound {
                                    let newString = updateOfferMessage[..<endIndex]
                                    print(newString)
                                    let end = String.Index(encodedOffset: updateOfferMessage.count)
                                    var substring = String(updateOfferMessage[endIndex..<end])
                                    substring.removeFirst()
                                    print(substring)
                                    
                                    self.weightUpdateMessageLabel.attributedText = UcheckoutManager.getSecondAttributedString(String(newString))
                                    
                                    self.offersFreeLabel.attributedText = UcheckoutManager.getOneAttributedString(String(substring))
                                    
                                    
                                }
                                
                            }
                            
                            self.weightUpdateMessageLabel.textColor = UIColor.black
                            self.weightUpdateMessageLabel.layer.borderColor = GlobalColor.k87BlackColor.cgColor
                            self.couponsAvailableLabel.isHidden = false
                            
                            if let updatej4uCoupons = item.jfuOfferCount {
                                if updatej4uCoupons == 0 {
                                    self.couponsAvailableLabel.isHidden = true
                                }
                                else if updatej4uCoupons == 1 {
                                    self.couponsAvailableLabel.text = "\(updatej4uCoupons) Coupon Clipped"
                                }
                                else {
                                    self.couponsAvailableLabel.text = "\(updatej4uCoupons) Coupons Clipped"
                                }
                            }
                        }
                        
                       // let finalClubPrice = (clubSellPrice * Double(quants) * promoPrice)/100
//                        self.clubCardPriceLabel.text = "$\(String(format: "%.2f", promoPrice))/ea"
//                        self.regularPriceLabel.attributedText = "$\(String(format: "%.2f", clubSellPrice))/ea".strikeThrough()
                      //  self.totalPriceLabel.text = "$\(String(format: "%.2f", finalClubPrice))/ea"
                        self.storeClubPrice = promoPrice
                    }
                    
                }
            case "CE":
                print("Case CE")
                if let clubSellPrice = item.sellPrice {
                    if clubSellPrice == promoPrice {
                        self.ClubOrRegularPriceLabel.text = "Regular Price"
                        self.clubCardPriceLabel.text = "$\(String(format: "%.2f", clubSellPrice))/ea"
                        self.regularPriceLabel.isHidden = true
                        self.weightUpdateMessageLabel.isHidden = false
                        self.offersImageView.isHidden = false
                        self.clubOfferView.bringSubviewToFront(weightUpdateMessageLabel)
                        self.clubOfferView.sendSubviewToBack(offersImageView)
                        // MARK:- Offer Messge Strucure :
                        if (updateOfferMessage.contains("FREE")) {
                            if let endIndex = updateOfferMessage.range(of: "-")?.lowerBound {
                                let newString = updateOfferMessage[..<endIndex]
                                print(newString)
                                let end = String.Index(encodedOffset: updateOfferMessage.count)
                                var substring = String(updateOfferMessage[endIndex..<end])
                                substring.removeFirst()
                                print(substring)
                                
                                self.weightUpdateMessageLabel.attributedText = UcheckoutManager.getSecondAttributedString(String(newString))
                                
                                self.offersFreeLabel.attributedText = UcheckoutManager.getOneAttributedString(String(substring))
                                
                                print(offersFreeLabel.text)
                                
                                
                            }
                            
                        }
                        else if updateOfferMessage.contains("Save"){
                            self.weightUpdateMessageLabel.text = "\(updateOfferMessage)"
                            self.offersFreeLabel.isHidden = true
                        }
                        else {
                            if let endIndex = updateOfferMessage.range(of: "-")?.lowerBound {
                                let newString = updateOfferMessage[..<endIndex]
                                print(newString)
                                let end = String.Index(encodedOffset: updateOfferMessage.count)
                                var substring = String(updateOfferMessage[endIndex..<end])
                                substring.removeFirst()
                                print(substring)
                                
                                self.weightUpdateMessageLabel.attributedText = UcheckoutManager.getSecondAttributedString(String(newString))
                                
                                self.offersFreeLabel.attributedText = UcheckoutManager.getOneAttributedString(String(substring))
                                
                                print(offersFreeLabel.text)
                                
                                
                            }
                        }
                        
                        self.weightUpdateMessageLabel.textColor = UIColor.black
                        self.weightUpdateMessageLabel.layer.borderColor = GlobalColor.k87BlackColor.cgColor
                        self.couponsAvailableLabel.isHidden = false
                        
                        if let updatej4uCoupons = item.jfuOfferCount {
                            if updatej4uCoupons == 0 {
                                self.couponsAvailableLabel.isHidden = true
                            }
                            else if updatej4uCoupons == 1 {
                                self.couponsAvailableLabel.text = "\(updatej4uCoupons) Coupon Clipped"
                            }
                            else {
                                self.couponsAvailableLabel.text = "\(updatej4uCoupons) Coupons Clipped"
                            }
                        }
                        
                    }
                    else if promoPrice == UpdateRegularPrice {
                        self.ClubOrRegularPriceLabel.text = "Regular Price"
                        self.clubCardPriceLabel.text = "$\(String(format: "%.2f", promoPrice))/ea"
                        self.regularPriceLabel.isHidden = true
                        
                        // Display Offer Messages :
                        self.weightUpdateMessageLabel.isHidden = false
                        self.offersImageView.isHidden = false
                        self.clubOfferView.bringSubviewToFront(weightUpdateMessageLabel)
                        self.clubOfferView.sendSubviewToBack(offersImageView)
                        // MARK: - Offer Message Structure :
                        if (updateOfferMessage.contains("FREE")) {
                            if let endIndex = updateOfferMessage.range(of: "-")?.lowerBound {
                                let newString = updateOfferMessage[..<endIndex]
                                print(newString)
                                let end = String.Index(encodedOffset: updateOfferMessage.count)
                                var substring = String(updateOfferMessage[endIndex..<end])
                                substring.removeFirst()
                                print(substring)
                                
                                self.weightUpdateMessageLabel.attributedText = UcheckoutManager.getSecondAttributedString(String(newString))
                                
                                self.offersFreeLabel.attributedText = UcheckoutManager.getOneAttributedString(String(substring))
                                
                                print(offersFreeLabel.text)
                                
                                
                            }
                            
                        }
                            
                        else {
                            if let endIndex = updateOfferMessage.range(of: "-")?.lowerBound {
                                let newString = updateOfferMessage[..<endIndex]
                                print(newString)
                                let end = String.Index(encodedOffset: updateOfferMessage.count)
                                var substring = String(updateOfferMessage[endIndex..<end])
                                substring.removeFirst()
                                print(substring)
                                
                                self.weightUpdateMessageLabel.attributedText = UcheckoutManager.getSecondAttributedString(String(newString))
                                
                                self.offersFreeLabel.attributedText = UcheckoutManager.getOneAttributedString(String(substring))
                                
                                print(offersFreeLabel.text)
                                
                                
                            }
                        }
                        self.weightUpdateMessageLabel.textColor = UIColor.black
                        self.weightUpdateMessageLabel.layer.borderColor = GlobalColor.k87BlackColor.cgColor
                        self.couponsAvailableLabel.isHidden = false
                        
                        if let updatej4uCoupons = item.jfuOfferCount {
                            if updatej4uCoupons == 0 {
                                self.couponsAvailableLabel.isHidden = true
                            }
                            else if updatej4uCoupons == 1 {
                                self.couponsAvailableLabel.text = "\(updatej4uCoupons) Coupon Clipped"
                            }
                            else {
                                self.couponsAvailableLabel.text = "\(updatej4uCoupons) Coupons Clipped"
                            }
                        }
                        
                    }
                    else {
                        self.ClubOrRegularPriceLabel.text = "Club Price"
                        self.clubCardPriceLabel.text = "$\(String(format: "%.2f", promoPrice))/ea"
                        self.regularPriceLabel.attributedText = "$\(String(format: "%.2f", UpdateRegularPrice))/ea".strikeThrough()
                        
                        // MARK:- To Display Offer Messages :
                        
                        if (updateOfferMessage.contains("FREE")) {
                            if let endIndex = updateOfferMessage.range(of: "-")?.lowerBound {
                                let newString = updateOfferMessage[..<endIndex]
                                print(newString)
                                let end = String.Index(encodedOffset: updateOfferMessage.count)
                                var substring = String(updateOfferMessage[endIndex..<end])
                                substring.removeFirst()
                                print(substring)
                                
                                self.weightUpdateMessageLabel.attributedText = UcheckoutManager.getSecondAttributedString(String(newString))
                                
                                self.offersFreeLabel.attributedText = UcheckoutManager.getOneAttributedString(String(substring))
                                
                                print(offersFreeLabel.text)
                                
                                
                            }
                            
                        }
                        else if updateOfferMessage.contains("Save"){
                            self.weightUpdateMessageLabel.text = "\(updateOfferMessage)"
                            self.offersFreeLabel.isHidden = true
                        }

                        else {
                            
                            if let endIndex = updateOfferMessage.range(of: "-")?.lowerBound {
                                let newString = updateOfferMessage[..<endIndex]
                                print(newString)
                                let end = String.Index(encodedOffset: updateOfferMessage.count)
                                var substring = String(updateOfferMessage[endIndex..<end])
                                substring.removeFirst()
                                print(substring)
                                
                                self.weightUpdateMessageLabel.attributedText = UcheckoutManager.getSecondAttributedString(String(newString))
                                
                                self.offersFreeLabel.attributedText = UcheckoutManager.getOneAttributedString(String(substring))
                                
                                
                            }

                        }
                        
                        self.weightUpdateMessageLabel.textColor = UIColor.black
                        self.weightUpdateMessageLabel.layer.borderColor = GlobalColor.k87BlackColor.cgColor
                        self.couponsAvailableLabel.isHidden = false
                        
                        if let updatej4uCoupons = item.jfuOfferCount {
                            if updatej4uCoupons == 0 {
                                self.couponsAvailableLabel.isHidden = true
                            }
                            else if updatej4uCoupons == 1 {
                                self.couponsAvailableLabel.text = "\(updatej4uCoupons) Coupon Clipped"
                            }
                            else {
                                self.couponsAvailableLabel.text = "\(updatej4uCoupons) Coupons Clipped"
                            }
                        }
                    }
                   // let finalClubPrice = (clubSellPrice - promoPrice)
//                    self.clubCardPriceLabel.text = "$\(String(format: "%.2f", promoPrice))/ea"
//                    self.regularPriceLabel.attributedText = "$\(String(format: "%.2f", clubSellPrice))/ea".strikeThrough()
                  //  self.totalPriceLabel.text = "$\(String(format: "%.2f", finalClubPrice))/ea"
                    self.storeClubPrice = promoPrice
                }
                
            case "NE" :
                print("Case NE")
                if let clubSellPrice = item.sellPrice {
                    if clubSellPrice == promoPrice {
                        self.ClubOrRegularPriceLabel.text = "Regular Price"
                        self.clubCardPriceLabel.text = "$\(String(format: "%.2f", clubSellPrice))/ea"
                        self.regularPriceLabel.isHidden = true
                        self.weightUpdateMessageLabel.isHidden = false
                        self.offersImageView.isHidden = false
                        self.clubOfferView.bringSubviewToFront(weightUpdateMessageLabel)
                        self.clubOfferView.sendSubviewToBack(offersImageView)
                        
                        // To Check the Message Structure and to Display it in a proper way.
//                        if (updateOfferMessage.contains("Must")){
//                            let freeTrimString = updateOfferMessage.substring(start: 28, offsetBy: 8)
//                            let offerTrimString = updateOfferMessage.substring(start: 0, offsetBy: 28)
//
//                            self.weightUpdateMessageLabel.text = "\(offerTrimString ?? " ")"
//                            self.offersFreeLabel.text = "\(freeTrimString ?? " ")"
//                        }
//                        else if (updateOfferMessage.contains("or more")) {
//                            if let endIndex = updateOfferMessage.range(of: "get")?.lowerBound {
//                                let newString = updateOfferMessage[..<endIndex]
//                                print(newString)
//                                let end = String.Index(encodedOffset: updateOfferMessage.count)
//                                let substring = String(updateOfferMessage[endIndex..<end])
//                                print(substring)
//
//                                self.weightUpdateMessageLabel.text = "\(newString)"
//                                self.offersFreeLabel.text = "\(substring)"
//                            }
//                        }
                         if (updateOfferMessage.contains("FREE")) {
                            if let endIndex = updateOfferMessage.range(of: "-")?.lowerBound {
                                let newString = updateOfferMessage[..<endIndex]
                                print(newString)
                                let end = String.Index(encodedOffset: updateOfferMessage.count)
                                var substring = String(updateOfferMessage[endIndex..<end])
                                substring.removeFirst()
                                print(substring)
                                
                                self.weightUpdateMessageLabel.attributedText = UcheckoutManager.getSecondAttributedString(String(newString))
                                
                                self.offersFreeLabel.attributedText = UcheckoutManager.getOneAttributedString(String(substring))
                                
                                self.offersFreeLabel.font = offersFreeLabel.font.withSize(35)
                                self.leftOfferImageConstraint.constant = 67
                                self.rightOfferImageConstraint.constant = 67
                                
                                print(offersFreeLabel.text)
                                
                                
                            }
                            
                        }
                        else {
                            if let endIndex = updateOfferMessage.range(of: "-")?.lowerBound {
                                let newString = updateOfferMessage[..<endIndex]
                                print(newString)
                                let end = String.Index(encodedOffset: updateOfferMessage.count)
                                var substring = String(updateOfferMessage[endIndex..<end])
                                substring.removeFirst()
                                print(substring)
                                
                                self.weightUpdateMessageLabel.attributedText = UcheckoutManager.getSecondAttributedString(String(newString))
                                
                                self.offersFreeLabel.attributedText = UcheckoutManager.getOneAttributedString(String(substring))
                                
                                print(offersFreeLabel.text)
                                
                                
                            }
                        }
                        
                        self.weightUpdateMessageLabel.textColor = UIColor.black
                        self.weightUpdateMessageLabel.layer.borderColor = GlobalColor.k87BlackColor.cgColor
                        self.couponsAvailableLabel.isHidden = false
                        
                        if let updatej4uCoupons = item.jfuOfferCount {
                            if updatej4uCoupons == 0 {
                                self.couponsAvailableLabel.isHidden = true
                            }
                            else if updatej4uCoupons == 1 {
                                self.couponsAvailableLabel.text = "\(updatej4uCoupons) Coupon Clipped"
                            }
                            else {
                                self.couponsAvailableLabel.text = "\(updatej4uCoupons) Coupons Clipped"
                            }
                        }

                    }
                    else if promoPrice == UpdateRegularPrice {
                        self.ClubOrRegularPriceLabel.text = "Regular Price"
                        self.clubCardPriceLabel.text = "$\(String(format: "%.2f", promoPrice))/ea"
                        self.regularPriceLabel.isHidden = true
                        
                        // Display Offer Messages :
                        self.weightUpdateMessageLabel.isHidden = false
                        self.offersImageView.isHidden = false
                        self.clubOfferView.bringSubviewToFront(weightUpdateMessageLabel)
                        self.clubOfferView.sendSubviewToBack(offersImageView)
                        
                        // To Check the Message Structure and to Display it in a proper way.
//                        if (updateOfferMessage.contains("Must")){
//                            let freeTrimString = updateOfferMessage.substring(start: 28, offsetBy: 8)
//                            let offerTrimString = updateOfferMessage.substring(start: 0, offsetBy: 28)
//
//                            self.weightUpdateMessageLabel.text = "\(offerTrimString ?? " ")"
//                            self.offersFreeLabel.text = "\(freeTrimString ?? " ")"
//                        }
//                        else if (updateOfferMessage.contains("or more")) {
//                            let freeTrimString = updateOfferMessage.substring(start: 16, offsetBy: 12)
//                            let offerTrimString = updateOfferMessage.substring(start: 0, offsetBy: 16)
//                            self.weightUpdateMessageLabel.text = "\(offerTrimString ?? " ")"
//                            self.offersFreeLabel.text = "\(freeTrimString ?? " ")"
//                        }
                          if (updateOfferMessage.contains("FREE")) {
                            if let endIndex = updateOfferMessage.range(of: "-")?.lowerBound {
                                let newString = updateOfferMessage[..<endIndex]
                                print(newString)
                                let end = String.Index(encodedOffset: updateOfferMessage.count)
                                var substring = String(updateOfferMessage[endIndex..<end])
                                substring.removeFirst()
                                print(substring)
                                
                                self.weightUpdateMessageLabel.attributedText = UcheckoutManager.getSecondAttributedString(String(newString))
                                
                                self.offersFreeLabel.attributedText = UcheckoutManager.getOneAttributedString(String(substring))
                                
                                print(offersFreeLabel.text)
                                
                                
                            }
                            
                        }

                        else {
                            if let endIndex = updateOfferMessage.range(of: "-")?.lowerBound {
                                let newString = updateOfferMessage[..<endIndex]
                                print(newString)
                                let end = String.Index(encodedOffset: updateOfferMessage.count)
                                var substring = String(updateOfferMessage[endIndex..<end])
                                substring.removeFirst()
                                print(substring)
                                
                                self.weightUpdateMessageLabel.attributedText = UcheckoutManager.getSecondAttributedString(String(newString))
                                
                                self.offersFreeLabel.attributedText = UcheckoutManager.getOneAttributedString(String(substring))
                                
                                print(offersFreeLabel.text)
                                
                                
                            }
                        }
                        self.weightUpdateMessageLabel.textColor = UIColor.black
                        self.weightUpdateMessageLabel.layer.borderColor = GlobalColor.k87BlackColor.cgColor
                        self.couponsAvailableLabel.isHidden = false
                        
                        if let updatej4uCoupons = item.jfuOfferCount {
                            if updatej4uCoupons == 0 {
                                self.couponsAvailableLabel.isHidden = true
                            }
                            else if updatej4uCoupons == 1 {
                                self.couponsAvailableLabel.text = "\(updatej4uCoupons) Coupon Clipped"
                            }
                            else {
                                self.couponsAvailableLabel.text = "\(updatej4uCoupons) Coupons Clipped"
                            }
                        }
                        
                    }
                    else {
                        self.ClubOrRegularPriceLabel.text = "Club Price"
                        self.clubCardPriceLabel.text = "$\(String(format: "%.2f", promoPrice))/ea"
                        self.regularPriceLabel.attributedText = "$\(String(format: "%.2f", UpdateRegularPrice))/ea".strikeThrough()
                        
                        // MARK:- To Display Offer Messages :
                        
                        if (updateOfferMessage.contains("FREE")) {
                            if let endIndex = updateOfferMessage.range(of: "-")?.lowerBound {
                                let newString = updateOfferMessage[..<endIndex]
                                print(newString)
                                let end = String.Index(encodedOffset: updateOfferMessage.count)
                                var substring = String(updateOfferMessage[endIndex..<end])
                                substring.removeFirst()
                                print(substring)
                                
                                self.weightUpdateMessageLabel.attributedText = UcheckoutManager.getSecondAttributedString(String(newString))
                                
                                self.offersFreeLabel.attributedText = UcheckoutManager.getOneAttributedString(String(substring))
                                
                                print(offersFreeLabel.text)
                                
                                
                            }
                            
                        }
                        
//                        if (updateOfferMessage.contains("Must")){
//                            let freeTrimString = updateOfferMessage.substring(start: 28, offsetBy: 8)
//                            let offerTrimString = updateOfferMessage.substring(start: 0, offsetBy: 28)
//
//                            self.weightUpdateMessageLabel.text = "\(offerTrimString ?? " ")"
//                            self.offersFreeLabel.text = "\(freeTrimString ?? " ")"
//                        }
//                        else if (updateOfferMessage.contains("or more")) {
//                            let freeTrimString = updateOfferMessage.substring(start: 16, offsetBy: 12)
//                            let offerTrimString = updateOfferMessage.substring(start: 0, offsetBy: 16)
//                            self.weightUpdateMessageLabel.text = "\(offerTrimString ?? " ")"
//                            self.offersFreeLabel.text = "\(freeTrimString ?? " ")"
//                        }
                        else {
                            
                            if let endIndex = updateOfferMessage.range(of: "-")?.lowerBound {
                                let newString = updateOfferMessage[..<endIndex]
                                print(newString)
                                let end = String.Index(encodedOffset: updateOfferMessage.count)
                                var substring = String(updateOfferMessage[endIndex..<end])
                                substring.removeFirst()
                                print(substring)
                                
                                
                                self.weightUpdateMessageLabel.text = "\(newString)"
                                self.weightUpdateMessageLabel.font = weightUpdateMessageLabel.font.withSize(25)
                                self.offersFreeLabel.text = "\(substring)"
                                self.offersFreeLabel.font = offersFreeLabel.font.withSize(30)
                                self.leftOfferImageConstraint.constant = 67
                                self.rightOfferImageConstraint.constant = 67

                                
                              //  self.weightUpdateMessageLabel.attributedText = UcheckoutManager.getSecondAttributedString(String(newString))
                                
                              //  self.offersFreeLabel.attributedText = UcheckoutManager.getOneAttributedString(String(substring))
                                
                                
                            }
                            
                            
//                            let freeTrimString = updateOfferMessage.substring(start: 12, offsetBy: 4)
//
//                            let offerTrimString = updateOfferMessage.substring(start: 0, offsetBy: 11)
//
//                            self.weightUpdateMessageLabel.text = "\(offerTrimString ?? " ")"
//                            self.offersFreeLabel.text = "\(freeTrimString ?? " ")"
                        }
                        
                        self.weightUpdateMessageLabel.textColor = UIColor.black
                        self.weightUpdateMessageLabel.layer.borderColor = GlobalColor.k87BlackColor.cgColor
                        self.couponsAvailableLabel.isHidden = false
                        
                        if let updatej4uCoupons = item.jfuOfferCount {
                            if updatej4uCoupons == 0 {
                                self.couponsAvailableLabel.isHidden = true
                            }
                            else if updatej4uCoupons == 1 {
                                self.couponsAvailableLabel.text = "\(updatej4uCoupons) Coupon Clipped"
                            }
                            else {
                                self.couponsAvailableLabel.text = "\(updatej4uCoupons) Coupons Clipped"
                            }
                        }
                    }
                    
                    self.storeClubPrice = promoPrice
                }
                
            case "NW":
                print("Case NW")
                if let clubSellPrice = item.sellPrice {
                    self.clubCardPriceLabel.text = "$\(String(format: "%.2f", promoPrice))/ea"
                    self.regularPriceLabel.attributedText = "$\(String(format: "%.2f", clubSellPrice))/ea".strikeThrough()
                    self.storeClubPrice = promoPrice
                }
                
                
            default:
                break;
            }
            
        }
        
    }
    
    
    
    
    
    @objc func deleteBarButtonItemClicked(){
        
    }
    
    private func addButtonAction(){
        FirebaseEventmanger.logEventWithName(AnalyticsEventAddToCart, andCustomAttributes: ["build_number":UIDevice().appShortVersion,"page":"ItemLookUpViewController","event_day_of_week":UcheckoutManager.getDay()])
        let dict = getNewAddPramaDict()
       // let newDict = clubNewDict()
        if dict.count == 0 {
            return
        }
        // UcheckoutManager.getScanAndGoDevJSCompleteURl
        // UcheckoutManager.getCompleteURl
        // UcheckoutManager.getScanAndGoDevJSCompleteURl
        
        itemLookUpViewModel.addItemToCart(strUrl: UcheckoutManager.getScanAndGoDevJSCompleteURl("/addItemToCart"), params: dict, parentViewController: self) { (success, response, message) in
            DispatchQueue.main.async {
                if success {
                    if let response = response {
                        if let ack = response.ack {
                            if ack == "0" {
                                
                                DispatchQueue.main.async {
                                    if let cartVC = UIStoryboard.cart.instantiateViewController(withIdentifier: "CartBaseViewController") as? CartBaseViewController {
                                        self.navigationController?.pushViewController(cartVC, animated: true)
                                    }
                                }
                                
                            }
                            else if ack == "1"{
                                if let errors = response.errors {
                                    if errors.count > 0 {
                                        if let message = errors.first?.message {
                                            if let category = errors.first?.category , category == "max_item_reached" {
                                                let swiftMessageBaseClass = SwiftMessageBaseClass()
                                                swiftMessageBaseClass.showErrorMessage(title: "Alert", body: message, isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                                                swiftMessageBaseClass.swiftMessageBaseClassProtocol = self
                                            }
                                            else {
                                                SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: message , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                                            }
                                            
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                }
                else {
                    SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: message! , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                }
            }
            
        }
        
    }

    
    private func  getNewAddPramaDict() -> [String:Any] {

        if let cartCaseState = cartCaseState {
            
            switch cartCaseState {
            case .Add:
                guard let locItemDetail = itemDetail else {
                    fatalError()
                }
                
                guard let clubPriceDetail = clubPrices else {
                    fatalError()
                }


                if isItemWeightable {
                    
                    if let clubPricesWeighItems = clubPrices{
                        if clubPricesWeighItems.offerMessage == "false" {
                            
                            let parameters = [
                                "item_id": locItemDetail.itemID ?? "",
                                "upc_type": upcType?.rawValue ?? "",
                                "scan_code": locItemDetail.scanCode ?? "",
                                "quantity" : 0,
                                "weight": itemWeight?.toDouble() ?? 0,
                                ] as [String : Any]
                            return parameters
                        }
                        
                        else{
                            let parameters = [
                                "item_id": locItemDetail.itemID ?? "",
                                "upc_type": upcType?.rawValue ?? "",
                                "scan_code": locItemDetail.scanCode ?? "",
                                "quantity" : 0,
                                "weight": itemWeight?.toDouble() ?? 0,
                                "jfuOfferCount": j4uCoupons!,
                                "clubPrice": ["promoMinQty" : clubPricesWeighItems.promoMinQty!,
                                              "promoMethod" : clubPricesWeighItems.promoMethod!,
                                              "promoFactor" : clubPricesWeighItems.promoFactor!,
                                              "promoPrice" : clubPricesWeighItems.promoPrice!,
                                              "promoMaxQty" : clubPricesWeighItems.promoMaxQty!,
                                              "offerMessage" : clubPricesWeighItems.offerMessage!
                                ]
                                
                                ] as [String : Any]
                            return parameters
                        }
                        }
                    
                    }
                else {
                    guard let quan = itemQuantity else {
                        if quant == 0 {
                            quant = 1
                        }
                        let parameters = [
                            "item_id": locItemDetail.itemID ?? "",
                            "quantity": quant ,
                            "upc_type": upcType?.rawValue ?? "",
                            "scan_code": locItemDetail.scanCode ?? ""
                            
                            ] as [String : Any]
                        return parameters
                    }
                    
                    quant = Int(quan) ?? 0
                    if clubPriceDetail.offerMessage == "false" {
                        let parameters = [
                            "item_id": locItemDetail.itemID ?? "",
                            "quantity": quant ,
                            "upc_type": upcType?.rawValue ?? "",
                            "scan_code": locItemDetail.scanCode ?? "",
                            "jfuOfferCount" : j4uCoupons ?? 0
                            
                            ] as [String : Any]
                        return parameters
                    }
                    else {
                        let parameters = [
                            "item_id": locItemDetail.itemID ?? "",
                            "quantity": quant ,
                            "upc_type": upcType?.rawValue ?? "",
                            "scan_code": locItemDetail.scanCode ?? "",
                            "jfuOfferCount" : j4uCoupons ?? 0,
                            "clubPrice": ["promoMinQty" : clubPriceDetail.promoMinQty!,
                                          "promoMethod" : clubPriceDetail.promoMethod!,
                                          "promoFactor" : clubPriceDetail.promoFactor!,
                                           "promoPrice" : clubPriceDetail.promoPrice!,
                                           "promoMaxQty" : clubPriceDetail.promoMaxQty!,
                                           "offerMessage" : clubPriceDetail.offerMessage!,
                                           "rawOfferPrice" : clubPriceDetail.rawOfferPrice!
                                          ]
                            
                            ] as [String : Any]
                        return parameters
                    }
                    
                }

                    

                //}
                    // If offers are available :
//                else if clubPriceDetail.offerMessage != "false" {
//                    if let quan = itemQuantity {
//
//                    quant = Int(quan) ?? 0
//                    let parameters = [
//                        "item_id": locItemDetail.itemID ?? "",
//                        "quantity": quant ,
//                        "upc_type": upcType?.rawValue ?? "",
//                        "scan_code": locItemDetail.scanCode ?? "",
//                        "jfuOfferCount" : j4uCoupons ?? 0,
//                       "clubPrice": ["promoMinQty" : clubPriceDetail.promoMinQty!,
//                                     "promoMethod" : clubPriceDetail.promoMethod!,
//                                     "promoFactor" : clubPriceDetail.promoFactor!,
//                                     "promoPrice" : clubPriceDetail.promoPrice!,
//                                     "promoMaxQty" : clubPriceDetail.promoMaxQty!,
//                                     "offerMessage" : clubPriceDetail.offerMessage!,
//                                     "rawOfferPrice" : clubPriceDetail.rawOfferPrice!
//                                    ]
//
//                        ] as [String : Any]
//                    return parameters
//                }
//                }
                // If offers are not available
//                else {
//                    guard let quan = itemQuantity else {
//                        if quant == 0 {
//                            quant = 1
//                        }
//                        let parameters = [
//                            "item_id": locItemDetail.itemID ?? "",
//                            "quantity": quant ,
//                            "upc_type": upcType?.rawValue ?? "",
//                            "scan_code": locItemDetail.scanCode ?? "",
//                            "jfuOfferCount": j4uCoupons ?? 0
//
//                            ] as [String : Any]
//                        return parameters
//                    }
//                }
                
                
                
//                else {
//                    guard let quan = itemQuantity else {
//                        if quant == 0 {
//                            quant = 1
//                        }
//                        let parameters = [
//                            "item_id": locItemDetail.itemID ?? "",
//                            "quantity": quant ,
//                            "upc_type": upcType?.rawValue ?? "",
//                            "scan_code": locItemDetail.scanCode ?? "",
//                            "jfuOfferCount": j4uCoupons ?? 0
//
//                            ] as [String : Any]
//                        return parameters
//                    }
//
//                    quant = Int(quan) ?? 0
//                    let parameters = [
//                        "item_id": locItemDetail.itemID ?? "",
//                        "quantity": quant ,
//                        "upc_type": upcType?.rawValue ?? "",
//                        "scan_code": locItemDetail.scanCode ?? "",
//                        "jfuOfferCount" : j4uCoupons ?? 0,
//                       // "clubPrice":["offerMessage":clubPriceDetail.offerMessage ?? ""]
//                        "clubPrice": ["promoMinQty" : clubPriceDetail.promoMinQty!,
//                                      "promoMethod" : clubPriceDetail.promoMethod!,
//                                      "promoFactor" : clubPriceDetail.promoFactor!,
//                                      "promoPrice" : clubPriceDetail.promoPrice!,
//                                      "promoMaxQty" : clubPriceDetail.promoMaxQty!,
//                                      "offerMessage" : clubPriceDetail.offerMessage!
//                                      ]
//
//                       ] as [String : Any]
//                    return parameters
//                }
                
                
                
            case .Update:
                print("UPDATE PROCESS BEGINS HERE :")
                guard let itemElement = itemElement else {
                    fatalError()
                }
                guard let item = itemElement.item else {
                    fatalError()
                }
                
                guard let updateClubPrice = item.clubPrice else {
                    fatalError()
                }
                 var itemId = item.itemID ?? ""
                if  let locItemDetail = itemDetail {
                    if let scancod = locItemDetail.scanCode {
                        if scancod.substring(start: 0, offsetBy: 2) == "02" {
                            itemId = locItemDetail.itemID ?? ""
                        }
                    }
                }
                
                
               
                
               
              
                if isItemWeightable {
                    let parameters = [
                        "item_id": itemId ,
                        "upc_type": itemElement.upcType ?? "",
                        "scan_code": itemElement.scanCode ?? "",
                        "quantity" : 0,
                        "weight": itemWeight?.toDouble() ?? 0
                        ] as [String : Any]
                    return parameters
                }
                else {
                    if quant == 0 {
                        
                        SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: "Please change the quantity from Picker" , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                        return [:]
                    }
                    else {
                        if updateClubPrice.offerMessage != "false" {
                            let parameters = [
                                "item_id": itemId,
                                "quantity": quant ,
                                "upc_type": itemElement.upcType ?? "",
                                "scan_code": itemElement.scanCode ?? "",
                                "jfuOfferCount" : j4uCoupons ?? 0,
                                "clubPrice": ["promoMinQty" : updateClubPrice.promoMinQty!,
                                              "promoMethod" : updateClubPrice.promoMethod!,
                                              "promoFactor" : updateClubPrice.promoFactor!,
                                              "promoPrice" : updateClubPrice.promoPrice!,
                                              "promoMaxQty" : updateClubPrice.promoMaxQty!,
                                              "offerMessage" : updateClubPrice.offerMessage!,
                                              "rawOfferPrice" : updateClubPrice.rawOfferPrice!
                                ]
                                
                                ] as [String : Any]
                            return parameters
                        }
                        else {
                            let parameters = [
                            "item_id": itemId,
                             "quantity": quant,
                             "upc_type": itemElement.upcType ?? "",
                             "scan_code": itemElement.scanCode ?? "",
                             "jfuOfferCount" : j4uCoupons ?? 0
                            ] as [String : Any]
                           return parameters
                        }

                    }
                }
                
                
            }
            
        }
        return [:]
        
        
        
        
    }
    
    
    private func updateButtonAction(){
         FirebaseEventmanger.logEventWithName(AnalyticsEventAddToCart, andCustomAttributes: ["build_number":UIDevice().appShortVersion,"page":"ItemLookUpViewController","event_day_of_week":UcheckoutManager.getDay()])
    }
    
    private func removeCartItem(selectedObj : ItemElement){
        guard let item = selectedObj.item else {
            return
        }
        let itemID = item.itemID ?? ""
        
        // UcheckoutManager.getScanAndGoDevJSCompleteURl
        // UcheckoutManager.getCompleteURl
        itemLookUpViewModel.removeItemFromCart(strUrl: UcheckoutManager.getScanAndGoDevJSCompleteURl("/removeItems"), params: ["item_ids":[itemID]], parentViewController: self) { (success, response, message) in
            
            DispatchQueue.main.async {
                if success {
                    if let response = response {
                        if let ack = response.ack {
                            if ack == "0" {
                                SwiftMessageBaseClass().showSuccessMessage(title: "Sucessful", body: "Item removed", isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                                self.navigationController?.popViewController(animated: true)
                                
                                
                            }
                            else if ack == "1"{
                                if let message = response.message {
                                    SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: message , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                                }
                            }
                        }
                        else {
                            
                        }
                    }
                }
                else {
                    SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: message! , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                }
            }
            
        }
    }
    
    
    @IBAction func closeButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func pickerCloseButtonAction(_ sender: UIButton) {
        self.pickerViewContainer.isHidden = true
        self.bottomButtomContainerStackView.isHidden = false
        scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
    }
    
    
    @IBAction func pickerOkButtonAction(_ sender: UIButton) {
        if isItemWeightable {
            self.qyantityNameLabel.text = "Lbs : \(pickerView.selectedRow(inComponent: 0))"
        }
        else {
            qyantityNameLabel.attributedText = UcheckoutManager.getAtttributedStringForQuantWithString1("Qty", string2: "\((pickerView.selectedRow(inComponent: 0)))")
            itemQuantity =  "\(pickerView.selectedRow(inComponent: 0))"
            quant = pickerView.selectedRow(inComponent: 0)
            
            if let cartCaseState = cartCaseState {
                
                switch cartCaseState {
                case .Update:
                    if !isFromScanPage {
                        self.updateButton.isUserInteractionEnabled = true
                        self.updateButton.alpha = 1.0
                        
                    }
                case .Add:
                    print("Add")
                }
                
            }
            
            
        }
        
        if let cartStatus = cartCaseState {
            switch cartStatus {
            case .Add:
                guard let itemDetail = self.itemDetail  else {
                    return
                }
                
                
                if let sellPrice = itemDetail.sellPrice {
                    if clubPrices?.offerMessage != "false" {
                        let clubPrices = storeClubPrice
                        let price = (Double(pickerView.selectedRow(inComponent: 0)) * clubPrices!)
                      //  self.totalPriceLabel.text =  String(format: "%.2f", price)
                    }
                    
                    else {
                        let price = (Double(pickerView.selectedRow(inComponent: 0)) * sellPrice)
                       // self.totalPriceLabel.text =  "\(String(format: "%.2f", price))"
                    }
                    
                }
                if pickerView.selectedRow(inComponent: 0) == 0 {
                    self.updateButton.isUserInteractionEnabled = false
                    self.updateButton.alpha = 0.5
                }
                else {
                    self.updateButton.isUserInteractionEnabled = true
                    self.updateButton.alpha = 1.0
                }
            case .Update:
                guard let itemElement = self.itemElement else {
                    return
                }
                guard let item = itemElement.item  else {
                    return
                }
                
                if let sellPrice = item.sellPrice {
                    let price = (Double(pickerView.selectedRow(inComponent: 0)) * sellPrice)
                  //  self.totalPriceLabel.text =  "\(String(format: "%.2f", price))"
                }
                
            }
            
            
            
            
        }
        
        self.pickerViewContainer.isHidden = true
        self.bottomButtomContainerStackView.isHidden = false
        scrollView.contentOffset = CGPoint(x: 0.0, y: 0.0)
        
        
    }
    
    
    @IBAction func updateButtonAction(_ sender: UIButton) {
        
        if let cartStatus = cartCaseState {
            switch cartStatus {
            case .Add:
                addButtonAction()
            case .Update:
                if !isItemWeightable {
                    if quant == 0 {
                        guard let itemElement = self.itemElement  else {
                            return
                        }
                        self.removeCartItem(selectedObj: itemElement)
                    }
                    else {
                        addButtonAction()
                    }
                }
                else {
                    if isFromScanPage {
                        addButtonAction()
                        return
                    }
                    var isFound = false
                    if let vcArray = self.navigationController?.viewControllers , vcArray.count != 0{
                        for item in vcArray {
                            if item.isKind(of: ScannerBaseViewController.self) {
                                isFound = true
                                self.navigationController?.popToViewController(item, animated: true)
                            }
                        }
                    }
                    if !isFound {
                        if let scanVC = UIStoryboard.scan.instantiateViewController(withIdentifier: "ScannerBaseViewController") as? ScannerBaseViewController {
                            self.navigationController?.pushViewController(scanVC, animated: true)
                        }
                    }
                }
                
                
            }
        }
    }
    
    @IBAction func cancelButtonAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func dropDownButtonAction(_ sender: RoundButton) {
        self.pickerViewContainer.isHidden = false
        self.bottomButtomContainerStackView.isHidden = true
        scrollView.contentOffset = CGPoint(x: 0.0, y: scrollPositionvalue)
        
        if let cartCaseState = cartCaseState {
            
            switch cartCaseState {
            case .Add:
                if let qunttity = itemQuantity {
                    if let quantValue = Int(qunttity) {
                        quant = quantValue
                        pickerView.selectRow(quantValue, inComponent: 0, animated: true)
                        
                    }
                }
               
            case .Update:
                pickerView.selectRow(self.quant, inComponent: 0, animated: true)
                
            }
            
        }
      
        
    }
    
    @IBAction func clubCardLabelButtonAction(_ sender: UIButton)
    {
        let viewController = CustomPopUpViewController(nibName: "CustomPopUpViewController", bundle: nil)
        
        viewController.customPopupData.cancelButton = true
        viewController.customPopupData.removeButton = true
        viewController.customPopupData.headerTitle = "Savings and Discounts"
        viewController.customPopupData.descTextView = "Occasionally savings may not show until time of checkout. These can include club card, just for U, and employee savings. You can check the club card or phone number associated with this account in the menu, accounts section."
        viewController.customPopupData.erroImageView = "information"
        viewController.backViewColor = UIColor.black.withAlphaComponent(0.8)
        viewController.show()
    }
    
    @IBAction func clubCardInfoButtonAction(_ sender: UIButton)
    {
        
        let viewController = CustomPopUpViewController(nibName : "CustomPopUpViewController", bundle: nil)
        viewController.customPopupData.cancelButton = true
        viewController.customPopupData.removeButton = true
        viewController.customPopupData.headerTitle = "Savings and Discounts"
        viewController.customPopupData.descTextView = "Occasionally savings may not show until time of checkout. These can include club card, just for U, and employee savings. You can check the club card or phone number associated with this account in the menu, accounts section."
        viewController.customPopupData.erroImageView = "information"
        viewController.backViewColor = UIColor.black.withAlphaComponent(0.8)
        viewController.show()
        
    }
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension ItemLookUpViewController : UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 11
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row)"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}

extension ItemLookUpViewController : SwiftMessageBaseClassProtocol {
    func bannerButtonClicked() {
        if let cartVC = UIStoryboard.cart.instantiateViewController(withIdentifier: "CartBaseViewController") as? CartBaseViewController {
            self.navigationController?.pushViewController(cartVC, animated: true)
        }
    }
    
    
}


extension ItemLookUpViewController : CustomNavBarProtocol {
    func centerButtonClicked() {
        if let cartVC = UIStoryboard.cart.instantiateViewController(withIdentifier: "CartBaseViewController") as? CartBaseViewController {
            self.navigationController?.pushViewController(cartVC, animated: true)
        }
    }
    
    func menuButtonClicked() {
        guard let menuViewController = UIStoryboard.home.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController else { return }
        
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        menuViewController.menuTableControllerProtocol = self
        present(menuViewController, animated: true)
    }
    
    
}

extension ItemLookUpViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        return transiton
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        return transiton
    }
}

extension ItemLookUpViewController : MenuTableControllerProtocol {
    func menuClickedWithIndexpath(_ indexpath: IndexPath) {
        super.movetoControllerWithIndexpath(indexpath)
    }
    
    
    
}

extension ItemLookUpViewController : UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
}
