//
//  ScannerBaseViewController.swift
//  UCheckout
//
//  Created by i2i innovation on 11/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit
import ScanditBarcodeCapture

class ScannerBaseViewController: BaseViewController {
    
      // MARK: - IB Outlet Connection
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var cameraBaseView: UIView!
    @IBOutlet weak var cartCountlabel: CircularLabel!
    
    @IBOutlet weak var cartView: UIView!
    
    
    // MARK: - Variable Decleration
    
    private var context: DataCaptureContext!
    private var camera: Camera?
    private var barcodeCapture: BarcodeCapture!
    private var overlay: BarcodeCaptureOverlay!
    private var captureView: DataCaptureView!
    var itemElementArray : [ItemElement]?
    private var fullBarCode : String?
    let transiton = SlideInTransition()
    var topView: UIView?
    private var homeViewModel = HomeViewModel()
    private var viewCartData : ViewCartData?


    
    
    
    // MARK: - View Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setupRecognition()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.title = "Scan Barcode"
        self.navigationController?.navigationBar.isHidden = false
        
        // Switch camera on to start streaming frames. The camera is started asynchronously and will take some time to
        // completely turn on.
        barcodeCapture.isEnabled = true
        camera?.switch(toDesiredState: .on)
        addViewTapGesture()
        getViewCartData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Switch camera off to stop streaming frames. The camera is stopped asynchronously and will take some time to
        // completely turn off. Until it is completely stopped, it is still possible to receive further results, hence
        // it's a good idea to first disable barcode capture as well.
        barcodeCapture.isEnabled = false
        camera?.switch(toDesiredState: .off)
    }
    
    override func gestureClicked() {
        super.gestureClicked()
        menuButtonClicked()
    }
    
    private func menuButtonClicked() {
        guard let menuViewController = UIStoryboard.home.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController else { return }
        
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        menuViewController.menuTableControllerProtocol = self
        present(menuViewController, animated: true)
    }
    
    
    // MARK: - Private Methods
    // UcheckoutManager.getCompleteURl
    // getScanAndGoDevJSCompleteURl
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
                                self.upDateUI()
                                }
                                
                                
                            }
                            else if ack == "1"{
                                self.upDateUI()
                                if let message = response.message {
                                    
                                   SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: message , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                                }
                            }
                        }
                        else {
                            self.upDateUI()
                        }
                    }
                }
                else {
                    self.upDateUI()
                   SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: message! , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                }
            }
            
        }
    }
   
    
    
    private func addViewTapGesture(){
        let navTapGesture = UITapGestureRecognizer(target: self, action: #selector(navTapGuestureRecogClicked))
        navTapGesture.numberOfTapsRequired = 1
        self.cartView.addGestureRecognizer(navTapGesture)
        
        
    }
    
    @objc private func navTapGuestureRecogClicked(){
        if let cartVC = UIStoryboard.cart.instantiateViewController(withIdentifier: "CartBaseViewController") as? CartBaseViewController {
            self.navigationController?.pushViewController(cartVC, animated: true)
        }
    }
    
    
    private func upDateUI()
    {
        //var count = 0
       self.cartCountlabel.text = "\(viewCartData?.totalQuantity ?? 0)"
    }
    
    

    
    
    
    // MARK: - IB Action Methods

    
    @IBAction func backButtonAction(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func menuButtonAction(_ sender: UIBarButtonItem) {
        menuButtonClicked()
    }
    
    
    @IBAction func helpButtonAction(_ sender: UIButton) {
        if let scanVC = UIStoryboard.scanHelp.instantiateViewController(withIdentifier: "ScanHelpBaseViewController") as? ScanHelpBaseViewController {
            scanVC.helpType = .Scan
            scanVC.modalPresentationStyle = .overCurrentContext
            present(scanVC, animated: true, completion: nil)
        }
    }
    
    
    

    // MARK: - Scanner Methhods
    
    func setupRecognition() {
        // Create data capture context using your license key.
        context = DataCaptureContext.licensed
        
        // Use the world-facing (back) camera and set it as the frame source of the context. The camera is off by
        // default and must be turned on to start streaming frames to the data capture context for recognition.
        // See viewWillAppear and viewDidDisappear above.
        camera = Camera.default
        context.setFrameSource(camera, completionHandler: nil)
        
        // The barcode capturing process is configured through barcode capture settings
        // and are then applied to the barcode capture instance that manages barcode recognition.
        let settings = BarcodeCaptureSettings()
        
        // The settings instance initially has all types of barcodes (symbologies) disabled. For the purpose of this
        // sample we enable a very generous set of symbologies. In your own app ensure that you only enable the
        // symbologies that your app requires as every additional enabled symbology has an impact on processing times.
      
        settings.set(symbology: .ean13UPCA, enabled: true)
        settings.set(symbology: .ean8, enabled: true)
        settings.set(symbology: .upce, enabled: true)
       // settings.set(symbology: .qr, enabled: true)
        // settings.set(symbology: .dataMatrix, enabled: true)
         settings.set(symbology: .code39, enabled: true)
         settings.set(symbology: .code128, enabled: true)
        //settings.set(symbology: .interleavedTwoOfFive, enabled: true)
        settings.set(symbology: .gs1Databar, enabled: true)
        settings.set(symbology: .gs1DatabarLimited, enabled: true)
        settings.set(symbology: .gs1DatabarExpanded, enabled: true)
        settings.set(symbology: .microQR, enabled: true)
        
        
        
        // Some linear/1d barcode symbologies allow you to encode variable-length data. By default, the Scandit
        // Data Capture SDK only scans barcodes in a certain length range. If your application requires scanning of one
        // of these symbologies, and the length is falling outside the default range, you may need to adjust the "active
        // symbol counts" for this symbology. This is shown in the following few lines of code for one of the
        // variable-length symbologies.
        let symbologySettings = settings.settings(for: .code39)
        symbologySettings.activeSymbolCounts = Set(7...20) as Set<NSNumber>
        
        // Create new barcode capture mode with the settings from above.
        barcodeCapture = BarcodeCapture(context: context, settings: settings)
        
        // Register self as a listener to get informed whenever a new barcode got recognized.
        barcodeCapture.addListener(self)
        
        // To visualize the on-going barcode capturing process on screen, setup a data capture view that renders the
        // camera preview. The view must be connected to the data capture context.
        captureView = DataCaptureView(frame: cameraBaseView.bounds)
        captureView.context = context
        //captureView.autoresizingMask = [.flexibleWidth]
        captureView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cameraBaseView.addSubview(captureView)
        
        // Add a barcode capture overlay to the data capture view to render the location of captured barcodes on top of
        // the video preview. This is optional, but recommended for better visual feedback.
        overlay = BarcodeCaptureOverlay(barcodeCapture: barcodeCapture)
        overlay.viewfinder = RectangularViewfinder()
        captureView.addOverlay(overlay)
    }
    
    private func showResult(_ result: String, completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: result, message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in completion() }))
            self.present(alert, animated: true, completion: nil)
        }
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

