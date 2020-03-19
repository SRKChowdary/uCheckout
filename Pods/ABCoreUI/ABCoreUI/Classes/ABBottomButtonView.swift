//
//  ABBottomButtonView.swift
//  ECommerce
//
//  Created by Nasi Robinson on 4/4/19.
//  Copyright © 2019 Albertsons. All rights reserved.
//

import Foundation


public class ABBottomButtonView: UIView {
    
    public var buttonText:String {
        set {
            button.setTitle(newValue, for: .normal)
            button.accessibilityHint = "Double tap to \(newValue)"
        }
        get {
            return button.title(for: .normal) ?? "Button"
        }
    }
    var button = UIButton()
    var disabledButton = UIButton()
    let impact = UIImpactFeedbackGenerator()
    public var buttonAction: () -> Void = {}
    public var disabledButtonAction: () -> Void = {}
    public weak var delegate:ABButtonViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    public convenience init(buttonText: String) {
        self.init()
        self.buttonText = buttonText
        button.setTitle(buttonText, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    public var isEnabled: Bool {
        get {
            return button.isEnabled
        }
        set {
            button.isEnabled = newValue
            delegate?.abButton(isEnabled: newValue)
        }
    }
    
    func setUp(){
        buildHierarchy()
        buildStyle()
        buildConstraints()
    }
    
    func buildHierarchy() {
        self.addSubview(disabledButton)
        self.addSubview(button)
    }
    
    public override func didMoveToSuperview() {
        if superview != nil {
            snp.makeConstraints { make in
                make.right.equalToSuperview()
                make.left.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        }
    }
    
    public override func tintColorDidChange() {
        super.tintColorDidChange()
        changeTint()
    }
    
    func changeTint() {
        button.backgroundColor = tintColor
        button.setBackgroundColor(tintColor, for: .normal)
        button.setTitleColor(tintColor?.isLight() == true ? .black : .white, for: .normal)
    }
    
    func buildStyle() {
        
        backgroundColor = .white
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 3
        
        changeTint()
        button.setTitle(buttonText, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .black)
        button.setTitleColor(#colorLiteral(red: 0.2941176471, green: 0.2941176471, blue: 0.2941176471, alpha: 1), for: .disabled)
        button.setBackgroundColor(#colorLiteral(red: 0.8705882353, green: 0.8705882353, blue: 0.8705882353, alpha: 1), for: .disabled)
        button.isEnabled = false
        button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        button.accessibilityHint = "Double tap to \(buttonText)"
        button.layer.cornerRadius = 2
        button.clipsToBounds = true
        
        disabledButton.backgroundColor = .clear
        disabledButton.addTarget(self, action: #selector(disabledButtonPressed), for: .touchUpInside)
        disabledButton.isEnabled = false
        disabledButton.isAccessibilityElement = false
    }
    
    @objc func buttonPressed() {
        //impact.impactOccurred()
        buttonAction()
    }
    
    @objc func disabledButtonPressed() {
        impact.impactOccurred()
        disabledButtonAction()
    }
    
    func buildConstraints() {
        button.snp.makeConstraints() { make in
            make.height.equalTo(40)
            make.leftMargin.equalToSuperview().offset(16)
            make.rightMargin.equalToSuperview().offset(-16)
            make.bottomMargin.equalToSuperview().offset(-10)
            make.top.equalToSuperview().offset(10)
        }
        disabledButton.snp.makeConstraints() { make in
            make.edges.equalTo(button)
        }
    }
}

public protocol ABButtonViewDelegate: class {
    func abButton(isEnabled: Bool)
}

fileprivate extension UIButton {
    func setBackgroundColor(_ color: UIColor?, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext(), let color = color {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: state)
        }
        else {
            self.setBackgroundImage(nil, for: state)
        }
    }
}
