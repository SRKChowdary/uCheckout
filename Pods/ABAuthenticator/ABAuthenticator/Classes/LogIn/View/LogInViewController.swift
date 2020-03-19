//
//  LogInViewController.swift
//  ABAuthenticator
//
//  Created by Michelle Louise Bosque on 8/15/19.
//

import Foundation
import SnapKit
import ABCoreUI
import ABCoreComponent

public class LogInViewController: BaseLoginViewController {
    var bannerImageView = UIImageView()
    var createAccountHeaderLabel = UILabel()
    var signInLabel = UILabel()
    var forgotPasswordLabel = UILabel()
    var createAccountLabel = UILabel()
    var emailTextField = ABField()
    var passwordTextField = ABPasswordField()
    var signInButton = UIButton()
    var separatorLine = UIView()
    var indicator = UIActivityIndicatorView(style: .gray)
    var activityView = UIView()
    var indicatorLabel = UILabel()
    var scrollView = UIScrollView()
    var contentView = UIView()
    var presenter: LogInPresenter?
    var config: LogInConfiguration?
    var delegate: LogInMainViewBehavior?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        createAccountLabel.isHidden = true
        forgotPasswordLabel.isHidden = true
        createAccountLabel.isEnabled = false
        forgotPasswordLabel.isEnabled = false
        
        build()
        setupKeyboardDismissRecognizer()
    }
    
    
    @objc func dismissmyKeyboard()
    {
        view.endEditing(true)
        
    }
    
    func setupKeyboardDismissRecognizer(){
        let tapRecognizer: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LogInViewController.dismissmyKeyboard))
        
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    
    override func customStyle() {
       self.title = config?.banner ?? ""
        scrollView.keyboardDismissMode = .interactive
        navigationController?.navigationBar.barTintColor = config?.scheme ?? LogInStyle.Color.defaultScheme
    }
    
    override func hidesBarButton() -> Bool {
        return true
    }

    
    func build() {
        buildNavigationStyle()
        buildHierarchy()
        buildConstraints()
        buildStyle()
        buildOktaModule()
    }
    
    func buildHierarchy() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(bannerImageView)
        contentView.addSubview(signInLabel)
        contentView.addSubview(emailTextField)
        contentView.addSubview(passwordTextField)
        contentView.addSubview(signInButton)
        contentView.addSubview(activityView)
        contentView.addSubview(forgotPasswordLabel)
        contentView.addSubview(createAccountLabel)
        contentView.addSubview(createAccountHeaderLabel)
        contentView.addSubview(separatorLine)
        activityView.addSubview(indicator)
        activityView.addSubview(indicatorLabel)
    }
    
    func buildConstraints() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        contentView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        bannerImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(40)
            make.centerX.equalToSuperview()
        }
        
        signInLabel.snp.makeConstraints { make in
            make.top.equalTo(bannerImageView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
        }
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(signInLabel.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        forgotPasswordLabel.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(forgotPasswordLabel.snp.bottom).offset(50)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(50)
        }
        
        activityView.snp.makeConstraints { make in
            make.edges.equalTo(signInButton.snp.edges)
            make.height.equalTo(50)
        }
        
        indicatorLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(20)
            make.centerY.equalToSuperview()
        }
        
        indicator.snp.makeConstraints { make in
            make.right.equalTo(indicatorLabel.snp.left).offset(-15)
            make.centerY.equalToSuperview()
        }
        
        separatorLine.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(2)
            make.centerX.equalToSuperview()
        }
        
        createAccountHeaderLabel.snp.makeConstraints { make in
            make.top.equalTo(separatorLine.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        createAccountLabel.snp.makeConstraints { make in
            make.top.equalTo(createAccountHeaderLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(-50)
        }
    }
    
    func buildStyle() {
        self.title = config?.banner ?? ""
        signInLabel.attributedText = NSMutableAttributedString(string: LogInConstants.Label.signIn, attributes: LogInStyle.Attribute.header)
        emailTextField.type = .email
        emailTextField.placeholder = LogInConstants.Label.email
        emailTextField.runValidation(.always)
        passwordTextField.placeholder = LogInConstants.Label.password
        signInButton.backgroundColor = config?.scheme ?? LogInStyle.Color.defaultScheme
        signInButton.setAttributedTitle(NSMutableAttributedString(string: LogInConstants.Label.signIn.uppercased(), attributes: LogInStyle.Attribute.button), for: .normal)
        signInButton.addTarget(self, action: #selector(signInTapped), for: .touchUpInside)
        forgotPasswordLabel.attributedText = NSMutableAttributedString(string: LogInConstants.Label.forgotPassword, attributes: getLinkAttributes())
        forgotPasswordLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LogInViewController.forgotPasswordTapped)))
        forgotPasswordLabel.isUserInteractionEnabled = true
        forgotPasswordLabel.textAlignment = .right
        createAccountLabel.attributedText = NSMutableAttributedString(string: LogInConstants.Label.createAccount, attributes: getLinkAttributes())
        createAccountLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(LogInViewController.createAccountTapped)))
        createAccountLabel.isUserInteractionEnabled = true
        indicatorLabel.attributedText = NSMutableAttributedString(string: LogInConstants.Label.signingIn, attributes: LogInStyle.Attribute.indicator)
        activityView.isHidden = true
        bannerImageView.contentMode = .scaleAspectFit
        bannerImageView.image = config?.bannerImage
        createAccountHeaderLabel.attributedText = NSMutableAttributedString(string: config?.createAccountHeaderTitle ?? LogInConstants.Label.onlineOrdering, attributes: LogInStyle.Attribute.subtext)
        separatorLine.backgroundColor = UIColor.gray
    }
    
    func buildOktaModule() {
        guard let safeClient = delegate?.oktaConfiguration() else {return}
        OktaClientLocalStore().save(safeClient)
    }
    
    func getLinkAttributes() -> [NSAttributedString.Key: Any] {
        var attributes = LogInStyle.Attribute.link
        attributes.merge([.foregroundColor: config?.scheme ?? LogInStyle.Color.defaultScheme], uniquingKeysWith: {(current, _) in current})
        return attributes
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.emailTextField.alpha = 1.0
            self.emailTextField.isUserInteractionEnabled = true
            self.passwordTextField.alpha = 1.0
            self.passwordTextField.isUserInteractionEnabled = true
            self.activityView.isHidden = true
            self.indicator.stopAnimating()
        }
    }
    
    @objc func forgotPasswordTapped(sender:UITapGestureRecognizer) {
        delegate?.forgotPasswordAction()
    }
    
    @objc func createAccountTapped(sender:UITapGestureRecognizer) {
        delegate?.createAccountAction()
    }
    
    @objc func signInTapped() {
        guard let user = emailTextField.text, let password = passwordTextField.text else {return}
        emailTextField.endEditing(true)
        passwordTextField.endEditing(true)
        
        let isEmailValid = emailTextField.validate()
        let isPasswordValid = passwordTextField.validate(shouldShowError: true)

        if isEmailValid && isPasswordValid {
            presenter?.signIn(user: user, password: password)
        }
    }
}

