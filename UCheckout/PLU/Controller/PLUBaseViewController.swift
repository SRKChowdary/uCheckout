//
//  PLUBaseViewController.swift
//  UCheckout
//
//  Created by i2i innovation on 23/08/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit
import ABCoreNetwork
import Firebase

class PLUBaseViewController: BaseViewController {
    
    @IBOutlet weak var customNavigationHeaderView: CustomNavigationBarView!
    
     // MARK: - IBOutlet Connections
    
    @IBOutlet weak var pluView: UIView!
    @IBOutlet weak var pluTextField: UITextField!
    @IBOutlet weak var enterButton: UIButton!
    
    @IBOutlet var toolbar: UIToolbar!
    
    
    @IBOutlet weak var pluCodeInfoOutlet: UIButton!
    
    
    
    
    // MARK: - Variable  Declerations

    lazy var service = PLURemoteService ()
    lazy var itemLookUpViewModel = ItemLookUpViewModel()
    let transiton = SlideInTransition()
    private var homeViewModel = HomeViewModel()
    private var itemElementArray : [ItemElement]?
    private var viewCartData : ViewCartData?

    
    
    // MARK: - View Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
         enterButton.isUserInteractionEnabled = true
        customNavigationHeaderView.customNavBarProtocolDelegate = self
         updateUI()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        pluTextField.text = ""
        pluTextField.becomeFirstResponder()
        enterButton.isUserInteractionEnabled = true
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
    
    
    @objc func backButtonClicked() {
       self.navigationController?.popViewController(animated: true)
    }
    
