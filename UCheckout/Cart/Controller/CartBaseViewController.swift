//
//  CartBaseViewController.swift
//  UCheckout
//
//  Created by i2i Innovation on 27/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit
import SwipeCellKit

enum CustomPopupType : String{
    case Delete = "delete"
    case Checkout = "checkout"
    case Remove = "Remove"
    case RemoveSelected = "RemoveSelected"
}


class CartBaseViewController: BaseViewController {
    
    // MARK: - IB Outlet connection
    
    @IBOutlet weak var containerStackView: UIStackView!
    
    @IBOutlet weak var selectToRemoveButton: UIButton!
    @IBOutlet weak var removeAlButton: UIButton!
    
    
    @IBOutlet weak var pickerContainerView: UIView!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    
    @IBOutlet weak var customNavigationBarView: CustomNavigationBarView!
    
    @IBOutlet weak var tableView: UITableView!
    
    
    @IBOutlet weak var checkOutButton: UIButton!
    @IBOutlet weak var estimateTotalLabel: UILabel!
    
    @IBOutlet weak var cartCountlabel: CircularLabel!
    
    @IBOutlet weak var EstimatedTotalView: UIView!
    
    @IBOutlet weak var estimatedTotalText: UILabel!
    
    
    // MARK: - Variable Decleartion
    
    var homeViewModel =  HomeViewModel()
    var itemLookUpViewModel =  ItemLookUpViewModel()
    var itemElementArray : [ItemElement]?
    var globalInexPath : IndexPath?
    var customPopupType : CustomPopupType = CustomPopupType.Delete
    let transiton = SlideInTransition()
    var topView: UIView?
    var selectedObj : ItemElement?
    var selectedIndex : Int?
    var selectedQuantity : Int?
    var quantity : Int?
    var j4uCoupons : Int?
    
    var refreshControl = UIRefreshControl()
    var onboardingCell: TableViewCellOnboarding?
    var isFirstTime = false
    
    
    
    
    
    // MARK: - View Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerContainerView.isHidden = true
        containerStackView.isHidden = true
        removeAlButton.layer.borderWidth = 0.5
        removeAlButton.layer.borderColor = UIColor.darkGray.cgColor
        selectToRemoveButton.layer.borderWidth = 0.5
        selectToRemoveButton.layer.borderColor = UIColor.darkGray.cgColor
        removeAlButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        removeAlButton.layer.shadowOffset = CGSize(width: 0, height: 3)
        removeAlButton.layer.shadowOpacity = 1.0
        removeAlButton.layer.shadowRadius = 10.0
        removeAlButton.layer.masksToBounds = false
        
        tableView.dataSource = nil
        loadTableView()
        customNavigationBarView.customNavBarProtocolDelegate = self
        customNavigationBarView.deleteButtton.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
        customNavigationBarView.deleteButtton.setImage(UIImage(named : "DeleteIcon"), for: .normal)
        customNavigationBarView.deleteButtton.setImage(UIImage(named : "CloseIcon"), for: .selected)
        customNavigationBarView.deleteButtton.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
        
        
        self.EstimatedTotalView.accessibilityElements = [estimatedTotalText, estimateTotalLabel, checkOutButton]
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull down to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pickerContainerView.isHidden = true
        containerStackView.isHidden = true
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
    
    
    
    
    
    // MARK: - Private Methods
    
