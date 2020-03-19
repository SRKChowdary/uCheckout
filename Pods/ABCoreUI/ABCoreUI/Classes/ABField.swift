//
//  ABField.swift
//  ALBUIFramework
//
//  Created by Ganesh Reddiar on 4/18/16.
//  Copyright © 2016 Albertsons. All rights reserved.
//

import UIKit
import SnapKit

//MARK: ABFieldDelegate

/// ABFieldDelegate : Delegate for ABFields. Delegate method passed from ABField.TextField
/// - Note: All the delegate functions needs to pass the ABField as a view can have multiple fields
@objc public protocol ABFieldDelegate {
    @objc optional func abFieldDidStartEditing(_ abField:ABField)
    @objc optional func abFieldDidEndEditing(_ abField:ABField)
    @objc optional func abFieldValueDidChange(_ abField:ABField)
    /**
     Asks the delegate if the text field should process the pressing of the return button.
     
     The text field calls this method whenever the user taps the return button. You can use this method to implement any custom behavior when the button is tapped. For example, if you want to dismiss the keyboard when the user taps the return button, your implementation can call the resignFirstResponder() method.
     
     When this method is not implemented and the field has a side button, the action assoicated to the button is automatically exucuted
     */
    @objc optional func abFieldShouldReturn(_ abField:ABField) -> Bool
    @objc optional func abField(_ abField:ABField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    @objc optional func abField(_ abField:ABField, validationSuccess:Bool)
    /// Asks the delegate if the error text view should allow the specified type of user interaction with the given URL in the given range of text.
    @objc optional func abField(_ abField:ABField, errorShouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
}

/// Type of the field for configuration
public enum ABFieldType {
    case email
    case cvv
    case password
    @available(iOS 12.0, *)
    case newPassword
    case phone
    case number
    case zipCode
    case any
}

/**
# ABField
A custom text field with validation support, inline errors, and a title label above it
*/
@IBDesignable open class ABField: UIView {
    /// Defines when validation runs for an ABField
    ///
    /// This follows the OptionSet protocal, so this can be set to one value or multiple using `[]`. Depending on the type used, the class will either show an error message, or will fail without a visual cue
    public struct RoutineRate: OptionSet {
        public init(rawValue:UInt8) {
            self.rawValue = rawValue
        }
        public let rawValue: UInt8
        /// Does not run validation automatically.
        ///
        /// You must call `validate()` to manually run validation.
        public static let manually = RoutineRate(rawValue: 0x01)
        /// Runs each time the text changes in the field.
        ///
        /// Success or failure is not visually shown, but the delegate is still called
        public static let onTextChange = RoutineRate(rawValue: 0x02)
        /// Runs when the user leaves the field.
        ///
        /// In the case of validation failure, the error message is shown.
        public static let onEndEditing = RoutineRate(rawValue: 0x04)
        /// Runs when the user enters the field.
        ///
        /// Success or failure is not visually shown, but the delegate is still called
        public static let onBeginEditing = RoutineRate(rawValue: 0x08)
        /// Runs when the user presses Return on the keyboard.
        ///
        /// In the case of validation failure, the error message is shown.
        public static let onReturn = RoutineRate(rawValue: 0x16)
        /// Runs on text change, entering and exiting the field, and when pressing return.
        ///
        /// Success or failure is not visually shown, but the delegate is still called
        public static let always = RoutineRate(rawValue: 0x32)
    }
    
    /// State of the field
    public enum State {
        /// Field is in editing state.
        ///
        /// This is automatically switched to when the user enters the text field
        case active
        /// Field is not being edited.
        ///
        /// This is automatically switched to when the user leaves the text field
        case inactive
        /// Field is in error state.
        ///
        /// This is automatically switched to after validation fails and shows an error message
        case error
    }
    
    /// The validation routines for the ABField to run through
    public var routines:[ValidationRoutine]? //Routines
    /// How often validaiton routines run
    ///
    /// The default for this state is always, which checks on text change, and shows errors when leaving the field or pressing return
    public var routineRate:ABField.RoutineRate = .always
    /// Set how often validaiton routines run
    /// - Parameter rate: The rate at which validation runs
    public func runValidation(_ rate: ABField.RoutineRate) {
        routineRate = rate
    }
    /// Determines which validation routines are assigned and keyboard type to use
    public var type:ABFieldType = .any {
        didSet {
            self.setDefaultsForType(type)
        }
    }
    public internal(set) var validationSuccess:Bool?
    
    /// Current state of the ABField
    ///
    /// The default for this class is inactive
    public var state:ABField.State = .inactive {
        didSet {
            setupState()
        }
    }
    /// The max limit of characters for a textfield, after the limit is reached, text at the end of the field will be removed
    public var maxLength:Int?
    
    /// The visible title of the Return key.
    ///
    /// Setting this property to a different key type changes the visible title of the Return key and typically results in the keyboard being dismissed when it is pressed. The default value for this property is `UIReturnKeyType.next`.
    public var returnKeyType:UIReturnKeyType {
        get {
            return textField.returnKeyType
        }
        set {
            textField.returnKeyType = newValue
        }
    }
    
    /** Indicates the semantic meaning expected by a text-entry area.
 
    Use this property to give the keyboard and the system information about the expected semantic meaning for the content that users enter. For example, you might specify emailAddress for a text field that users fill in to receive an email confirmation. When you provide this information about the content you expect users to enter in a text-entry area, the system can in some cases automatically select an appropriate keyboard and improve keyboard corrections and proactive integration with other text-entry opportunities.
     
    Because the expected semantic meaning for each text-entry area should be identified as specifically as possible, you can’t combine multiple values for one textContentType property. For possible values you can use, see Text Content Types; by default, the value of this property is nil.
 */
    public var textContentType:UITextContentType! {
        get {
            return textField.textContentType
        }
        set {
            textField.textContentType = newValue
        }
    }
    
    /// The keyboard style associated with the text object.
    ///
    /// Text objects can be targeted for specific types of input, such as plain text, email, numeric entry, and so on. The keyboard style identifies what keys are available on the keyboard and which ones appear by default. The default value for this property is `UIKeyboardType.default`.
    public var keyboardType:UIKeyboardType {
        get {
            return textField.keyboardType
        }
        set {
            textField.keyboardType = newValue
        }
    }
    
    /// A succinct label that identifies the accessibility element of the text field, in a localized string.
    override open var accessibilityLabel:String? {
        get {
            return textField.accessibilityLabel
        }
        set {
            textField.accessibilityLabel = newValue
        }
    }
    
    /// A brief description of the result of performing an action on the accessibility element (text field), in a localized string.
    override open var accessibilityHint:String? {
        get {
            return textField.accessibilityHint
        }
        set {
            textField.accessibilityHint = newValue
        }
    }
    
    /// The receiver’s delegate.
    ///
    /// An ABField delegate responds to editing-related messages from the text field. You can use the delegate to respond to the text entered by the user and to some special commands, such as when Return is tapped.
    public weak var delegate:ABFieldDelegate?
    
    /// The height of the text field
    var fieldHeight: CGFloat {
        return 44.0
    }
    
    var activityIndicator:UIActivityIndicatorView?
    
    /// The string that is displayed above the text field
    ///
    /// When set, a label is created above the text field with value set. Setting a title also automatically adds a check mark to the side of the text field when validation suceeds. It can be removed by setting `showCheckmark` to false
    @IBInspectable public var title:String? = "" {
        didSet {
            showTopLabel()
        }
    }
    /**
     The text displayed by the text field.
 
     This string is @"" by default.
     
     Assigning a new value to this property also replaces the value of the attributedText property with the same text, albeit without any inherent style attributes. Instead the text view styles the new string using the font, textColor, and other style-related properties of the class.*/
    public var text: String? {
        get {
            return textField.text
        }
        set {
            textField.text = newValue
        }
    }
    
    /**
     The styled text displayed by the text field.
     
     This property is nil by default.
     
     Assigning a new value to this property also replaces the value of the text property with the same string data, albeit without any formatting information. In addition, assigning a new value updates the values in the font, textColor, and other style-related properties so that they reflect the style information starting at location 0 in the attributed string.*/
    public var attributedText: NSAttributedString? {
        get {
            return textField.attributedText
        }
        set {
            textField.attributedText = newValue
        }
    }
    
    /// The string that is displayed when there is no other text in the text field.
    ///
    /// This value is empty by default.
    @IBInspectable public var placeholder:String? = "" {
        didSet {
            setPlaceholder()
        }
    }
    
    /// The text displayed under the textfield in red. Used to show an error.
    ///
    /// Setting this values creates an error label below the textfield, and shows a red x to the side of the text field. Setting this value nil or empty removes the text and the red X
    public var errorText:String? {
        get {
            return errorLabel.text
        }
        set {
            errorLabel.text = newValue
            errorLabel.sizeToFit()
            state = newValue?.isEmpty == false ? .error : .inactive
        }
    }

    /// The styled text displayed under the textfield in red. Used to show an error.
    ///
    /// Setting this values creates an error label below the textfield, and shows a red x to the side of the text field. Setting this value nil or empty removes the text and the red X
    public var errorAttributedText:NSAttributedString? {
        get {
            return errorLabel.attributedText
        }
        set {
            errorLabel.attributedText = newValue
            errorLabel.sizeToFit()
            state = newValue?.length ?? 0 > 0 ? .error : .inactive
        }
    }
    
    //MARK: ABField Components
    var textField:UITextField! = UITextField()
    var errorLabel = UITextView()
    var borderView:UIView = UIView()
    var imageLabel = UILabel()
    var topLabel:UILabel?
    /// The button set inside and on the right side of the textfield.
    ///
    /// When calling `setupExtraButton()` this button is created. Afterwards you can customize the button via `backgroundColor` and other stylings.
    public var extraButton:UIButton?
    /// The button set outside and on the right of the textfield.
    ///
    /// When calling `addSideButton()` this button is created. Afterwards you can customize the button via `backgroundColor` and other stylings.
    public private(set) var sideButton:UIButton?
    /// This value represents if the sideButton is hidden by its width being zero
    ///
    /// This value is nil by default until the button is created. To hide and show the button call `removeSideButton()` and `addSideButton()` respectively
    public private(set) var sideButtonIsHidden:Bool?
    /// The closure for what action is taken when tapping the extra button.
    public var extraButtonAction:((UIButton)->())?
    /// The closure for what action is taken when tapping the side button.
    public var sideButtonAction:((UIButton)->())?
    /// Determines whether to show a green checkmark after validation succeeds
    ///
    /// This value is false by default, however is set true when a title is given to the ABField
    public var showCheckMark:Bool?
    
    //Constant Colors
    let darkGray = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1)
    let grey_656465 = #colorLiteral(red: 0.3960784314, green: 0.3921568627, blue: 0.3960784314, alpha: 1)
    let universal_B1B1B1 = #colorLiteral(red: 0.6941176471, green: 0.6941176471, blue: 0.6941176471, alpha: 1)
    
    
    //MARK: Init methods
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public convenience init(withTitle title: String, placeholder: String? = nil)
    {
        self.init()
        self.title = title
        showTopLabel()
        if let safePlaceholder = placeholder {
            self.placeholder = safePlaceholder
            setPlaceholder()
        }
    }
    
    // MARK: SetUp Methods
    
    /// Prepares the components and add the constraints.
    func setup() {
        buildHierarchy()
        buildStyle()
        buildConstraints()
        setupState()
        configureAccessibleElements()
        showTopLabel()
        configureTouchArea()
    }
    
    func buildStyle() {
        borderView.layer.borderWidth = 0.5
        borderView.layer.borderColor = darkGray.cgColor
        borderView.backgroundColor = grey_656465

        borderView.translatesAutoresizingMaskIntoConstraints = false
        borderView.isHidden = false
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.tintColor = darkGray
        textField.textColor = darkGray
        returnKeyType = .next
        textField.addTarget(self, action: #selector(ABField.textFieldValueDidChange(_:)), for: UIControl.Event.editingChanged)
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(8, 0, 0)
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        errorLabel.translatesAutoresizingMaskIntoConstraints = true
        errorLabel.isHidden = true
        errorLabel.textColor = #colorLiteral(red: 0.8666666667, green: 0.1176470588, blue: 0.1450980392, alpha: 1)
        errorLabel.font = UIFont.systemFont(ofSize: 14)
        errorLabel.isScrollEnabled = false
        errorLabel.isEditable = false
        errorLabel.dataDetectorTypes = [.phoneNumber, .link, .lookupSuggestion, .address]
        errorLabel.linkTextAttributes = [
            .underlineStyle: NSUnderlineStyle.single.rawValue,
            .foregroundColor: #colorLiteral(red: 0, green: 0.47843137254902, blue: 1, alpha: 1)
        ]
        errorLabel.delegate = self
        
        imageLabel.layer.cornerRadius = 10.0
        imageLabel.layer.masksToBounds = true
        imageLabel.lineBreakMode = .byWordWrapping
        imageLabel.numberOfLines = 0
        imageLabel.textColor = UIColor.white
        imageLabel.textAlignment = .center
        imageLabel.sizeToFit()
        hideImageLabel(true)
    }
    
    func setErrorImage() {
        imageLabel.font = UIFont.systemFont(ofSize: 16)
        imageLabel.backgroundColor = #colorLiteral(red: 0.8666666667, green: 0.1176470588, blue: 0.1450980392, alpha: 1)
        imageLabel.text = "✕"
        let gesture = UITapGestureRecognizer(target: self, action: #selector(clearText))
        imageLabel.addGestureRecognizer(gesture)
        imageLabel.accessibilityLabel = "Validation failed."
        imageLabel.accessibilityHint = "Double tap to clear text field"
        imageLabel.accessibilityTraits = .button
        imageLabel.isUserInteractionEnabled = true
        hideImageLabel(false)
    }
    
    @objc func clearText() {
        text = ""
        errorText = nil
    }
    
    public func setSuccessImage() {
        imageLabel.font = UIFont.boldSystemFont(ofSize: 16)
        imageLabel.backgroundColor = #colorLiteral(red: 0.07843137255, green: 0.5294117647, blue: 0.2392156863, alpha: 1)
        imageLabel.text = "✓"
        imageLabel.gestureRecognizers?.removeAll()
        imageLabel.accessibilityLabel = "Validation succeeded."
        imageLabel.accessibilityHint = nil
        imageLabel.accessibilityTraits = .none
        imageLabel.isUserInteractionEnabled = false
        hideImageLabel(false)
    }
    
    func setPlaceholder() {
        self.textField.attributedPlaceholder = NSMutableAttributedString(string: placeholder ?? "", attributes: [.foregroundColor:universal_B1B1B1])
    }
    
    func hideImageLabel(_ hide:Bool) {
        imageLabel.isHidden = hide
        imageLabel.snp.updateConstraints { (make) in
            make.width.equalTo(hide ? 0 : 20)
        }
    }
    func buildHierarchy() {
        addSubview(borderView)
        borderView.addSubview(textField)
        addSubview(imageLabel)
    }
    
    func showErrorLabel() {
        addSubview(errorLabel)
        setErrorImage()
        layoutErrorLabelConstraints()
    }
    
    func hideErrorLabel() {
        errorLabel.removeFromSuperview()
        if imageLabel.text == "✕" {
            hideImageLabel(true)
        }
    }
    
    func buildConstraints() {
        layoutBorderConstraints()
        layoutTextFieldConstraints()
        layoutImageLabelConstraints()
    }
    
    func configureTouchArea() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(becomeFirstResponder)))
        isUserInteractionEnabled = true
    }
    
    
    