// MARK: - BarcodeCaptureListener Delegate


extension ScannerBaseViewController: BarcodeCaptureListener {
    
    func barcodeCapture(_ barcodeCapture: BarcodeCapture,
                        didScanIn session: BarcodeCaptureSession,
                        frameData: FrameData) {
        guard let barcode = session.newlyRecognizedBarcodes.first else {
            return
        }
        
        // Stop recognizing barcodes for as long as we are displaying the result. There won't be any new results until
        // the capture mode is enabled again. Note that disabling the capture mode does not stop the camera, the camera
        // continues to stream frames until it is turned off.
        barcodeCapture.isEnabled = false
        
        // If you are not disabling barcode capture here and want to continue scanning, consider setting the
        // codeDuplicateFilter when creating the barcode capture settings to around 500 or even -1 if you do not want
        // codes to be scanned more than once.
        
        // Get the human readable name of the symbology and assemble the result to be shown.
        let symbology = SymbologyDescription(symbology: barcode.symbology).readableName
        
        
        let result = "Scanned: \(barcode.data) (\(symbology))"
        fullBarCode = barcode.data
        
       // Added the enable barcode function here to avoid multiple scanning for code 39 bar codes.
        
        
        if UPCTypeModel.getUPCType(symbology) == UPCType.code39.rawValue {
             SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: "Please Scan the barcode on the Product" , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
            self.enableTheBarCode()
             //barcodeCapture.isEnabled = true
            return
        }
        
        print("************Item Scanned --->> \(result)************")
        
        
        // MARK : -Pranav Bug Fix : for Code 128 barcodes: All the produce barcodes were also code 128, hence above error handling was wrong
        
        print(barcode.symbolCount)
        
        if barcode.symbolCount == 18 && UPCType.code128.rawValue == "Code 128"
        {
            SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: "Item not supported" , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
            self.enableTheBarCode()
        }
        else
        {
            checkForWeightedItem(barcode.data, andUPCType: UPCTypeModel.getUPCType(symbology))
        }

        
        //checkForWeightedItem(barcode.data, andUPCType: UPCTypeModel.getUPCType(symbology))
        

    }
    
}