extension LogInViewController: LogInViewBehavior {
    func showLoading() {
        let originalSize = activityView.frame.size
        activityView.frame.size = CGSize(width: 0,height: 40)
        UIView.animate(withDuration: 0.5, animations: {
            self.emailTextField.alpha = 0.5
            self.emailTextField.isUserInteractionEnabled = false
            self.passwordTextField.alpha = 0.5
            self.passwordTextField.isUserInteractionEnabled = false
            self.activityView.layer.borderWidth = 0.5
            self.activityView.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            self.activityView.backgroundColor = UIColor.white
            self.activityView.isHidden = false
            self.activityView.frame.size = originalSize
            self.indicator.startAnimating()
        }, completion: { finished in
        })
    }
    
    func showDone() {
        DispatchQueue.main.async { [weak self] in
            self?.stopActivityIndicator()
            self?.delegate?.onSuccess()
        }
        
    }
    
    func showError(_ error: Error) {
        stopActivityIndicator()
        
        if let error = error as? AuthError {
            DispatchQueue.main.async { [weak self] in
                self?.passwordTextField.errorText = error.errorDescription
            }
        }
    }
    
    func saveUserCredential(user: UserCredential) {
        delegate?.saveUserKeychain(user: user)
    }
    
    func saveLogInToken(token: LogInToken) {
        delegate?.saveLogInTokenKeychain(token: token)
    }
}