    func configureAccessibleElements() {
        self.textField.isAccessibilityElement = true
        self.imageLabel.isAccessibilityElement = true
    }
    
    /// Set configuration for the type like keyboard type and validation routines
    internal func setDefaultsForType(_ type:ABFieldType) {
        
        switch type {
        case .email:
            keyboardType = .emailAddress
            accessibilityLabel = "Email"
            if #available(iOS 11.0, *) {
                textContentType = .username
            }
            setRoutinesIfEmpty(EmailValidator.isValidEmail)
                
        case .password, .newPassword:
            textField.autocorrectionType = .no
            textField.autocapitalizationType = .none
            if #available(iOS 11.0, *) {
                if #available(iOS 12.0, *), type == .newPassword {
                    textContentType = .newPassword
                } else {
                    textContentType = .password
                }
            }
            accessibilityLabel = "Password"
            
        case .phone:
            keyboardType = .numberPad
            textContentType = .telephoneNumber
            accessibilityLabel = "Phone Number"
            setRoutinesIfEmpty(PhoneNumberValidator.isValidPhoneNumber)
            
        case .number:
            keyboardType = .numberPad
        
        case .cvv:
            keyboardType = .numberPad
            setRoutinesIfEmpty(CvvValidator.isValidLength)
            
        case .zipCode:
            keyboardType = .numberPad
            textContentType = .postalCode
            accessibilityLabel = "Zip Code"
            setRoutinesIfEmpty(ZipCodeValidator.isValidLength)
            
        default:
            break
        }
    }
    
    internal final func setRoutinesIfEmpty(_ routines: ValidationRoutine...) {
        if self.routines == nil {
            self.routines = routines
        }
    }
    
    func setupState() {
        hideErrorLabel()
        layoutBorderConstraints()
        switch (state) {
        case .active :
            borderView.backgroundColor = .white
            borderView.layer.borderColor = UIColor.gray.cgColor
        case .inactive :
            borderView.backgroundColor = .white
            borderView.layer.borderColor = UIColor.gray.cgColor
            if text?.count == 0 {
                errorLabel.isAccessibilityElement = false
                errorLabel.isHidden = true
                hideImageLabel(true)
            }
        case .error :
            borderView.layer.borderColor = errorLabel.textColor?.cgColor
            
            showErrorLabel()
            errorLabel.isAccessibilityElement = true
            errorLabel.isHidden = false
            hideImageLabel(false)
        }
        layoutIfNeeded()
    }
    
    internal func layoutImageLabelConstraints() {
        imageLabel.snp.remakeConstraints { make in
            make.left.equalTo(textField.snp.right).offset(-8)
            make.right.equalTo(extraButton?.snp.left ?? borderView.snp.right).offset(-8)
            make.width.equalTo(imageLabel.isHidden ? 0 : 20)
            make.height.equalTo(20)
            make.centerY.equalTo(borderView)
        }
    }
    
    //MARK: Constraints Methods
    /// Layout textfield Constraints
    internal func layoutTextFieldConstraints() {
        textField.snp.remakeConstraints { make in
            make.left.equalTo(borderView)
            make.right.equalTo(imageLabel.snp.left).offset(-8)
            make.top.equalTo(borderView)
            make.bottom.equalTo(borderView)
        }
    }
    
    /// Layout Label Constraints
    internal func layoutErrorLabelConstraints() {
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutBorderConstraints()
        errorLabel.snp.remakeConstraints { make in
            make.top.equalTo(borderView.snp.bottom)//.offset(errorLabel.text?.isEmpty ?? true ? 0 : 5)
            make.left.equalTo(textField).offset(5)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        errorLabel.layoutIfNeeded()
    }
    
    /// Layout Border Constraints
    internal func layoutBorderConstraints()  {
        borderView.snp.remakeConstraints { make in
            if topLabel == nil { make.top.equalToSuperview() }
            make.left.equalToSuperview()
            make.right.equalTo(sideButton?.snp.left ?? snp.right)
            make.height.equalTo(fieldHeight)
            if errorLabel.superview == nil { make.bottom.equalToSuperview() }
        }
    }
    
    /// Adds title label and enables check mark
    private func showTopLabel() {
        guard title?.isEmpty == false else { return }
        if showCheckMark == nil {
            showCheckMark = true
        }
        if topLabel == nil {
            topLabel = UILabel()
            topLabel?.textColor = grey_656465
            topLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            addSubview(topLabel!)
            topLabel?.snp.remakeConstraints { make in
                make.top.equalToSuperview()
                make.left.equalToSuperview().offset(5)
                make.right.equalToSuperview()
                make.bottom.equalTo(borderView.snp.top).offset(-10)
            }
            layoutBorderConstraints()
        }
        topLabel?.text = title
    }
    
    /**
     Creates a button inside the text field and on the right
     - Parameter button: The button to be set inside the text field. The button will be set with a height of 22
     */
    public func setupExtraButton(_ button:UIButton) {
        extraButton = button
        addSubview(extraButton!)
        extraButton?.snp.makeConstraints({ (make) in
            make.right.equalTo(borderView).offset(-10)
            make.centerY.equalTo(borderView)
            make.height.equalTo(22)
            make.width.greaterThanOrEqualTo(22)
        })
        layoutTextFieldConstraints()
        layoutImageLabelConstraints()
        extraButton?.setContentHuggingPriority(UILayoutPriority(rawValue: 500), for: .horizontal)
        extraButton?.addTarget(self, action: #selector(extraButtonTapped), for: .touchUpInside)
    }
    
    /// Removes the button set inside the text field
    ///
    /// If no button was made before calling this fucntion, this does nothing
    public func removeExtraButton() {
        guard extraButton != nil else { return }
        extraButton?.removeFromSuperview()
        extraButton = nil
        layoutTextFieldConstraints()
        layoutImageLabelConstraints()
    }
    
    /**
     Adds button to the side of the text field
     
     This button has a gray background with an arrow pointing right
     - Parameter animated: animates the button back into place. This is unused when first adding the button
     Calling this method again will reset the width of the button if it was hidden with `removeSideButton()`.
     */
    public func addSideButton(animated:Bool = true) {
        sideButtonIsHidden = false
        guard sideButton == nil else {
            if animated {
                UIView.animate(withDuration: 0.25) {
                    self.sideButton?.snp.updateConstraints() { make in
                        make.width.equalTo(44)
                    }
                    self.layoutIfNeeded()
                }
            }
            else {
                sideButton?.snp.updateConstraints() { make in
                    make.width.equalTo(44)
                }
            }
            return
        }
        sideButton = UIButton()
        addSubview(sideButton!)
        sideButton?.snp.makeConstraints({ (make) in
            make.right.equalToSuperview()
            make.centerY.equalTo(borderView)
            make.height.equalTo(borderView)
            make.width.equalTo(44)
        })
        sideButton?.backgroundColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1)
        let image = UIImage(named: "whiteRightArrow", in: resourceBundle(), compatibleWith: nil)
        sideButton?.setImage(image, for: .normal)
        layoutBorderConstraints()
        sideButton?.addTarget(self, action: #selector(sideButtonTapped), for: .touchUpInside)
        sideButton?.isEnabled = false
    }
    
    /// Hides the side button by setting the width to 0
    public func hideSideButton(animated:Bool = true) {
        guard sideButton != nil else { return }
        if animated {
            UIView.animate(withDuration: 0.25) {
                self.sideButton?.snp.updateConstraints() { make in
                    make.width.equalTo(0)
                }
                self.layoutIfNeeded()
            }
        }
        else {
            sideButton?.snp.updateConstraints() { make in
                make.width.equalTo(0)
            }
        }
        sideButtonIsHidden = true
        layoutBorderConstraints()
    }
    
    @objc private func extraButtonTapped(_ sender:UIButton) {
        extraButtonAction?(sender)
    }
    
    @objc private func sideButtonTapped(_ sender:UIButton) {
        sideButtonAction?(sender)
    }
    
    /// Show a loading indicator on the right side of the text field
    /// - Parameter hideSideButton: hide the side button as well if it exists
    /// This method also hides the extra right button and validation indicator if they were showing before
    public func displayIndicator(hideSideButton:Bool = true) {
        guard activityIndicator == nil else { return }
        extraButton?.isHidden = true
        hideImageLabel(true)
        activityIndicator = UIActivityIndicatorView(style: .gray)
        addSubview(activityIndicator!)
        activityIndicator?.snp.makeConstraints({ (make) in
            make.right.equalTo(extraButton ?? imageLabel)
            make.centerY.equalTo(borderView)
        })
        activityIndicator?.startAnimating()
        if hideSideButton && sideButtonIsHidden == false {
            self.hideSideButton()
        }
        isUserInteractionEnabled = false
    }
    
    /// Hides the loading spinner
    /// - Parameter showSideButton: show the side button as well if it exists
    /// This method also shows the extra right button if it exists
    public func hideIndicator(showSideButton:Bool = true) {
        guard activityIndicator != nil else { return }
        activityIndicator?.stopAnimating()
        activityIndicator?.removeFromSuperview()
        activityIndicator = nil
        if showSideButton && sideButtonIsHidden == true {
            self.addSideButton()
        }
        isUserInteractionEnabled = true
        extraButton?.isHidden = false
    }
    
    //MARK: Functions to execture Validations
    
    /// Runs the validation routines assigned to the field
    /// - Parameter shouldShowError: After running, this value decides to show the error message on failure, or a checkmark on success (if enabled)
    /// - Returns: The success or failure of the result
    ///
    /// After running the validation, this calls its delegate to alert it of the field's sucess or failure
    @discardableResult public func validate(shouldShowError showError:Bool = true) -> Bool {
        var isSuccess = true
        if let routines = routines, routines.count > 0 {
            for routine in routines {
                if !self.executeValidationBlock(routine:routine, showError:showError) {
                    isSuccess = false
                    break
                }
            }
        }
        validationSuccess = isSuccess
        delegate?.abField?(self, validationSuccess: isSuccess)
        return isSuccess
    }
    
    /// Run a certain validation routine
    internal final func executeValidationBlock(routine:ValidationRoutine, showError:Bool) -> Bool {
        let result = routine(self.text ?? "")
        hideImageLabel(true)
        if showError && !result.isSuccess {
            errorText = result.text
        }
        
        if result.isSuccess {
            state = .inactive
            if showError && showCheckMark == true {
                setSuccessImage()
            }
        }
        return result.isSuccess        
    }
    
    open override func tintColorDidChange() {
        super.tintColorDidChange()
        changeTint()
    }
    
    internal func changeTint() {
        textField.inputAccessoryView?.tintColor = tintColor
    }
    
    public func addDoneOnTopOfKeyboard() {
        textField.addDoneToolBar()
    }
    
    public func removeToolbarFromKeyboard() {
        textField.inputAccessoryView = nil
    }
    
    @discardableResult override open func becomeFirstResponder() -> Bool {
        return textField.becomeFirstResponder()
    }
    
    @discardableResult override open func resignFirstResponder() -> Bool {
        return textField.resignFirstResponder()
    }
    
    override open var isFirstResponder: Bool {
        return textField.isFirstResponder
    }
    
    //MARK: Utility Functions
    
    public func setCursorAtPosition(_ location:Int) {
        
        let beginPosition = self.textField.beginningOfDocument
        let textPosition = self.textField.position(from: beginPosition, offset: location)
        
        if let textPosition = textPosition {
            let newTextRange = self.textField.textRange(from: textPosition, to: textPosition)
            self.textField.selectedTextRange = newTextRange
        }
        
    }
    
    public func selectAll() {
        textField.selectedTextRange = textField.textRange(from: textField.beginningOfDocument, to: textField.endOfDocument)
    }
    
    // MARK: ABFieldDelate Methods
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if let val = self.delegate?.abField?(self, shouldChangeCharactersIn: range, replacementString: string) {
            return val
        }
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        
        text = text?.trimmingCharacters(in: .whitespaces)
        state = .inactive
        if routineRate.contains(.onEndEditing) || routineRate.contains(.always) {
            validate()
        }
        self.delegate?.abFieldDidEndEditing?(self)
        if self.state == .error {
            UIAccessibility.post(notification: UIAccessibility.Notification.announcement, argument: errorLabel.text)
        }
    }
    
    internal final func resourceBundle() -> Bundle? {
        let frameworkBundle = Bundle(for: ABField.self)
        if let bundleURL = frameworkBundle.resourceURL?.appendingPathComponent("ABUIKit.bundle") {
            return Bundle(url: bundleURL)
        }
        return nil
    }
}

