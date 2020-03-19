//
//  SwiftMessageBaseClass.swift
//  UCheckout
//
//  Created by i2i innovation on 17/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation
import SwiftMessages

protocol SwiftMessageBaseClassProtocol {
    func bannerButtonClicked()
}

class SwiftMessageBaseClass: NSObject {
     var swiftMessageBaseClassProtocol : SwiftMessageBaseClassProtocol?
    
     func showErrorMessage(title : String , body : String , isButtonVisible : Bool , buttonTitle : String , buttonImage : UIImage?){
        let errorView = MessageView.viewFromNib(layout: .messageView)
        errorView.configureTheme(.warning)
        errorView.configureDropShadow()
        errorView.backgroundColor = UIColor(hexString: "EC5C62")
        errorView.configureContent(title: title, body: body)
        errorView.button?.isHidden = !isButtonVisible
        errorView.buttonTapHandler = { _ in self.buttonClciked() }
        errorView.button?.setTitle(buttonTitle, for: .normal)
        errorView.button?.tintColor = UIColor.red
        if let buttonImage = buttonImage {
            errorView.button?.setBackgroundImage(buttonImage, for: .normal)

        }
        var successConfig = SwiftMessages.defaultConfig
        successConfig.presentationStyle = .top
        if isButtonVisible {
             // Pranav Bug Fix : as per UX Review
            
            successConfig.duration = .seconds(seconds: 3)
        }
        successConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: successConfig, view: errorView)
    }
    
   
    // function for success :
    func showSuccessMessage(title : String, body : String, isButtonVisible : Bool, buttonTitle : String, buttonImage : UIImage?) {
        let successView = MessageView.viewFromNib(layout: .messageView)
        successView.configureTheme(.success)
        successView.configureDropShadow()
        
        successView.backgroundColor = UIColor(hexString: "009648")
        successView.configureContent(title: title, body: body)
        successView.button?.isHidden = !isButtonVisible
        successView.buttonTapHandler = { _ in self.buttonClciked() }
        successView.button?.setTitle(buttonTitle, for: .normal)
        if let buttonImage = buttonImage
        {
            successView.button?.setBackgroundImage(buttonImage, for: .normal)
            
        }
        var successConfig = SwiftMessages.defaultConfig
        successConfig.presentationStyle = .top
        if isButtonVisible
        {
             // Pranav Bug Fix : as per UX Review
            
            successConfig.duration = .seconds(seconds: 3)
        }
        successConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: successConfig, view: successView)
        
    }
    // Pranav Bug Fix : need a message for Wifi on home VC View did load.
    func showInformation(title : String, body : String, isButtonVisible : Bool, buttonTitle : String, buttonImage : UIImage?) {
        let infoView = MessageView.viewFromNib(layout: .messageView)
        infoView.configureTheme(.info)
        infoView.configureDropShadow()
        
        infoView.backgroundColor = UIColor(hexString: "009648")
        infoView.configureContent(title: title, body: body)
        infoView.button?.isHidden = !isButtonVisible
        infoView.buttonTapHandler = { _ in self.buttonClciked() }
        infoView.button?.setTitle(buttonTitle, for: .normal)
        if let buttonImage = buttonImage
        {
            infoView.button?.setBackgroundImage(buttonImage, for: .normal)
            
        }
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationStyle = .top
        if isButtonVisible
        {
            // Pranav Bug Fix : as per UX Review
            
            infoConfig.duration = .seconds(seconds: 3)
        }
        infoConfig.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: infoConfig, view: infoView)
        
        
    }
    
    @objc func buttonClciked(){
        SwiftMessages.hide()
        swiftMessageBaseClassProtocol?.bannerButtonClicked()
    }
    
}

