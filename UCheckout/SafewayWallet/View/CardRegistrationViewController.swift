//
//  CardRegistrationViewController.swift
//  UCheckout
//
//  Created by 1521398 on 26/08/19.
//  Copyright © 2019 Nikhil Tanappagol. All rights reserved.
//

import UIKit

class CardRegistrationViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var addCardContainerView: UIView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var cardNumberField: UITextField!
    @IBOutlet weak var expirationDateField: UITextField!
    @IBOutlet weak var cvvNumberField: UITextField!
    @IBOutlet weak var zipCodeField: UITextField!
    @IBOutlet weak var addCardButton: UIButton!
    @IBOutlet weak var nameErrorView: UIView!
    @IBOutlet weak var nameErrorLabel: UILabel!
    @IBOutlet weak var numberErrorView: UIView!
    @IBOutlet weak var numberErrorLabel: UILabel!
    @IBOutlet weak var expirationErrorView: UIView!
    @IBOutlet weak var expirationErrorLabel: UILabel!
    @IBOutlet weak var cvvErrorView: UIView!
    @IBOutlet weak var cvvErrorLabel: UILabel!
    @IBOutlet weak var zipCodeErrorView: UIView!
    @IBOutlet weak var zipCodeErrorLabel: UILabel!
    
    
    @IBOutlet weak var menuButtonOutlet: UIBarButtonItem!
    
    
    // MARK :-
    // Button Actions :
    
    
    @IBAction func menuButtonAction(_ sender: Any)
    {
       
            guard let menuViewController = UIStoryboard.home.instantiateViewController(withIdentifier: "MenuTableViewController") as? MenuTableViewController else { return }
            
//            menuViewController.modalPresentationStyle = .overCurrentContext
//        menuViewController.transitioningDelegate = self as! UIViewControllerTransitioningDelegate
        menuViewController.menuTableControllerProtocol = self as? MenuTableControllerProtocol
            present(menuViewController, animated: true)
        
        
    }
    
    @IBAction func backButtonAction(_ sender: UIBarButtonItem)
    {
        presenter?.goBack()
    }
    
    
    
  
    
    
    var keyboardAvoider: ScrollingKeyboardAvoidable!
    var cardTypeImageView = UIImageView()
    var cardType: SafewayCardType = .blankCard
    var creditCardValidator: CreditCardValidator = CreditCardValidator()
    
    
    var presenter: CardRegistrationViewToPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menuButtonOutlet.isEnabled = false
        menuButtonOutlet.tintColor = UIColor.clear
        keyboardAvoider = PaddedKeyboardAvoider(scrollView: scrollView)
        
        hideKeyboardWhenTappedAround()
        configureUI()
        addDoneButtonOnKeyboard()
        expirationDateField.keyboardType = .numberPad
        
    
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonDidTapped(_ sender: Any) {
        presenter?.goBack()
    }
    
    @IBAction func addCardButtonDidTapped(_ sender: Any) {
        presenter?.addNewCard()
    }
    
    private func configureUI() {
        createNumberFieldRightView()
        configureTextFields()
        updateAddCardEnableState()
        hideErrorViews()
    }
    
    private func hideErrorViews() {
        nameErrorView.isHidden = true
        numberErrorView.isHidden = true
        cvvErrorView.isHidden = true
        expirationErrorView.isHidden = true
        zipCodeErrorView.isHidden = true
    }
    
    private func configureTextFields() {
        //Set corner Radius
        self.nameField.layer.cornerRadius = SafewayWalletConstants.CardRegistration.cornerRadius
        self.cardNumberField.layer.cornerRadius = SafewayWalletConstants.CardRegistration.cornerRadius
        self.expirationDateField.layer.cornerRadius = SafewayWalletConstants.CardRegistration.cornerRadius
        self.cvvNumberField.layer.cornerRadius = SafewayWalletConstants.CardRegistration.cornerRadius
        self.zipCodeField.layer.cornerRadius = SafewayWalletConstants.CardRegistration.cornerRadius
        
        //Set border width
        self.nameField.layer.borderWidth = SafewayWalletConstants.CardRegistration.borderWidth
        self.cardNumberField.layer.borderWidth = SafewayWalletConstants.CardRegistration.borderWidth
        self.expirationDateField.layer.borderWidth = SafewayWalletConstants.CardRegistration.borderWidth
        self.cvvNumberField.layer.borderWidth = SafewayWalletConstants.CardRegistration.borderWidth
        self.zipCodeField.layer.borderWidth = SafewayWalletConstants.CardRegistration.borderWidth
        
        //Set border color
        self.nameField.layer.borderColor = SafewayWalletConstants.CardRegistration.lightGrayColor.cgColor
        self.cardNumberField.layer.borderColor = SafewayWalletConstants.CardRegistration.lightGrayColor.cgColor
        self.expirationDateField.layer.borderColor = SafewayWalletConstants.CardRegistration.lightGrayColor.cgColor
        self.cvvNumberField.layer.borderColor = SafewayWalletConstants.CardRegistration.lightGrayColor.cgColor
        self.zipCodeField.layer.borderColor = SafewayWalletConstants.CardRegistration.lightGrayColor.cgColor
    }
    
    private func createNumberFieldRightView() {
        cardNumberField.rightViewMode = .always
        cardTypeImageView.frame =
        CGRect(x: 0, y: 3, width: 62, height: 32)
        cardTypeImageView.contentMode = .scaleAspectFit
        cardTypeImageView.image = UIImage(named:"blankCard.png")
        cardNumberField.rightView = cardTypeImageView
    }
    
    func updateAddCardEnableState() {
        let nameResult = creditCardValidator.validCardName(name: nameField.text)
        let numberResult = creditCardValidator.validCardNumber(number: cardNumberField.text, cardType: self.cardType)
        let cvvResult = creditCardValidator.validCVVNumber(cvv: cvvNumberField.text, cardType: self.cardType)
        let expDateResult = creditCardValidator.validExpireDate(date: expirationDateField.text)
        let zipcodeResult = creditCardValidator.validZipCode(zipCode: zipCodeField.text)
        if nameResult.isValid && numberResult.isValid && cvvResult.isValid && expDateResult.isValid && zipcodeResult.isValid {
            isEnableAddCard(enable: true)
        }
        else {
            isEnableAddCard(enable: false)
        }
    }
    
    public enum UIKeyboardType : Int {
        
        
        case `default` // Default type for the current input method.
        
        case asciiCapable // Displays a keyboard which can enter ASCII characters
        
        case numbersAndPunctuation // Numbers and assorted punctuation.
        
        case URL // A type optimized for URL entry (shows . / .com prominently).
        
        case numberPad // A number pad with locale-appropriate digits (0-9, ۰-۹, ०-९, etc.). Suitable for PIN entry.
        
        case phonePad // A phone pad (1-9, *, 0, #, with letters under the numbers).
        
        case namePhonePad // A type optimized for entering a person's name or phone number.
        
        case emailAddress // A type optimized for multiple email address entry (shows space @ . prominently).
        
        @available(iOS 4.1, *)
        case decimalPad // A number pad with a decimal point.
        
        @available(iOS 5.0, *)
        case twitter // A type optimized for twitter text entry (easy access to @ #)
        
        @available(iOS 7.0, *)
        case webSearch // A default keyboard type with URL-oriented addition (shows space . prominently).
        
        @available(iOS 10.0, *)
        case asciiCapableNumberPad // A number pad (0-9) that will always be ASCII digits.
    
    }
    
    private func handleError(activeField: UITextField) {
        if activeField == nameField {
            let message = creditCardValidator.validCardName(name: nameField.text).message
            nameErrorLabel.text = message
            nameErrorView.isHidden = message.isEmpty
        } else if activeField == cardNumberField {
            let message = creditCardValidator.validCardNumber(number: cardNumberField.text, cardType: self.cardType).message
            numberErrorLabel.text = message
            numberErrorView.isHidden = message.isEmpty
            
        } else if activeField == expirationDateField {
            let message = creditCardValidator.validExpireDate(date: expirationDateField.text).message
            expirationErrorLabel.text = message
            expirationErrorView.isHidden = message.isEmpty
            
        } else if activeField == cvvNumberField {
            let message = creditCardValidator.validCVVNumber(cvv: cvvNumberField.text, cardType: self.cardType).message
            cvvErrorLabel.text = message
            cvvErrorView.isHidden = message.isEmpty
        } else if activeField == zipCodeField {
            let message = creditCardValidator.validZipCode(zipCode: zipCodeField.text).message
            zipCodeErrorLabel.text = message
            zipCodeErrorView.isHidden = message.isEmpty
        }
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

extension CardRegistrationViewController: CardRegistrationPresenterToViewProtocol {
    
    func cardDetails() -> CardDetails {
        let name = (nameField.text ?? "").trim()
        let number = (cardNumberField.text ?? "").trim().replacingOccurrences(of: " ", with: "")
        let cvv = (cvvNumberField.text ?? "").trim()
        let expirationDate = (expirationDateField.text ?? "").trim()
        let zipCode = (zipCodeField.text ?? "").trim()
        return CardDetails(name: name, cardNumber: number, cvvNumber: cvv, expirationDate: expirationDate, zipCode: zipCode, cardType: self.cardType)
    }
    
    func cardRegistrationFailed(error: ErrorInfo) {
        //Disable add button
        isEnableAddCard(enable: false)
        let alert = UIAlertController(title: error.title, message: error.description, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: UITextFieldDelegate
extension CardRegistrationViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newLength = (textField.text ?? "").count + string.count - range.length
        if textField == cardNumberField {
            return newLength <= SafewayWalletConstants.CardRegistration.otherCardNumberLength
        } else if textField == cvvNumberField {
            return newLength <= SafewayWalletConstants.CardRegistration.amexCVVLength
        } else if textField == expirationDateField {
            return newLength <= SafewayWalletConstants.CardRegistration.expirationDateLength
        } else if textField == zipCodeField {
            return newLength <= SafewayWalletConstants.CardRegistration.zipCodeLength
        }
        return true
    }
    
    func addDoneButtonOnKeyboard()
    {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        zipCodeField.inputAccessoryView = doneToolbar
        expirationDateField.inputAccessoryView = doneToolbar
        cvvNumberField.inputAccessoryView = doneToolbar
        cardNumberField.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction(){
        zipCodeField.resignFirstResponder()
        expirationDateField.resignFirstResponder()
        cvvNumberField.resignFirstResponder()
        cardNumberField.resignFirstResponder()
    }
    
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        if sender != nameField {
            sender.text = ValueFormatter.formatNumber(text: sender.text ?? "")
        }
        //Set card Image
        if sender == cardNumberField {
            cardNumberField.text = ValueFormatter.formatCreditCard(cardNumber: cardNumberField.text?.trim() ?? "")
            //Set card type and image
            setCardTypeImage(number: cardNumberField.text)
        } else if sender == expirationDateField {
           expirationDateField.text = ValueFormatter.formatExpirationDate(date: expirationDateField.text?.trim() ?? "")
        }
        updateAddCardEnableState()
        handleError(activeField: sender)
    }
    
    public override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        // To disable the context menu
        if let textField = sender as? UITextField, textField == cvvNumberField || textField == cardNumberField || textField == zipCodeField || textField == expirationDateField {
            OperationQueue.main.addOperation {
                UIMenuController.shared.setMenuVisible(false, animated: false)
            }
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    func setCardTypeImage(number: String?) {
        if let number = number {
            if number.isEmpty || number == "" {
                cardTypeImageView.image = UIImage(named:"blankCard.png")
            } else {
                let cardInfo = creditCardValidator.cardTypeAndImageForCardNumber(number: number)
                if let cardType = cardInfo.cardType {
                    self.cardType = cardType
                }
                if let cardImage = cardInfo.cardImage {
                    cardTypeImageView.image = cardImage
                }
            }
        }
    }
    
}
