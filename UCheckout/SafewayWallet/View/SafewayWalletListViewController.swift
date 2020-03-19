//
//  SafewayWalletListViewController.swift
//  UCheckout
//
//  Created by 1521398 on 25/08/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import UIKit

class SafewayWalletListViewController: UIViewController {
    var presenter: WalletListViewToPresenterProtocol?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var addCardButton: UIButton!
    @IBOutlet weak var empyWalletMessageView: UIView!
    
    @IBOutlet weak var menuButtonOutlet: UIBarButtonItem!
    
    @IBOutlet weak var menuBarButtonItemOutlet : UIButton!
    
    
    
    
    //var base = BaseViewController()
    let transiton = SlideInTransition()
    
    // Button Actions :
    
    
    
    @IBAction func menuButtonAction(_ sender: UIBarButtonItem)
    {
        guard let menuViewController = UIStoryboard.home.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController else { return }
        
                  menuViewController.modalPresentationStyle = .overCurrentContext
        menuViewController.transitioningDelegate = self as UIViewControllerTransitioningDelegate
        menuViewController.menuTableControllerProtocol = self as? MenuTableControllerProtocol
        present(menuViewController, animated: true)
        
    }
    
    
    var walletDetails: WalletDetails?
    let connectivityService = ConnectivityService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuButtonOutlet.isEnabled = false
        menuButtonOutlet.tintColor = UIColor.clear
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorColor = .gray

        
        // Do any additional setup after loading the view.
        configureUI()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if connectivityService.isOnline() {
            errorView.isHidden = true
            presenter?.fetchCards()
        } else {
            showNetworkError()
        }
    }

    
    private func configureUI()
    {
        let nib = UINib(nibName: "WalletTableViewCell", bundle: nil)
        
        self.tableView.register(nib, forCellReuseIdentifier: "WalletTableViewCell")
        
        errorView.isHidden = true
        empyWalletMessageView.isHidden = true
        isEnableAddCard(enable: false)
    }
    
    func movetoControllerWithIndexpath(_ indexpath: IndexPath) {
        switch indexpath.row {
        case 1:moveToHomeMenu()
        case 2 : moveToCartMenu()
        case 3:moveToAccount()
        case 4 : movetoSafewayWallet()
        case 5: moveToRecieptMenu()
        case 6 : moveToAboutMenu()
        case 7:logOut()
            
        default:
            break
        }
    }

    @IBAction func backButtonDidTapped(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func didTappedAddNewCreditCard(_ sender: Any) {
        presenter?.addNewCreditCard()
    }
    
    
    private func showNetworkError() {
        errorView.isHidden = false
        errorMessageLabel.text = SafewayWalletConstants.Messages.internetError
    }

    private func maxCountError() {
        let cardsCount = walletDetails?.accountArray?.count ?? 0
        errorView.isHidden = cardsCount != 3
        if cardsCount == 3 {
            errorMessageLabel.text = SafewayWalletConstants.Messages.cardMaxCountReached
        }
        isEnableAddCard(enable: cardsCount != 3)
        empyWalletMessageView.isHidden = cardsCount != 0
    }
    
    private func isEnableAddCard(enable: Bool) {
        if enable {
            addCardButton.isEnabled = true
            addCardButton.alpha = 1.0
        } else {
            addCardButton.isEnabled = false
            addCardButton.alpha = 0.3
        }
    }
}

extension SafewayWalletListViewController: WalletListPresenterToViewProtocol {
    func showError(message: String) {
        errorView.isHidden = false
        errorMessageLabel.text = message
    }
    
    func showActivityIndicator() {
        DispatchQueue.main.async {
            MBProgressIndicator.showIndicator(self.view)
        }
    }
    
    func hideActiviyIndicator() {
        DispatchQueue.main.async {
            MBProgressIndicator.hideIndicator(self.view)
        }
    }
    
    func show(walletDetails: WalletDetails) {
        self.walletDetails = walletDetails
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
        maxCountError()
    }
}

