//
//  HomeViewController.swift
//  UCheckout
//
//  Created by i2i innovation on 09/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import UIKit
import CoreLocation
import Firebase




class HomeViewController: BaseViewController {
    
    @IBOutlet weak var customNavigationBarView: CustomNavigationBarView!
    
    // MARK: - IBOutlet Connection
    
    @IBOutlet weak var noLocationStoreButton: UIButton!
    @IBOutlet weak var searchPluButton: UIButton!
    
    @IBOutlet weak var scanBarCodeButton: UIButton!
    
    
    @IBOutlet weak var buttonBGView: UIView!
    
    @IBOutlet weak var operatingHrLabel: UILabel!
    
    @IBOutlet weak var itemLimitLabel: UILabel!
    
    @IBOutlet weak var helpButton: UIButton!
    
    @IBOutlet weak var messageImage: UIView!
    
    @IBOutlet weak var welcomeNameLabel: UILabel!
    
 
    @IBOutlet weak var addressLabel: UILabel!
    
    
    @IBOutlet weak var storeDetailStackView: UIStackView!
    
    @IBOutlet weak var wifiEnableButtonOutlet: UIButton!
    
    @IBOutlet weak var clubCardLabel: UILabel!
    

    
    @IBOutlet weak var cartCountLabel: CircularLabel!
    
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var welcomeTopConstraints: NSLayoutConstraint!
    
    @IBOutlet weak var contentViewTopConstarints: NSLayoutConstraint!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    // MARK: - Variable Definations

    private var registeredToBackgroundEvents = false
    private var homeViewModel = HomeViewModel()
    private var itemElementArray : [ItemElement]?
    private var viewCartData : ViewCartData?
    var customView = CustomNavigationBarView()
    
    private let transiton = SlideInTransition()
    private var topView: UIView?
    private var currentLoc : CLLocation?
    private var refreshControl: UIRefreshControl!

    
    var currentLocation : CLLocationCoordinate2D? {
        didSet {
            self.getProfileData()
        }
    }

    
    
    

    
     // MARK: - View Life Cycle Methods
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        customNavigationBarView.customNavBarProtocolDelegate = self
        self.navigationController?.navigationBar.isHidden = true
        updateUserInfoo()
        let mangager = NetworkManager.shared
        mangager.delegate = self
        mangager.startNetworkReachabilityObserver()
        
        clubCardLabel.textColor = UIColor.red
        