    func updateUI()  {
       pluTextField.inputAccessoryView = toolbar
       pluView.layer.cornerRadius = 20
       pluView.clipsToBounds = true
       pluView.layer.borderColor = GlobalColor.k87BlackColor.cgColor
       pluView.layer.borderWidth = 1.0
       enterButton.isHidden = false
        customNavigationHeaderView.deleteButtton.setImage(UIImage(named: "backArrow"), for: .normal)
        customNavigationHeaderView.deleteButtton.isHidden = false
        customNavigationHeaderView.deleteButtton.addTarget(self, action: #selector(backButtonClicked), for: .touchUpInside)
        pluCodeInfoOutlet.tintColor = UIColor(hexString: "0D90D7")

    }
    
    private func upDateData(){
       
        self.customNavigationHeaderView.cartCountLabel.text = "\(viewCartData?.totalQuantity ?? 0)"

        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MARK: - Action Methods
    
    @IBAction func pluCodeInformation(_ sender: UIButton)
    {
        let viewController = CustomPopUpViewController(nibName: "CustomPopUpViewController", bundle: nil)
        
        viewController.customPopupData.cancelButton = true
        viewController.customPopupData.removeButton = true
        viewController.customPopupData.headerTitle = "PLU as scanning alternative"
        viewController.customPopupData.descTextView = ""
        viewController.customPopupData.erroImageView = "information"
        viewController.customPopupData.firstImageHidden = false
        viewController.customPopupData.secondImageHidden = false
        viewController.customPopupData.errorImageViewOne = "pluclubCard"
        viewController.customPopupData.errorImageViewTwo = "pluhelperOne"
        viewController.backViewColor = UIColor.black.withAlphaComponent(0.8)
        viewController.show()
    }
    
    
    // Pranav Bug Fix
    @IBAction func enablekeyboardOnPLU(_ sender: UIButton) {
        pluTextField.becomeFirstResponder()
    }
    
    
    
    @IBAction func helpButtonAction(_ sender: UIButton) {
        if let scanVC = UIStoryboard.scanHelp.instantiateViewController(withIdentifier: "ScanHelpBaseViewController") as? ScanHelpBaseViewController {
            scanVC.helpType = .PLU
            scanVC.modalPresentationStyle = .overCurrentContext
            present(scanVC, animated: true, completion: nil)
        }
        FirebaseEventmanger.logEventWithName("helpButtonPressed_PLU", andCustomAttributes: ["build_number":UIDevice().appShortVersion,"page":"PLUBaseViewController","event_day_of_week":UcheckoutManager.getDay()])
        
    }
    
    @IBAction func scanButtonAction(_ sender: RoundButton) {
         FirebaseEventmanger.logEventWithName("scanButtonPresses_PLUPage", andCustomAttributes: ["build_number":UIDevice().appShortVersion,"page":"PLUBaseViewController","event_day_of_week":UcheckoutManager.getDay()])
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
    

    @IBAction func enterButtonAction(_ sender: UIButton) {
        pluTextField.resignFirstResponder()
        if pluTextField.text != "" {
            callUsingAlamofireMForItemLookup()
        }
        else {
            SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: "Please enter PLU digits" , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
        }
        
    }
    
    @IBAction func donebUttonAction(_ sender: UIBarButtonItem) {
         // Pranav Bug Fix : as per UX Review
        pluTextField.resignFirstResponder()


        if (pluTextField.text?.count)! <= 3 
        {
            SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: "Please enter 4 or 5 digits" , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
        }
        
       else if pluTextField.text != ""
        {
            callUsingAlamofireMForItemLookup()
        }
        else
        {
            SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: "Please enter PLU digits" , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
        }

    }
    
    @IBAction func closeButtonAction(_ sender: UIBarButtonItem) {
        pluTextField.resignFirstResponder()
    }
    
    // New Done Button and Close button Actions as per UX Design :
    
    
     // MARK: - Alamofire  Call Methods
    
    // UcheckoutManager.getCompleteURl
    // UcheckoutManager.getScanAndGoDevJSCompleteURl
    private func getViewCartData(){
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
    
    private func callUsingAlamofireMForItemLookup(){
        let sharedInstance = UcheckoutSingleton.shared
        guard let storeId = sharedInstance.getprofileModelData?.stores?.storeID else {
            return
        }
        // // UcheckoutManager.getCompleteURl
        // UcheckoutManager.getScanAndGoDevJSCompleteURl
        // getScanAndGoDevJSCompleteURl
        
        let urlString = "\(UcheckoutManager.getScanAndGoDevJSCompleteURl("/itemlookup"))?upc_type=PLU&scan_code=\(pluTextField.text!)&storeid=\(storeId)"
        itemLookUpViewModel.getItemLookUp(strUrl: urlString, parentViewController: self) { (status, response, message) in
            DispatchQueue.main.async {
                if status {
                    if let itemLookUpModel = response {
                        if let ack = itemLookUpModel.ack {
                            if ack == "0" {
                                
                                if let itemDetail = itemLookUpModel.data {
                                    if let itemWeight = itemDetail.weightItem , itemWeight {
                                        if let itemlookUpVC = UIStoryboard.scan.instantiateViewController(withIdentifier: "WeightedScanDisplayViewController") as? WeightedScanDisplayViewController {
                                            itemlookUpVC.isFromPLUScreen = true
                                            itemlookUpVC.pluCode = self.pluTextField.text
                                             itemlookUpVC.itemName = itemDetail.posDescription ?? ""
                                            self.navigationController?.pushViewController(itemlookUpVC, animated: true)
                                            
                                        }
                                    }
                                    else {
                                        if let itemlookUpVC = UIStoryboard.item.instantiateViewController(withIdentifier: "ItemLookUpViewController") as? ItemLookUpViewController {
                                            if let item = self.itemElementArray?.first(where: {$0.item?.itemID == itemDetail.itemID}) {
                                                 itemlookUpVC.cartCaseState = .Update
                                                itemlookUpVC.itemElement = item
                                                 itemlookUpVC.itemDetail = itemDetail
                                                itemlookUpVC.isFromPluPage = true
                                               // itemlookUpVC.clubPrices = itemLookUpModel.clubPrice
                                                itemlookUpVC.clubPrices = itemDetail.clubPrice                                                // do something with foo
                                            } else {
                                                 itemlookUpVC.cartCaseState = .Add
                                                itemlookUpVC.itemDetail = itemDetail

                                                // item could not be found
                                            }
                                          //  itemlookUpVC.clubPrices = itemLookUpModel.clubPrice
                                            itemlookUpVC.clubPrices = itemDetail.clubPrice
                                            itemlookUpVC.upcType = UPCType.plu
                                            
                                            self.navigationController?.pushViewController(itemlookUpVC, animated: true)
                                            
                                        }
                                    }
                                    
                                    
                                }
                                
                                
                            }
                            else if ack == "1"{
                                if let errorsArray = itemLookUpModel.errors {
                                    if errorsArray.count > 0 {
                                        SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: errorsArray[0].message ?? "" , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                                       
                                    }
                                    
                                }
                            }
                        }
                    }
                }
                else {
                    SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: "Something Went Wrong" , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                }
                
            }
        }

        
    }
    
    
     // MARK: - AB Core Network Call Methods
    
    private func initiateABCoreMethodForItemLookup(){
        let postJSON = PLUModelRequest (upcType: "PLU", barcode: pluTextField.text) // to be changed
        MBProgressIndicator.showIndicator(self.view)
        
        service.run(coa: postJSON, completed: handleCOAResponse())
    }
    
    func handleCOAResponse ()  -> ResultBlock <ItemLookUpModel> {
       
        let response  = {(result: Result<ItemLookUpModel>) in
            DispatchQueue.main.async {
                 MBProgressIndicator.hideIndicator(self.view)
                switch result {
                case .success(let value):
                    print(value)
                    self.processSuccessReuestWithvalue(value)
                case .failure(let error):
                    print(error)
                }
            }
        }
        return response
    }
    
    
    
    
    func processSuccessReuestWithvalue (_ itemLookUpModel : ItemLookUpModel) {
    
        if let ack = itemLookUpModel.ack {
            if ack == "0" {
                
                if let itemDetail = itemLookUpModel.data {
                    if let itemlookUpVC = UIStoryboard.item.instantiateViewController(withIdentifier: "ItemLookUpViewController") as? ItemLookUpViewController {
                        itemlookUpVC.itemDetail = itemDetail
                        itemlookUpVC.cartCaseState = .Add
                        itemlookUpVC.upcType = UPCType.plu
                        
                        self.navigationController?.pushViewController(itemlookUpVC, animated: true)
                        
                    }
                    
                }
                
                
            }
            else if ack == "1"{
                if let errorsArray = itemLookUpModel.errors {
                    if errorsArray.count > 0 {
                        SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: errorsArray[0].message ?? "" , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                    }
                    
                }
            }
        }
        
    }
    

}

extension PLUBaseViewController : UITextFieldDelegate {

    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != "" {
            enterButton.backgroundColor = GlobalColor.KAppRedColor
            enterButton.isUserInteractionEnabled = true
            enterButton.setTitleColor(UIColor.white, for: .normal)
        }
        else {
            enterButton.backgroundColor = UIColor.lightGray
             enterButton.isUserInteractionEnabled = false
            enterButton.setTitleColor(UIColor.darkGray, for: .normal)
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         return range.location < 5
    }
    
    
    
    
}
extension PLUBaseViewController : CustomNavBarProtocol {
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

extension PLUBaseViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        return transiton
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        return transiton
    }
}


extension PLUBaseViewController : MenuTableControllerProtocol {
    func menuClickedWithIndexpath(_ indexpath: IndexPath) {
         super.movetoControllerWithIndexpath(indexpath)
    }
    
    
    
}