    @objc func refresh(sender:AnyObject) {
        getViewCartData()
    }
    
    
    @objc func dropDownButtonClicked(_ sender : RoundButton){
        
        guard let obj = itemElementArray?[sender.tag] else {
            return
        }
        selectedQuantity = 0
        if let itemQuantity = obj.quantity {
            selectedQuantity = Int(itemQuantity)
            
        }
        
        
        selectedIndex = sender.tag
        selectedObj = obj
        self.pickerContainerView.isHidden = false
        pickerView.selectRow(selectedQuantity ?? 0, inComponent: 0, animated: true)
        
        
        
    }
    
    
    private func  getNewAddPramaDict(_ itemElement : ItemElement) -> [String:Any] {
        
        guard let item = itemElement.item else {
            fatalError()
        }
        
        guard let viewCartClubPrice = item.clubPrice else {
            fatalError()
        }
        
        var quant :Int = 0
        if let selectedQuan = selectedQuantity {
            quant = selectedQuan
        }
        
        if item.clubPrice?.offerMessage != "false" {
            
            let parameters = [
                "item_id": item.itemID ?? "",
                "quantity": quant ,
                "upc_type": itemElement.upcType ?? "",
                "scan_code": itemElement.scanCode ?? "",
                "jfuOfferCount" : j4uCoupons ?? 0,
                "clubPrice": ["promoMinQty" : viewCartClubPrice.promoMinQty!,
                              "promoMethod" : viewCartClubPrice.promoMethod!,
                              "promoFactor" : viewCartClubPrice.promoFactor!,
                              "promoPrice" :  viewCartClubPrice.promoPrice!,
                              "promoMaxQty" : viewCartClubPrice.promoMaxQty!,
                              "offerMessage" : viewCartClubPrice.offerMessage!,
                              "rawOfferPrice" : viewCartClubPrice.rawOfferPrice!
                ]
                
                ] as [String : Any]
            return parameters
        }
        else
        {
                        let parameters = [
                            "item_id": item.itemID ?? "",
                            "quantity": quant,
                            "upc_type": itemElement.upcType ?? "",
                            "scan_code": itemElement.scanCode ?? ""
                            // "bag_item":true
                            ] as [String : Any]
                        return parameters
            
            
        }
 
    }
    // Added the success swift message function for item updated.
    private func addButtonAction(_ itemElement : ItemElement){
        // UcheckoutManager.getScanAndGoDevJSCompleteURl
        // UcheckoutManager.getCompleteURl
        itemLookUpViewModel.addItemToCart(strUrl: UcheckoutManager.getScanAndGoDevJSCompleteURl("/addItemToCart"), params: getNewAddPramaDict(itemElement), parentViewController: self) { (success, response, message) in
            DispatchQueue.main.async {
                if success {
                    if let response = response {
                        if let ack = response.ack {
                            if ack == "0" {
                                print("Success")
                                guard let selectedIndx = self.selectedIndex else {
                                    return
                                }
                                guard let quant = self.selectedQuantity else {
                                    return
                                }
                                
                                self.itemElementArray?[selectedIndx].quantity = Double(quant)
                                let indexPath = IndexPath(item: selectedIndx, section: 0)
                                self.tableView.reloadRows(at: [indexPath], with: .none)
                                self.selectedObj = nil
                                self.selectedIndex = nil
                                self.selectedQuantity = nil
                                self.getViewCartData()
                                
                                // Pranav Bug Fix : as per UX Review
                                SwiftMessageBaseClass().showSuccessMessage(title: "Sucessful", body: "Item updated", isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                                
                            }
                            else if ack == "1"{
                                self.selectedObj = nil
                                self.selectedIndex = nil
                                self.selectedQuantity = nil
                                if let errors = response.errors {
                                    if errors.count > 0 {
                                        if let message = errors.first?.message {
                                            SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: message , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                                        }
                                    }
                                    
                                }
                            }
                        }
                    }
                }
                else {
                    self.selectedObj = nil
                    self.selectedIndex = nil
                    self.selectedQuantity = nil
                    SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: message! , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                }
            }
            
        }
        
    }
    
    
    private  func loadTableView(){
        
        tableView.register(UINib(nibName: TableResuableIdenifier.CartEmptyBottomTableViewCell, bundle: nil), forHeaderFooterViewReuseIdentifier: TableResuableIdenifier.CartEmptyBottomTableViewCell)
        tableView.register(UINib(nibName: TableResuableIdenifier.CartTableViewCell, bundle: nil), forCellReuseIdentifier: TableResuableIdenifier.CartTableViewCell)
        tableView.register(UINib(nibName: TableResuableIdenifier.NoCartItemTableViewCell, bundle: nil), forCellReuseIdentifier: TableResuableIdenifier.NoCartItemTableViewCell)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120
        tableView.contentInset = UIEdgeInsets(top: -35, left: 0, bottom: 0, right: 0);
        
        
        
        tableView.reloadData()
        
    }
    
    private func updateUI(viewCartData : ViewCartData?)
    {
        
        self.customNavigationBarView.cartCountLabel.text =  "\(viewCartData?.totalQuantity ?? 0)"
        
        if let totalPrice = viewCartData?.totalPrice {
            let price = totalPrice
            let finalPrice = String(format: "%.2f", price)
            self.estimateTotalLabel.text = "$\(finalPrice)"
            
        }
        else {
            // Pranav Bug Fix : as per UX Review
            self.estimateTotalLabel.text =  "$0.00"
            
        }
        
    }
    // UcheckoutManager.getScanAndGoDevJSCompleteURl
    //UcheckoutManager.getCompleteURl
    private func getViewCartData(){
        homeViewModel.getviewCart(strUrl: UcheckoutManager.getScanAndGoDevJSCompleteURl("/viewCart"), parentViewController: self) { (success, response, message) in
            
            DispatchQueue.main.async {
                self.tableView.dataSource = self
                
                if success {
                    if let response = response {
                        if let ack = response.ack {
                            if ack == "0" {
                                
                                if let viewCartData = response.data {
                                
                                    self.updateUI(viewCartData: viewCartData)
                                    if let itemArray = viewCartData.items {
                                        self.itemElementArray = itemArray
                                        let shared = UcheckoutSingleton.shared
                                        shared.viewCart = viewCartData
                                        shared.itemElementArray = self.itemElementArray
                                        self.tableView.reloadData()
                                        self.refreshControl.endRefreshing()
                                            if let items = self.itemElementArray {
                                                if items.count > 0 {
                                                    if !self.isFirstTime {
                                                        self.isFirstTime = true
                                                        let config = TableViewCellOnboarding.Config(initialDelay: 1, duration: 2.5, halfwayDelay: 0.5)
                                                        self.onboardingCell = TableViewCellOnboarding(with: self.tableView, config: config)
                                                        self.onboardingCell?.editActions = self.tableView(self.tableView, editActionsForRowAt: IndexPath(row: 0, section: 0))
                                                    }
                                                   
                                                    self.customNavigationBarView.deleteButtton.isUserInteractionEnabled = true
                                                    self.customNavigationBarView.deleteButtton.isEnabled = true
                                                    
                                                } else {
                                                    self.customNavigationBarView.deleteButtton.isUserInteractionEnabled = false
                                                    self.customNavigationBarView.deleteButtton.isEnabled = false
                                                }
                                                
                                            } else {
                                                self.customNavigationBarView.deleteButtton.isUserInteractionEnabled = false
                                                self.customNavigationBarView.deleteButtton.isEnabled = false
                                        }
                                     
                                       
                                        
                                    }
                                }
                                
                                
                            }
                            else if ack == "1"{
                                self.updateUI(viewCartData: nil)
                                self.tableView.reloadData()
                                
                                if let message = response.message {
                                    
                                    SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: message , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                                }
                            }
                        }
                        else {
                            self.updateUI(viewCartData: nil)
                            self.tableView.reloadData()
                            
                        }
                    }
                }
                else {
                    self.updateUI(viewCartData: nil)
                    self.tableView.reloadData()
                    
                    SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: message! , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                }
            }
            
        }
    }
    
    //UcheckoutManager.getScanAndGoDevJSCompleteURl
    // UcheckoutManager.getCompleteURl
    private func clearCartData(){
        itemLookUpViewModel.clearCart(strUrl: UcheckoutManager.getScanAndGoDevJSCompleteURl("/clearCart"), parentViewController: self) { (success, response, message) in
            
            DispatchQueue.main.async {
                if success {
                    self.tableView.dataSource = self
                    if let response = response {
                        if let ack = response.ack {
                            if ack == "0" {
                                //SwiftMessageBaseClass().showErrorMessage(title: "Successful", body: "All items removed" , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                                // Pranav Bug Fix : as per UX Review
                                SwiftMessageBaseClass().showSuccessMessage(title: "Sucessful", body: "All items removed", isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                                
                                self.getViewCartData()
                                
                                
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
    
    
    private func removeCartItem(selectedObjArray : [ItemElement]){
        var itemIDArray = [String]()
        for itemElement in selectedObjArray {
            guard let itemID = itemElement.item?.itemID else {
                continue
            }
            itemIDArray.append(itemID)
        }
        
        if itemIDArray.isEmpty {
            return
        }
        
        //UcheckoutManager.getScanAndGoDevJSCompleteURl
        // UcheckoutManager.getCompleteURl
        itemLookUpViewModel.removeItemFromCart(strUrl: UcheckoutManager.getScanAndGoDevJSCompleteURl("/removeItems"), params: ["item_ids":itemIDArray], parentViewController: self) { (success, response, message) in
            
            DispatchQueue.main.async {
                if success {
                    self.tableView.dataSource = self
                    if let response = response {
                        if let ack = response.ack {
                            if ack == "0" {
                                //SwiftMessageBaseClass().showErrorMessage(title: "Successful", body: "Item removed" , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                                
                                // Pranav Bug Fix : as per UX Review
                                SwiftMessageBaseClass().showSuccessMessage(title: "Sucessful", body: "Item removed", isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                                
                                self.getViewCartData()
                                
                                
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
    
    private func setSelectableState(indexPath : IndexPath){
        guard let item = itemElementArray?[indexPath.row] else {
            return
        }
        itemElementArray?[indexPath.row].isSelected = !item.isSelected
        let itemSelected = itemElementArray?.filter { $0.isSelected }
        guard let itemSelectedArray = itemSelected , itemSelectedArray.count > 0 else {
            customNavigationBarView.deleteButtton.isSelected = true
            return
        }
        customNavigationBarView.deleteButtton.isSelected = false
    }
    
    
    
    // MARK: - Button Action
    
    @IBAction func selectToRemoveButtonAction(_ sender: UIButton) {
        containerStackView.isHidden = true
        tableView.isEditing = true
    }
    
    
    @IBAction func removeAllButtonAction(_ sender: UIButton) {
        containerStackView.isHidden = true
        customNavigationBarView.deleteButtton.isSelected = false
        let viewController = CustomPopUpViewController(nibName: "CustomPopUpViewController", bundle: nil)
        viewController.customPopupDelegate = self
        self.customPopupType = .Delete
        viewController.show()
    }
    
    
    @IBAction func helpButtonAction(_ sender: UIButton)
    {
        if let scanVC = UIStoryboard.scanHelp.instantiateViewController(withIdentifier: "ScanHelpBaseViewController") as? ScanHelpBaseViewController {
            scanVC.helpType = .Home
            scanVC.modalPresentationStyle = .overCurrentContext
            present(scanVC, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func pickerCloseButtonAction(_ sender: UIButton) {
        selectedObj = nil
        selectedIndex = nil
        selectedQuantity = 0
        pickerContainerView.isHidden = true
        
    }
    
    @IBAction func updateButtonAction(_ sender: UIButton) {
        if selectedQuantity == nil {
            // Pranav Bug Fix : as per UX Review
            SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: "Please select quantity" , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
            
            return
        }
        else if selectedQuantity == 0 {
            pickerContainerView.isHidden = true
            if let selectedObj = selectedObj {
                removeCartItem(selectedObjArray: [selectedObj])
            }
            
        }
        else {
            pickerContainerView.isHidden = true
            if let selectedObj = selectedObj {
                
                addButtonAction(selectedObj)
                
            }
        }
        
    }
    
    
    @IBAction func plubuttonAction(_ sender: UIButton) {
        var isFound = false
        if let vcArray = self.navigationController?.viewControllers , vcArray.count != 0{
            for item in vcArray {
                if item.isKind(of: PLUBaseViewController.self) {
                    isFound = true
                    self.navigationController?.popToViewController(item, animated: true)
                }
            }
        }
        if !isFound {
            if let pluVC = UIStoryboard.plu.instantiateViewController(withIdentifier: "PLUBaseViewController") as? PLUBaseViewController {
                self.navigationController?.pushViewController(pluVC, animated: true)
            }
        }
    }
    
    @IBAction func scanButtonAction(_ sender: RoundButton) {
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
    
    @objc func deleteButtonAction() {
        guard let itemElementArray = itemElementArray else {
            return
        }
        if customNavigationBarView.deleteButtton.isSelected  {
            let itemSelect = itemElementArray.filter { $0.isSelected }
            if itemSelect.count == 0{
                customNavigationBarView.deleteButtton.isSelected = false
                containerStackView.isHidden = true
                tableView.isEditing = false
            } }else {
            
            let itemSelected = itemElementArray.filter { $0.isSelected }
            print(itemSelected.count)
            if !itemSelected.isEmpty {
                let viewController = CustomPopUpViewController(nibName: "CustomPopUpViewController", bundle: nil)
                viewController.customPopupDelegate = self
                viewController.customPopupData.cancelButtonTitle = "Cancel"
                viewController.customPopupData.removeButtonTitle = "Remove"
                viewController.customPopupData.headerTitle = "All selected items of this type will be removed."
                viewController.customPopupData.descTextView = "Are you sure you want all items of this type to be removed? To add again, you will need to re-scan the item barcode."
                self.customPopupType = .RemoveSelected
                viewController.show()
                
            } else {
                customNavigationBarView.deleteButtton.isSelected = true
                containerStackView.isHidden = false
                tableView.isEditing = false
            }
            
            
            
            
        }
        
        
        
    }
    
    @IBAction func checkoutButtonAction(_ sender: UIButton) {
        // FireBase Event :
        FirebaseEventmanger.logEventWithName("CheckoutButton_Pressed", andCustomAttributes: ["build_number":UIDevice().appShortVersion,"page":"CartBaseViewController","event_day_of_week":UcheckoutManager.getDay()])
        
        let viewController = CustomPopUpViewController(nibName: "CustomPopUpViewController", bundle: nil)
        viewController.customPopupDelegate = self
        viewController.customPopupData.cancelButtonTitle = "Cancel"
        viewController.customPopupData.removeButtonTitle = "Continue"
        viewController.customPopupData.headerTitle = "Are you ready to make final purchase?"
        viewController.customPopupData.descTextView = "Once you press continue you can’t go back."
        viewController.customPopupData.firstImageHidden = true
        viewController.customPopupData.secondImageHidden = true
        customPopupType = .Checkout
        
        viewController.show()
        
    }
    
    func callDelete (indexPath : IndexPath) {
        DispatchQueue.main.async {
            self.globalInexPath = indexPath
            
            let viewController = CustomPopUpViewController(nibName: "CustomPopUpViewController", bundle: nil)
            viewController.customPopupDelegate = self
            viewController.customPopupData.cancelButtonTitle = "Cancel"
            viewController.customPopupData.removeButtonTitle = "Remove"
            viewController.customPopupData.headerTitle = "All items of this type will be removed."
            viewController.customPopupData.descTextView = "Are you sure you want all items of this type to be removed? To add again, you will need to re-scan the item barcode."
            self.customPopupType = .Remove
            viewController.show()
        }
    }
    
    
    
}

extension CartBaseViewController : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = itemElementArray?.count  else {
            checkOutButton.isUserInteractionEnabled = false
            checkOutButton.alpha = 0.5
            customNavigationBarView.deleteButtton.isUserInteractionEnabled = false
            customNavigationBarView.deleteButtton.alpha = 0.5
            
            return 1
        }
        if count == 0 {
            checkOutButton.alpha = 0.5
            checkOutButton.isUserInteractionEnabled = false
            customNavigationBarView.deleteButtton.isUserInteractionEnabled = false
            customNavigationBarView.deleteButtton.alpha = 0.5
            return 1
        }
        checkOutButton.alpha = 1.0
        checkOutButton.isUserInteractionEnabled = true
        customNavigationBarView.deleteButtton.isUserInteractionEnabled = true
        customNavigationBarView.deleteButtton.alpha = 1.0
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if itemElementArray?.count == 0 || itemElementArray == nil {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableResuableIdenifier.NoCartItemTableViewCell, for: indexPath) as? NoCartItemTableViewCell else {
                fatalError()
            }
            return cell
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TableResuableIdenifier.CartTableViewCell, for: indexPath) as? CartTableViewCell else {
                fatalError()
            }
            if let item = itemElementArray?[indexPath.row] {
                cell.populateData(itemElement: item)
            }
            cell.dropDownButton.tag = indexPath.row
            cell.dropDownButton.addTarget(self, action: #selector(dropDownButtonClicked(_:)), for: .touchUpInside)
            cell.tintColor = UIColor.red
            
            return cell
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return unsafeBitCast(3, to: UITableViewCell.EditingStyle.self)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    // needs work here :
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let deleteAction = UITableViewRowAction(style: .destructive, title: "Remove") { (_, _) in
//            print("Action tapped")
//            self.callDelete(indexPath: indexPath)
//        }
//        return [deleteAction]
//    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: tableView.frame.size.height))
        backView.backgroundColor = UIColor(named: "AppRedColor")
        let frame = tableView.rectForRow(at: indexPath)
        let myImage = UIImageView(frame: CGRect(x: 30 , y: frame.size.height/2-30, width: 15, height: 20))
        myImage.image = UIImage(named: "DeleteIcon")!
        backView.addSubview(myImage)
        
        let imgSize: CGSize = tableView.frame.size
        UIGraphicsBeginImageContextWithOptions(imgSize, false, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        backView.layer.render(in: context!)
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Remove") {
            (action, indexPath) in
            self.callDelete(indexPath: indexPath)
        }

        
        deleteAction.backgroundColor = UIColor(patternImage: newImage)
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let action =  UIContextualAction(style: .normal, title: "Remove", handler: { (action,view,completionHandler ) in
            self.callDelete(indexPath: indexPath)
        })
        action.image = UIImage(named: "DeleteIcon")
        action.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [action])
        
        return configuration
    }
    
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        if indexPath.row == itemElementArray?.count
        {
            if itemElementArray?.count == 0
            {
                if indexPath.row == 0
                {
                    print("something")
                }
                
            }
        }
        else {
            guard let item = itemElementArray?[indexPath.row] else {
                return
            }
            if !tableView.isEditing {
                guard  let itemlookUpVC = UIStoryboard.item.instantiateViewController(withIdentifier: "ItemLookUpViewController") as? ItemLookUpViewController else {
                    return
                }
                itemlookUpVC.cartCaseState = .Update
                itemlookUpVC.itemElement = item
              //  itemlookUpVC.clubPrices = ClubPrices(promoFactor: nil, promoMethod: "PE", promoPrice: 1.50, promoMaxQty: nil, promoMinQty: nil, offerMessage: "Buy 1 get 1 off")
                self.navigationController?.pushViewController(itemlookUpVC, animated: true)
                
            } else {
                
                setSelectableState(indexPath: indexPath)
                
            }
            
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if tableView.isEditing {
            setSelectableState(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        guard let cell = self.tableView.dequeueReusableHeaderFooterView(withIdentifier: TableResuableIdenifier.CartEmptyBottomTableViewCell) as? CartEmptyBottomTableViewCell else {
            return UIView()
        }
        // // Pranav Bug Fix
        //cell.emptyCardButton.addTarget(self, action: #selector(deleteButtonAction), for: .touchUpInside)
        cell.emptyCardButton.isHidden = true
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if itemElementArray?.count == 0 {
            return 0
        }
        return 150
    }
    
    
    
    
}

extension CartBaseViewController : CustomPopUpViewActionProtocol {
    func cancelButtonClick() {
        self.dismiss(animated: true, completion: nil)
        if customPopupType == .RemoveSelected {
            guard let itemElementArray = itemElementArray else {
                return
            }
            for (index,_) in itemElementArray.enumerated() {
                self.itemElementArray?[index].isSelected = false
            }
            tableView.isEditing = false
        }
    }
    
    func removeButtonClick() {
        // FireBase Event:
        FirebaseEventmanger.logEventWithName("ContinueButton_Pressed", andCustomAttributes: ["build_number":UIDevice().appShortVersion,"page":"CartBaseViewController","event_day_of_week":UcheckoutManager.getDay()])
        
        if customPopupType == CustomPopupType.Remove {
            self.dismiss(animated: true) {
                guard let indexPath = self.globalInexPath else {
                    return
                }
                if let selectedObj = self.itemElementArray?[indexPath.row] {
                    self.removeCartItem(selectedObjArray: [selectedObj])
                }
                
            }
            
            
        }
        else if customPopupType == CustomPopupType.Delete {
            self.dismiss(animated: true) {
                self.clearCartData()
            }
            
        }
        else if customPopupType == CustomPopupType.RemoveSelected {
            self.dismiss(animated: true) {
                guard let itemElementArray = self.itemElementArray else {
                    return
                }
                let itemSelected = itemElementArray.filter { $0.isSelected }
                if !itemSelected.isEmpty {
                    self.removeCartItem(selectedObjArray: itemSelected)
                    
                }
            }
            
        }
        else {
            self.dismiss(animated: true) {
                if let bagVC = UIStoryboard.bag.instantiateViewController(withIdentifier: "BagBaseViewController") as? BagBaseViewController {
                    // iterarte in itemElementArrayn,, bag
                    if let itemElementArray = self.itemElementArray
                    {
                        for item in itemElementArray
                        {
                            if item.scanCode == "22147"
                            {
                                self.quantity = Int(item.quantity ?? 0)
                                break
                            }
                            else
                            {
                                self.quantity = 0
                                break
                            }
                        }
                    }
                    bagVC.bagCallBackProtocol = self
                    bagVC.prevQuant = self.quantity ?? 0
                    self.navigationController?.pushViewController(bagVC, animated: true)
                }
            }
            
            
            
            
            
        }
        
    }
    
    
}


extension CartBaseViewController : BagCallBackProtocol {
    func bagAddedWithBagNumber(_ bagItem: Int) {
        // make service call
        let viewController = CheckoutLoadingViewController(nibName: "CheckoutLoadingViewController", bundle: nil)
        viewController.bagItemCount = bagItem
        viewController.backViewColor = UIColor.black.withAlphaComponent(0.9)
        self.navigationController?.present(viewController, animated: true, completion: nil)
    }
    
    func ownBagSelected() {
        // make Service call
        let viewController = CheckoutLoadingViewController(nibName: "CheckoutLoadingViewController", bundle: nil)
        viewController.backViewColor = UIColor.black.withAlphaComponent(0.9)
        self.navigationController?.present(viewController, animated: true, completion: nil)
        
    }
    
    
}

extension CartBaseViewController : CustomNavBarProtocol {
    func centerButtonClicked()
    {   
        print("Center Button Clicked")
    }
    
    func menuButtonClicked() {
        guard let menuViewController = UIStoryboard.home.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController else { return }
        
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        menuViewController.menuTableControllerProtocol = self
        present(menuViewController, animated: true)
    }
    
    
}


extension CartBaseViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        return transiton
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        return transiton
    }
}


extension CartBaseViewController : MenuTableControllerProtocol {
    func menuClickedWithIndexpath(_ indexpath: IndexPath) {
        super.movetoControllerWithIndexpath(indexpath)
    }
    
    
    
}

extension CartBaseViewController : UIPickerViewDelegate,UIPickerViewDataSource {
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
        
        selectedQuantity =  row
        
        
    }
}