extension ABField: UITextFieldDelegate {
    @objc public func textFieldValueDidChange(_ textField: UITextField) {
        
        if var newText = textField.text, let limit = self.maxLength {
            if newText.count > limit {
                newText = String(newText[..<newText.index(newText.startIndex, offsetBy: limit)])
                textField.text = newText
            }
        }
        if routineRate.contains(.onTextChange) || routineRate.contains(.always) {
            validate(shouldShowError: false)
        }
        self.delegate?.abFieldValueDidChange?(self)
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if routineRate.contains(.onReturn) || routineRate.contains(.always) {
            validate()
        }
        if let shouldReturn = delegate?.abFieldShouldReturn?(self) {
            return shouldReturn
        }
        // If the delegate does not handle the return and there's a button to the side, tap it automatically
        if let sideAction = sideButtonAction, let sideButton = sideButton {
            sideAction(sideButton)
        }
        self.resignFirstResponder()
        return true
    }
    
    /**
     By default ABField is the delegate for the UITextField in the component.
     If you want to change it use changeTextFieldDelegate to modify it .
     **/
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if self.state == .inactive {
            state = .active
        }
        if routineRate.contains(.onBeginEditing) || routineRate.contains(.always) {
            validate(shouldShowError: false)
        }
        self.delegate?.abFieldDidStartEditing?(self)
    }
}

extension ABField:UITextViewDelegate {
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        return delegate?.abField?(self, errorShouldInteractWith: URL, in: characterRange, interaction: interaction) ?? true
    }
}