        //print("myCount ---->",myCount!)
    
      
    }
    
    private func setMenuAction(){
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        UcheckoutLocationManager.sharedInstance.delegate = self
        UcheckoutLocationManager.sharedInstance.checkLocationStatus()
         self.navigationController?.navigationBar.isHidden = true
        registerToBackFromBackground()
        getViewCartData()
        super.viewWillAppear(animated)
        switch UIDevice().type {
        case .iPhoneSE,.iPhone5,.iPhone5S,.iPhone5C:
            logoTopConstraint.constant = 10
            welcomeTopConstraints.constant = 5
            contentViewTopConstarints.constant = 5
            self.view.updateConstraintsIfNeeded()
        
        default:
            break;
        }
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        


    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UcheckoutLocationManager.sharedInstance.stopUpdatingLocation()

        unregisterFromBackFromBackground()
   
    }
    
    override func gestureClicked() {
        super.gestureClicked()
        menuButtonClicked()
    }
    
    
     // MARK: - Private Methods
    
    @objc func refresh() {
        refreshControl.endRefreshing()
        self.getProfileData()
    }
    
    private func updateUserInfoo(){
        self.wifiEnableButtonOutlet.isHidden = true
        self.wifiEnableButtonOutlet.isUserInteractionEnabled = false
       
        let shared = UcheckoutSingleton.shared
        if let user = shared.userData {
            if let firstName = user.firstName {
                welcomeNameLabel.text = "Welcome \(firstName)!"
            }
            
        }
        
        
        
    }


    private func upDateUI(){

        self.customNavigationBarView.cartCountLabel.text = "\(viewCartData?.totalQuantity ?? 0)"

        
    }
    
    // called the setCenterButton to disable tapping on homeVC when user is out of cart.
    private func makeViewGreyOut() {
        self.buttonBGView.alpha = 0.5
        self.scanBarCodeButton.isUserInteractionEnabled = false
        self.searchPluButton.isUserInteractionEnabled = false
        self.searchPluButton.alpha = 0.5
        self.helpButton.alpha = 0.5
        self.scanBarCodeButton.setBackgroundImage(UIImage(named: "fill1Disabled"), for: .normal)
        //self.messageImage.image = UIImage(named: "homeDisableMessage")
         self.messageImage.isHidden = true
        self.noLocationStoreButton.isHidden = false
        noLocationStoreButton.underlineText()
          self.storeDetailStackView.isHidden = true
        self.customNavigationBarView.setCenterButton(enabled: false)
        //Pranav Bug Fix Need to fix this text - hard coded for now - not fitting screen size
        addressLabel.text = "Please go to the nearest U checkout enabled store"
        self.clubCardLabel.isHidden = true
        self.wifiEnableButtonOutlet.isHidden = true

        //addressLabel.text = "Please go to the nearest U checkout enabled store \n 1701 Santa Rita, Pleasanton"
        
    }
    // called the setCenterButton to enable tapping on homeVC when user is out of cart.
    
    private func makeViewNormal() {
        self.buttonBGView.alpha = 1.0
        self.scanBarCodeButton.isUserInteractionEnabled = true
        self.searchPluButton.isUserInteractionEnabled = true
        self.searchPluButton.alpha = 1.0
        self.scanBarCodeButton.alpha = 1.0
        self.helpButton.alpha = 1.0
        self.scanBarCodeButton.setBackgroundImage(UIImage(named: "fill1"), for: .normal)
        self.messageImage.isHidden = false
          self.noLocationStoreButton.isHidden = true
        self.storeDetailStackView.isHidden = false

        //self.messageImage.image = UIImage(named: "homeEnableMessage") //To start shopping, select ‘Scan Barcode’ now!
        self.customNavigationBarView.setCenterButton(enabled: true)
        self.clubCardLabel.isHidden = false
        self.wifiEnableButtonOutlet.isHidden = false
        
       
        // Pranav Bug Fix : as per UX Review
    }
    
    private func  getProfilePramaDict() -> [String:Any] {
        guard let coord = currentLocation else {
            fatalError()
        }
        let shared = UcheckoutSingleton.shared
        guard let guid = shared.userData?.guid else {
            fatalError()
        }
        guard let userId = shared.userData?.userId else {
            fatalError()
        }
        
        let parameters = [
            "GUID": guid,
            "email": userId,
            "app": AppConstants.AppName,
            "latitude": "\(coord.latitude)",
            "longitude": "\(coord.longitude)",
            "version": Bundle.main.shortVersion,
            "platform": AppConstants.Platform,
            "banner": AppConstants.Banner
            ] as [String : Any]
        return parameters
    }
    
    
    
    // MARK: - DidBecome Notification custom Methods
    
    private func registerToBackFromBackground() {
        if(!registeredToBackgroundEvents) {
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(viewDidBecomeActive),
                                                   name: UIApplication.didBecomeActiveNotification, object: nil)
            registeredToBackgroundEvents = true
        }
    }
    
    private func unregisterFromBackFromBackground() {
        if(registeredToBackgroundEvents) {
            NotificationCenter.default.removeObserver(self,
                                                      name: UIApplication.didBecomeActiveNotification, object: nil)
            registeredToBackgroundEvents = false
        }
        
    }

    
    @objc func viewDidBecomeActive(){
        if let _ = self.currentLocation {
            getProfileData()
        }
    }
    
     // MARK: - Network Calls Methods
    
    
    private func getProfileData(){
        let shared = UcheckoutSingleton.shared
        shared.isInStoreRegion = false
        homeViewModel.getProfileData(strUrl: UcheckoutManager.getRetailCompleteURl("/getprofile"), params: getProfilePramaDict(), parentViewController: self) { [weak self] (success, response, message) in
            DispatchQueue.main.async {
                if success {
                    if let response = response {
                        if let ack = response.ack {
                            if ack == "0" {
                                if let getprofileModelData = response.data {
                                    let sharedInstance = UcheckoutSingleton.shared
                                    sharedInstance.getprofileModelData = getprofileModelData
                                    if let localSelf = self {
                                        localSelf.updateStoreData(getprofileModelData)
                                        localSelf.getViewCartData()
                                    }
                                    
                                    
                                }
                            
                            }
                            else if ack == "1"{
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
                    if let localSelf = self {
                       localSelf.upDateUI()
                    }
                    
                    SwiftMessageBaseClass().showErrorMessage(title: "Alert", body: message! , isButtonVisible: true, buttonTitle: "OK", buttonImage: nil)
                }
            }

        }
        
    }
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
                                    self.updateProfileData(viewCartData)
                                    

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
    


    
     // MARK: - IB Action Methods
    
    
    @IBAction func wifiButtonEnableAction(_ sender: UIButton)
    {
        let url = URL(string: "App-Prefs:root=WIFI") //for WIFI setting app
        let app = UIApplication.shared
        app.open(url!, options: [:], completionHandler: nil)
    }
    
    
    @IBAction func noLocationButtonAction(_ sender: UIButton) {
        let vc = WebkitViewController.loadFromNib()
        vc.urlString = "https://ucheckout.azurewebsites.net"
        vc.screenTitle = "Store Locations"
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func helpButtonClicked(_ sender: UIButton) {
        if let scanVC = UIStoryboard.scanHelp.instantiateViewController(withIdentifier: "ScanHelpBaseViewController") as? ScanHelpBaseViewController {
            scanVC.helpType = .Home
            scanVC.modalPresentationStyle = .overCurrentContext
            present(scanVC, animated: true, completion: nil)
        }
         FirebaseEventmanger.logEventWithName("helpButtonPressed_Homepage", andCustomAttributes: ["build_number":UIDevice().appShortVersion,"Source":"HomeViewController","event_day_of_week":UcheckoutManager.getDay()])
        
    }
    
    
    @IBAction func pluButtonAction(_ sender: UIButton) {
         FirebaseEventmanger.logEventWithName("PLUButtonPressed_HomePage", andCustomAttributes: ["build_number":UIDevice().appShortVersion,"page":"HomeViewController","event_day_of_week":UcheckoutManager.getDay()])
        
        if let pluVC = UIStoryboard.plu.instantiateViewController(withIdentifier: "PLUBaseViewController") as? PLUBaseViewController {
            self.navigationController?.pushViewController(pluVC, animated: true)
        }
        
        
    }
    
    
    
    @IBAction func scanBarButtonAction(_ sender: UIButton) {
        
        if let scanVC = UIStoryboard.scan.instantiateViewController(withIdentifier: "ScannerBaseViewController") as? ScannerBaseViewController {
            scanVC.itemElementArray = self.itemElementArray
            self.navigationController?.pushViewController(scanVC, animated: true)
        }
        FirebaseEventmanger.logEventWithName("ScanButton_pressed", andCustomAttributes: ["build_number":UIDevice().appShortVersion,"page":"HomeViewController","event_day_of_week":UcheckoutManager.getDay(), "guid": UcheckoutSingleton.shared.userData?.guid ?? 0])
        
        
        Analytics.setUserProperty("\(String(describing: UcheckoutSingleton.shared.userData?.firstName))", forName: "first_name")
        Analytics.setUserProperty("\(String(describing: UcheckoutSingleton.shared.userData?.lastName))", forName: "last_name")
        Analytics.setUserProperty("\(String(describing: UcheckoutSingleton.shared.userData?.guid))", forName: "user_guid")
 
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

extension HomeViewController : SwiftMessageBaseClassProtocol {
    func bannerButtonClicked() {
        guard let urlGeneral = URL(string: UIApplication.openSettingsURLString) else {
            return
        }
        UIApplication.shared.open(urlGeneral)
    }
    
    
}

extension HomeViewController : LocationServiceDelegate {
    func locationNotEnabled() {
        let swiftMessageBaseClass = SwiftMessageBaseClass()
         swiftMessageBaseClass.showErrorMessage(title: "Alert", body: "Enable location service", isButtonVisible: true, buttonTitle: "Enable", buttonImage: nil)
        swiftMessageBaseClass.swiftMessageBaseClassProtocol = self
        self.makeViewGreyOut()
    }
    
    func tracingLocation(currentLocation: CLLocation) {
        print("**********currentLocation is \(currentLocation.coordinate)********")
        if let coord = self.currentLocation {
            if currentLocation.coordinate.latitude != coord.latitude || currentLocation.coordinate.longitude != coord.longitude {
                if let cuurentLoc = self.currentLoc {
                    let elapsed = currentLocation.timestamp.timeIntervalSince(cuurentLoc.timestamp)
                    
                    if (elapsed > 120.0) {
                        self.currentLocation = currentLocation.coordinate
                        self.currentLoc = currentLocation
                        
                    }
                }
                

            }
        }
        else {
            self.currentLocation = currentLocation.coordinate
            self.currentLoc = currentLocation

        }
       
    }
    
    func tracingLocationDidFailWithError(error: Error) {
         print("**********tracingLocationDidFailWithError is \(error)********")
        
    }
    
    
}

private extension HomeViewController {
    func getWhetherStoreInRadius(_ store : Stores) -> Bool{
        guard let lat = store.latitude else {
            return false
        }
        guard let long = store.longitude else {
            return false
        }
        
        var radius = 150.0
        if let storeRadius = store.storeRadius {
            radius = storeRadius
        }
        
        
        let storeLatitude: CLLocationDegrees = lat.toDouble()
        let storeLongitude: CLLocationDegrees = long.toDouble()
        
        let storeLocation: CLLocation = CLLocation(latitude: storeLatitude,
                                              longitude: storeLongitude)
        
        
        let userLatitude: CLLocationDegrees = self.currentLocation?.latitude ?? 0.0
        let userLongitude: CLLocationDegrees = self.currentLocation?.longitude ?? 0.0
        
        let userLocation: CLLocation = CLLocation(latitude: userLatitude,
                                              longitude: userLongitude)
        
        let distance =  userLocation.distance(from: storeLocation)
        if distance > radius {
           // return true
            return false
        }
        else {
             return true
        }
      
       
    }
    
    func updateStoreData(_ getprofileModelData : GetprofileModelData){
        let shared = UcheckoutSingleton.shared
        if let customerdetails = getprofileModelData.customerdetails {
            if let itemLimit = customerdetails.itemLimit {
                let itemLabel:String = itemLimit>1 ? StringConstants.Items : StringConstants.Item

//                self.itemLimitLabel.attributedText = UcheckoutManager.getAtttributedStringWithString1(StringConstants.ItemLimit, string2: "\(itemLimit) \(itemLabel)")
               
               
                self.itemLimitLabel.attributedText = UcheckoutManager.getAtttributedStringWithString1(StringConstants.ItemLimit, string2: "\(itemLimit) \(itemLabel)")

            }
        }
        if let stores = getprofileModelData.stores {
            
            if self.getWhetherStoreInRadius(stores) {
                shared.isInStoreRegion = true
                if let address = stores.address {
                    addressLabel.text = address
                }
                self.makeViewNormal()
            }

            else {
                  shared.isInStoreRegion = false
                  self.makeViewGreyOut()
            }
            if let sngStoreHours = stores.sngStoreHours {
                self.operatingHrLabel.attributedText = UcheckoutManager.getAtttributedStringWithString1(StringConstants.StoreOperatingHours, string2: sngStoreHours)
                
                
            }
        }
        else {
            if let sngStoreHours = getprofileModelData.sngStoreHours , sngStoreHours == false {
                  shared.isInStoreRegion = true
                 self.makeViewGreyOut()
            }
        }
    }
    
    func updateProfileData(_ viewCartData : ViewCartData){
        if let items = viewCartData.items {
            self.itemElementArray = items
            let shared = UcheckoutSingleton.shared
            shared.itemElementArray = self.itemElementArray
            self.upDateUI()
        }
        
        
    }
    
    
    
    
}

extension HomeViewController : CustomNavBarProtocol {
    func centerButtonClicked()
    {
        if let cartVC = UIStoryboard.cart.instantiateViewController(withIdentifier: "CartBaseViewController") as? CartBaseViewController {
            self.navigationController?.pushViewController(cartVC, animated: true)
        }
    }
    
    func menuButtonClicked() {
        guard let menuViewController = storyboard?.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController else { return }
       
        menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self
        menuViewController.menuTableControllerProtocol = self
        present(menuViewController, animated: true)
    }
    
    
}


extension HomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        return transiton
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        return transiton
    }
}

extension HomeViewController : MenuTableControllerProtocol {
    func menuClickedWithIndexpath(_ indexpath: IndexPath) {
        super.movetoControllerWithIndexpath(indexpath)
    }
    
    
    
}



extension HomeViewController : NetworkManagerProtocol {
    func wifiRechability(isAvailable: Bool) {
        if isAvailable {
            self.wifiEnableButtonOutlet.isHidden = true
            self.wifiEnableButtonOutlet.isUserInteractionEnabled = false
        }
        else {
            self.wifiEnableButtonOutlet.isHidden = false
            self.wifiEnableButtonOutlet.isUserInteractionEnabled = true
        }
    }
    
    
}