private extension ScannerBaseViewController {
    
    func enableTheBarCode(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0, execute: {
            self.barcodeCapture.isEnabled = true
        })
    }
    
    
    func getLbUsingPluBarCode(_ barcode : String) -> String? {
  
        let index = barcode.index(barcode.endIndex, offsetBy: -6)
        guard let  lbValue  = Int(barcode[index...]) else {
            return nil
        }
        return String( Double(lbValue)/(1000))
    }
    
    func getQunatityUsingPluBarCode(_ barcode : String) -> String? {
        
        return barcode.substring(start: 18, offsetBy: 2)
        
       
    }

    
    private func checkForWeightedItem(_ barcode:String , andUPCType upcType : String){
        if upcType == UPCType.dataBar.rawValue
        {
            print(barcode.substring(start: 2, offsetBy: 13))
            
            makeItemLookUPAPICallWithBarCode(barcode.substring(start: 2, offsetBy: 13) ?? "", andUPCType: "DATABAR")
//            DispatchQueue.main.async {
//            if let itemlookUpVC = UIStoryboard.scan.instantiateViewController(withIdentifier: "WeightedScanDisplayViewController") as? WeightedScanDisplayViewController {
//                self.navigationController?.pushViewController(itemlookUpVC, animated: true)
//
//            }
//            }
        }
        else if upcType == UPCType.plu.rawValue {
            guard let trimString = barcode.substring(start: 5, offsetBy: 1) else {
                 makeItemLookUPAPICallWithBarCode(barcode, andUPCType: "PLU")
                
                return
            }
            //Compare"
            if trimString == "9" {
                makeItemLookUPAPICallWithBarCode(barcode.substring(start: 5, offsetBy: 5) ?? "", andUPCType: "PLU")
            } else if trimString == "0" {
                makeItemLookUPAPICallWithBarCode(barcode.substring(start: 6, offsetBy: 4) ?? "", andUPCType: "PLU")
                
            }
                // Handling bulk bin code 128 barcodes.
            else if trimString == "2"
            
            {
                makeItemLookUPAPICallWithBarCode(barcode.substring(start: 5, offsetBy: 5) ?? "", andUPCType: "PLU")
            }
            
        }
            
        else
        {
            makeItemLookUPAPICallWithBarCode(barcode, andUPCType: upcType)
        }
    }
    
    func makeItemLookUPAPICallWithBarCode(_ barcode:String , andUPCType upcType : String){
        let sharedInstance = UcheckoutSingleton.shared
        guard let storeId = sharedInstance.getprofileModelData?.stores?.storeID else {
            return
        }
        //let storeId = 9718
        let itemLookUpViewModel = ItemLookUpViewModel()
        // getCompleteURl
        // getScanAndGoDevJSCompleteURl
        // getScanAndGoDevJSCompleteURl
        // UcheckoutManager.getScanAndGoDevJSCompleteURl
        
        let urlString = "\(UcheckoutManager.getScanAndGoDevJSCompleteURl("/itemlookup"))?upc_type=\(upcType)&scan_code=\(barcode)&storeid=\(storeId)"
        print("urlString------>",urlString)
        itemLookUpViewModel.getItemLookUp(strUrl: urlString, parentViewController: self) { (status, response, message) in
            DispatchQueue.main.async {
                if status {
                    if let itemLookUpModel = response {
                        if let ack = itemLookUpModel.ack {
                            if ack == "0" {
                                
//                                if let j4uCouponsDisplay = itemLookUpModel.jfuOfferCount{
//
//                                }
                                
                                if let itemDetail = itemLookUpModel.data
                                {
                                    if let restrictedItem = itemDetail.restrictedItem , restrictedItem
                                    {
                                        // Pranav Bug Fix : as per UX Review
                                        SwiftMessageBaseClass().showErrorMessage(title: "Age restricted item", body: "Please use the Front-end Lanes." , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                                        
                                        self.enableTheBarCode()
                                    }
//                                    else if itemDetail.weightItem == true {
//                                        DispatchQueue.main.async {
//                                            if let itemlookUpVC = UIStoryboard.scan.instantiateViewController(withIdentifier: "WeightedScanDisplayViewController") as? WeightedScanDisplayViewController {
//
//                                                self.navigationController?.pushViewController(itemlookUpVC, animated: true)
//                                                itemlookUpVC.isFromScanPage = true
//                                                itemlookUpVC.itemName = itemDetail.posDescription
//
//                                            }
//                                        }
//                                    }
                                        
                                    else if upcType == "DATABAR"{
                                        if itemDetail.weightItem == true {
                                            DispatchQueue.main.async {
                                            if let itemlookUpVC = UIStoryboard.scan.instantiateViewController(withIdentifier: "WeightedScanDisplayViewController") as? WeightedScanDisplayViewController { self.navigationController?.pushViewController(itemlookUpVC, animated: true)
                                                itemlookUpVC.isFromScanPage = true
                                                itemlookUpVC.itemName = itemDetail.posDescription

                                                 }
                                               }
                                             }
                                        else {
                                            if let itemlookUpVC = UIStoryboard.item.instantiateViewController(withIdentifier: "ItemLookUpViewController") as? ItemLookUpViewController{
                                                itemlookUpVC.isFromScanPage = true
                                                itemlookUpVC.cartCaseState = .Add
                                                itemlookUpVC.itemDetail = itemDetail
                                            itemlookUpVC.itemQuantity = self.getQunatityUsingPluBarCode(self.fullBarCode ?? "")
                                             itemlookUpVC.upcType = UPCType(rawValue: upcType)
                                                
                                                itemlookUpVC.isFromScanPage = true
                                              //  itemlookUpVC.clubPrices = itemLookUpModel.clubPrice
                                                itemlookUpVC.clubPrices = itemDetail.clubPrice
                                                if let j4uCopon = itemDetail.jfuOfferCount{
                                                    itemlookUpVC.j4uCoupons = j4uCopon
                                                }
                                                
                                            self.navigationController?.pushViewController(itemlookUpVC, animated: true)
                                            }
                                        }

                                    }
                                    else
                                    {
                                    if let itemlookUpVC = UIStoryboard.item.instantiateViewController(withIdentifier: "ItemLookUpViewController") as? ItemLookUpViewController
                                    {
                                          itemlookUpVC.isFromScanPage = true
                                       //   itemlookUpVC.clubPrices = itemLookUpModel.clubPrice
                                        itemlookUpVC.clubPrices = itemDetail.clubPrice
                                        
                                        if let j4uCopon = itemDetail.jfuOfferCount{
                                            itemlookUpVC.j4uCoupons = j4uCopon
                                        }
                                        
                                       
                                        
                                        if let item = self.itemElementArray?.first(where: {$0.scanCode == itemDetail.scanCode}) {
                                            itemlookUpVC.cartCaseState = .Update
                                            itemlookUpVC.itemElement = item
                                            itemlookUpVC.itemDetail = itemDetail
                                            // do something with foo
                                        } else {
                                            itemlookUpVC.cartCaseState = .Add
                                            itemlookUpVC.itemDetail = itemDetail
                                            
                                            // item could not be found
                                        }
//
                                        if itemDetail.weightItem == true {
                                            itemlookUpVC.itemWeight = self.getLbUsingPluBarCode(self.fullBarCode ?? "")
                                        }
                                        else if  itemDetail.weightItem == false && upcType == UPCType.plu.rawValue{
                                            itemlookUpVC.itemQuantity = self.getQunatityUsingPluBarCode(self.fullBarCode ?? "")
                                        }
                                        itemlookUpVC.upcType = UPCType(rawValue: upcType)
                                    
                                        self.navigationController?.pushViewController(itemlookUpVC, animated: true)
                                        
                                    }
                                    
                                    
                                    }
                                    
                                }
                                
                                
                            }
                            else if ack == "1"{
                                if let errorsArray = itemLookUpModel.errors {
                                    if errorsArray.count > 0 {
                                        if errorsArray[0].code == "4004"{
                                            SwiftMessageBaseClass().showErrorMessage(title: "Item not supported", body: errorsArray[0].message ?? "" , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                                            self.enableTheBarCode()
                                        }
                                        else {
                                            SwiftMessageBaseClass().showErrorMessage(title: "Item not supported", body: "Please use the regular checkout." , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                                            self.enableTheBarCode()
                                        }
                                        // Pranav Bug Fix : as per UX Review
                                        //                                        SwiftMessageBaseClass().showErrorMessage(title: "Item not supported", body: "Please use the regular checkout." , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                                        //                                        self.enableTheBarCode()
                                    }
                                }
                                else {
                                    // Pranav Bug Fix : as per UX Review
                                    SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: "Something went wrong" , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                                }
                            }
                        }
                    }
                }
                
            }
        }
    }
    
}

extension ScannerBaseViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        return transiton
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        return transiton
    }
}
extension ScannerBaseViewController : MenuTableControllerProtocol {
    func menuClickedWithIndexpath(_ indexpath: IndexPath) {
        super.movetoControllerWithIndexpath(indexpath)
    }
    
    
    
}