//MARK: - UITableView Delegate and DataSource
extension SafewayWalletListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (UserDefaults.standard.value(forKey: "ApplePayEnabled") != nil) {
            let rowsCount = walletDetails?.accountArray?.count ?? 0
            if walletDetails?.accountArray?.count == 3 && upayAdded() {
                return rowsCount + 1
            }
            return rowsCount + 2
        }
       return walletDetails?.accountArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let accountsArray = walletDetails?.accountArray ?? []
        if (UserDefaults.standard.value(forKey: "ApplePayEnabled") != nil) {
            if accountsArray.count == 4 && indexPath.row == 4 {
                return 0
            }
        } else {
            if accountsArray.count == 3 && indexPath.row == 3 && upayAdded() {
                return 0
            }
        }
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "WalletTableViewCell", for: indexPath) as? WalletTableViewCell else {
            preconditionFailure()
        }
        cell.statusLabel.isHidden = true
        cell.leadingConstraint.constant = 20
        let accountsArray = walletDetails?.accountArray ?? []
        if (UserDefaults.standard.value(forKey: "ApplePayEnabled") != nil) {
            if indexPath.row == accountsArray.count + 1 {
                cell.nameLabel.text = accountsArray.count != 3 ? "Add Payment Method" : "Enroll in UPay"
                cell.nameLabel.font = UIFont(name: "SFProText-Regular", size: 17.0)
                cell.nameLabel.textColor = UIColor(red: 28/255, green: 121/255, blue: 232/255, alpha: 1)
                cell.cardImageView.isHidden = true
                cell.leadingConstraint.constant = -48
                cell.accessoryType = .none
                return cell
            }
            else {
                if indexPath.row == accountsArray.count {
                    cell.nameLabel.text = "Apple Pay"
                    cell.nameLabel.font = UIFont(name: "SFProText-Regular", size: 17.0)
                    cell.nameLabel.textColor = UIColor(red: 28/255, green: 121/255, blue: 232/255, alpha: 1)
                    cell.cardImageView.image = #imageLiteral(resourceName: "applePay")
                    cell.cardImageView.contentMode = UIView.ContentMode.scaleAspectFill
                    cell.cardImageView.isHidden = false
                    // UserDefaults.standard.set("ApplePay", forKey: "cardSelected")
                    if (UserDefaults.standard.value(forKey: "cardSelected") != nil) {
                        if UserDefaults.standard.string(forKey: "cardSelected") == "ApplePay" {
                            cell.accessoryType = .checkmark
                        }
                        else {
                            cell.accessoryType = .none
                        }
                    }
                    else {
                        cell.accessoryType = .none
                    }
                    return cell
                } else {
                    var last4Dight = ""
                    let accountObject = accountsArray[indexPath.row]
                    if let fdAccountId = accountObject.fdAccountId {
                        if let cardDetail = walletDetails {
                            if let defaultCard = cardDetail.defaultCard {
                                
                                if UserDefaults.standard.string(forKey: "cardSelected") == "ApplePay" {
                                    cell.accessoryType = .none
                                }
                                else {
                                    if defaultCard == fdAccountId {
                                        cell.accessoryType = .checkmark
                                    }
                                    else{
                                        cell.accessoryType = .none
                                    }
                                }
                            }
                        }
                        if let tokenObj = accountObject.token {
                            if let token = tokenObj.tokenId {
                                last4Dight = String(token.suffix(4))
                                cell.nameLabel.text = last4Dight.uppercased()
                                UserDefaults.standard.set(last4Dight, forKey: "lastFour")
                            }
                        }
                    }
                    if accountObject.type == "ACH" {
                        //TODO: Check micro validation
                        // Change Made: Changed text label for table view to display bank account number
                        let acct_num = UserDefaults.standard.string(forKey: "UPayAccountNumber") ?? ""
                        cell.nameLabel.text = "Bank Acct " + acct_num
                        cell.cardImageView.image = WalletCommonUtils.cardInfo(using: accountObject.type ?? "", alias: "").image
                        if WalletCommonUtils.uPayStatusPending() {
                            cell.statusLabel.isHidden = false
                            cell.statusLabel.text = "Status- Pending Verification"
                            cell.accessoryType = .disclosureIndicator
                        }
                    } else if let credit = accountObject.credit {
                        if let cardType = credit.cardType {
                            UserDefaults.standard.set(cardType, forKey: "cardName")
                            var cardTypeDetail = ""
                            if cardType == "VISA" {
                                cardTypeDetail =  String(format:"Visa Credit - %@", last4Dight.capitalized)
                            }
                            else if cardType == "MASTERCARD" {
                                cardTypeDetail =  String(format:"Mastercard Credit - %@", last4Dight.capitalized)
                            }
                            else if cardType == "DISCOVER" {
                                cardTypeDetail =  String(format:"Discover - %@", last4Dight.capitalized)
                            }
                            cell.nameLabel.text = cardTypeDetail
                            cell.cardImageView.image =  WalletCommonUtils.cardInfo(using: cardType, alias: "").image
                        }
                    }
                    cell.cardImageView.isHidden = false
                    cell.nameLabel.textColor = UIColor.black
                    cell.nameLabel.font = UIFont(name: "SFProText-Regular", size: 17.0)
                    return cell
                }
            }
        } else {
            if indexPath.row == accountsArray.count {
                cell.nameLabel.text = accountsArray.count != 3 ? "Add Payment Method" : "Enroll in UPay"
                cell.nameLabel.font = UIFont(name: "SFProText-Regular", size: 17.0)
                cell.nameLabel.textColor = UIColor(red: 28/255, green: 121/255, blue: 232/255, alpha: 1)
                cell.cardImageView.isHidden = true
                cell.leadingConstraint.constant = -48
                cell.accessoryType = .none
            } else {
                var last4Dight = ""
                let accountObject = accountsArray[indexPath.row]
                if let fdAccountId = accountObject.fdAccountId {
                    
                    if let defaultCard = walletDetails?.defaultCard {
                        if defaultCard == fdAccountId {
                            cell.accessoryType = .checkmark
                        }
                        else{
                            cell.accessoryType = .none
                        }
                    }
                    if let tokenObj = accountObject.token {
                        if let token = tokenObj.tokenId {
                            last4Dight = String(token.suffix(4))
                            cell.nameLabel.text = last4Dight.uppercased()
                            UserDefaults.standard.set(last4Dight, forKey: "lastFour")
                        }
                    }
                }
                
                if accountObject.type == "ACH" {
                    //TODO: Check micro validation
                    let acct_num = UserDefaults.standard.string(forKey: "UPayAccountNumber") ?? ""
                    cell.nameLabel.text = "Bank Acct " + acct_num
                    cell.cardImageView.image = WalletCommonUtils.cardInfo(using: accountObject.type ?? "", alias: "").image
                    if WalletCommonUtils.uPayStatusPending() {
                        cell.statusLabel.isHidden = false
                        cell.statusLabel.text = "Status- Pending Verification"
                        cell.accessoryType = .disclosureIndicator
                    }
                } else if let credit = accountObject.credit {
                    if let cardType = credit.cardType {
                        UserDefaults.standard.set(cardType, forKey: "cardName")
                        var cardTypeDetail = ""
                        if cardType == "VISA" {
                            cardTypeDetail =  String(format:"Visa - %@", last4Dight.capitalized)
                        }
                        else if cardType == "MASTERCARD" {
                            cardTypeDetail =  String(format:"Mastercard - %@", last4Dight.capitalized)
                        }
                        else if cardType == "DISCOVER" {
                            cardTypeDetail =  String(format:"Discover - %@", last4Dight.capitalized)
                        }
                        cell.nameLabel.text = cardTypeDetail
                        cell.cardImageView.image =  WalletCommonUtils.cardInfo(using: cardType, alias: "").image
                    }
                    
                    
                }
                cell.cardImageView.isHidden = false
                cell.nameLabel.textColor = UIColor.black
                cell.nameLabel.font = UIFont(name: "SFProText-Regular", size: 17.0)
                cell.leadingConstraint.constant = 20
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let accountsArray = walletDetails?.accountArray ?? []
        if (UserDefaults.standard.value(forKey: "ApplePayEnabled") != nil) {
            if indexPath.row == accountsArray.count + 1 {
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
                tableView.cellForRow(at: indexPath)?.selectionStyle = UITableViewCell.SelectionStyle.gray
                self.performSegue(withIdentifier:"paymentSetup", sender: nil)
            }
            else{
                if indexPath.row == accountsArray.count
                {
                     if let defaultCard = walletDetails?.defaultCard {
                        presenter?.updateAllCardData(fdAccountId: defaultCard, applePayEnabled: true)
                        UserDefaults.standard.set("ApplePay", forKey: "CardSelected")
                        tableView.reloadData()
                    }
                }
                else{
                    //regualar
                    let accountObject = accountsArray[indexPath.row]
                    if let fdAccountId = accountObject.fdAccountId {
                        presenter?.updateAllCardData(fdAccountId: fdAccountId, applePayEnabled: false)
                    }
                }
            }
        }
        else {
            if indexPath.row == accountsArray.count {
                tableView.cellForRow(at: indexPath)?.accessoryType = .none
                tableView.cellForRow(at: indexPath)?.selectionStyle = UITableViewCell.SelectionStyle.gray
                self.performSegue(withIdentifier:"paymentSetup", sender: nil)
            } else {
                let accountObject = accountsArray[indexPath.row]
                if let fdAccountId = accountObject.fdAccountId {
                    presenter?.updateAllCardData(fdAccountId: fdAccountId, applePayEnabled: false)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if walletDetails?.accountArray?[indexPath.row].type == "ACH" && WalletCommonUtils.uPayStatusPending() {
            tableView.cellForRow(at: indexPath)?.accessoryType = .disclosureIndicator
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let cell = tableView.cellForRow(at: indexPath) as? WalletTableViewCell {
            if cell.nameLabel.text == UPayTitles.uPay && !WalletCommonUtils.uPayStatusPending() {
                return true
            } else if cell.nameLabel.text == "Add Payment Method" || cell.nameLabel.text == "Apple Pay" || cell.nameLabel.text == UPayTitles.enrollInUPay {
                return false
            }
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        //Delete button
        let deleteAction =  UITableViewRowAction(style: .destructive, title: " ") { (action, indexPath) in
            print("Deleted")
            let dict = self.walletDetails?.accountArray?[indexPath.row]
            if let fdCustomerId = dict?.fdAccountId {
                //self.cardsFDAcctID = fdCustomerId
                let alert = UIAlertController(title: "Remove Card?", message:"Are you sure you want to remove this card from your wallet?", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: .default) { _ in
                    self.dismiss(animated: false, completion: nil)
                }
                let removeAction = UIAlertAction(title: "Remove", style: .destructive) { _ in
                    self.presenter?.deleteAccount(fdAccountId: fdCustomerId)
                }
                alert.addAction(cancelAction)
                alert.addAction(removeAction)
                self.present(alert, animated: false, completion: nil)
            }
            
        }
        let commentCell = tableView.dequeueReusableCell(withIdentifier: "WalletTableViewCell") as! WalletTableViewCell
        let height = commentCell.frame.size.height
        let backgroundImage = self.deleteImageForHeight(height: height)
        deleteAction.backgroundColor = UIColor(patternImage: backgroundImage)
        //Edit button for UPay
        // Change Made: checking if cardTextLabel text is the same as the new UPay text
        if let cell = tableView.cellForRow(at: indexPath) as? WalletTableViewCell, (cell.nameLabel.text?.substring(start: 0, offsetBy: 9) == UPayTitles.newUPay || cell.nameLabel.text == UPayTitles.uPay) && !WalletCommonUtils.uPayStatusPending() {
            let editAction = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
                
            }
            return [deleteAction, editAction]
        }
        
        return [deleteAction]
    }
    
}

//MARK: - WalletCellDelegate
extension SafewayWalletListViewController: WalletTableViewCellDelegate {
    func trashIconTapped(from cell: WalletTableViewCell, indexPath: IndexPath?) {
        guard let indexPath = indexPath else {
            return
        }
        let account = walletDetails?.accountArray?[indexPath.row]
        if let fdAccountId = account?.fdAccountId {
            presenter?.deleteAccount(fdAccountId: fdAccountId)
        }
    }
    
    func deleteImageForHeight(height:CGFloat) -> UIImage  {
        
        let frame = CGRect(x:0, y:0, width:70, height:height)
        UIGraphicsBeginImageContext(CGSize(width:70, height:height))
        
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(UIColor(red: 228/255, green: 28/255, blue: 31/255, alpha: 0.7).cgColor)
        context!.fill(frame);
        
        let image = UIImage(named:"iconTrash")
        image?.draw(in:  CGRect(x:28, y:23, width:20, height:26))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage!
    }

    
}

//extension SafewayWalletListViewController : MenuTableControllerProtocol {
//
//        func movetoControllerWithIndexpath(_ indexpath: IndexPath) {
//            switch indexpath.row {
//            case 1:moveToHomeMenu()
//            case 2 : moveToCartMenu()
//            case 3:moveToAccount()
//            case 4 : movetoSafewayWallet()
//            case 5: moveToRecieptMenu()
//            case 6 : moveToAboutMenu()
//            case 7:logOut()
//
//            default:
//                break
//            }
//        }
//
//}

extension SafewayWalletListViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = true
        return transiton
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transiton.isPresenting = false
        return transiton
    }
}


// Move to Functions :

extension SafewayWalletListViewController {
    
    func upayAdded() -> Bool {
        return walletDetails?.accountArray?.filter({ $0.type == "ACH" }).count ?? 0 > 0
    }
    
    func uPayAccountID() -> String? {
        return walletDetails?.accountArray?.filter({ $0.type == "ACH" }).first?.fdAccountId
    }
  
    func moveToAboutMenu(){
        var isFound = false
        if let vcArray = self.navigationController?.viewControllers , vcArray.count != 0{
            for item in vcArray {
                if item.isKind(of: AboutBaseViewController.self) {
                    isFound = true
                    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                        navigationController.popToViewController(item, animated: true)
                        
                    }
                }
            }
        }
        if !isFound {
            if let scanVC = UIStoryboard.about.instantiateViewController(withIdentifier: "AboutBaseViewController") as? AboutBaseViewController {
                if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                    navigationController.pushViewController(scanVC, animated: true)
                }
            }
        }
    }
    
    func moveToCartMenu(){
        var isFound = false
        if let vcArray = self.navigationController?.viewControllers , vcArray.count != 0{
            for item in vcArray {
                if item.isKind(of: CartBaseViewController.self) {
                    isFound = true
                    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                        navigationController.popToViewController(item, animated: true)
                        
                    }
                }
            }
        }
        if !isFound {
            if let scanVC = UIStoryboard.cart.instantiateViewController(withIdentifier: "CartBaseViewController") as? CartBaseViewController {
                if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                    navigationController.pushViewController(scanVC, animated: true)
                    
                }
            }
        }
    }
    
    func moveToRecieptMenu(){
        var isFound = false
        if let vcArray = self.navigationController?.viewControllers , vcArray.count != 0{
            for item in vcArray {
                if item.isKind(of: RecieptBaseViewController.self) {
                    isFound = true
                    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                        navigationController.popToViewController(item, animated: true)
                        
                    }
                }
            }
        }
        if !isFound {
            if let scanVC = UIStoryboard.reciept.instantiateViewController(withIdentifier: "RecieptBaseViewController") as? RecieptBaseViewController {
                if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                    navigationController.pushViewController(scanVC, animated: true)
                    
                }
            }
        }
    }
    func moveToHomeMenu(){
        var isFound = false
        if let vcArray = self.navigationController?.viewControllers , vcArray.count != 0{
            for item in vcArray {
                if item.isKind(of: HomeViewController.self) {
                    isFound = true
                    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                        navigationController.popToViewController(item, animated: true)
                        
                    }
                }
            }
        }
        if !isFound {
            if let scanVC = UIStoryboard.home.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController {
                if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                    navigationController.pushViewController(scanVC, animated: true)
                    
                }
            }
        }
    }
    
    func logOut(){
        // Pranav Bug Fix
        let alert = UIAlertController(title: "Logout", message: "Are you sure if you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            if let scanVC = UIStoryboard.authentification.instantiateViewController(withIdentifier: "LoginSDKViewController") as? LoginSDKViewController {
                LocalDataStore.signoutUser()
                let navController = UINavigationController(rootViewController: scanVC)
                UIApplication.shared.keyWindow?.rootViewController = navController
                
            }
        }))
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
            
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func movetoSafewayWallet(){
        let vc = SafewayWalletListRouter.createModule()
        if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
            navigationController.present(vc, animated: true, completion: nil)
        }
    }
    
    func moveToAccount() {
        var isFound = false
        if let vcArray = self.navigationController?.viewControllers , vcArray.count != 0{
            for item in vcArray {
                if item.isKind(of: AccountBasViewController.self) {
                    isFound = true
                    if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                        navigationController.popToViewController(item, animated: true)
                        
                    }
                }
            }
        }
        if !isFound {
            if let scanVC = UIStoryboard.account.instantiateViewController(withIdentifier: "AccountBasViewController") as? AccountBasViewController {
                if let navigationController = UIApplication.shared.keyWindow?.rootViewController as? UINavigationController {
                    navigationController.pushViewController(scanVC, animated: true)
                    
                }
            }
        }
        
        
    }
    
    
    
    
}

