//
//  DataCaptureContextExtension.swift
//  UCheckout
//
//  Created by i2i innovation on 12/07/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation
import ScanditBarcodeCapture

extension DataCaptureContext {
    private static let licenseKey = "AQHdxyOMAy7OFL6nFgx1JBIu8gaAHVVKrTMHMx1j+8l4YoYoI04nPAE9fuhAQu2kpEu/3sJxoqTrY66ucUw//As5z7nIVA/8Xh1xgItC+mW0YfNEI2A+hTlrMCfJXYrOgj0PhWFIEUduL2MSQSBek8Z01hiTJkhMmyDLZsgbOL07HLuN1FtK1LSvz4HaYYYDrhwsHX++ou9j0m6dUYyrHHx9s0AGoMCYcskVVMQDzu698j5auYB654ulKfxIkY9F2dVRphVwVqUcMPDsaV0thOWVzfeunAQyj8HCjIiFah9BCp7AfejYBOMLdAXQstWF87Uljsi+BBA0eom/A5zi7iphXZdyOFtRgZsBhuM5vpKlzwI8UcZY9c7gEEsDCuQolS6FVrcmkzTAfv/EB1q9ZAd3NX6YtpPzEWcBMOEkSRmLX48QMPXVhRAjXquu+bdENmz3WFTvdIDvp7dUAq2ylr6+F9C/un0LF0GGoEPFiygxb3mG6u4kiXCh/qRbdi4ESFwFEz34EJU32FVHxxfe/nweLHobskNY4GXHBcLGxMF6Ooj3UFKeOixM9xvMG2owg1GDdtjiCEtanVEW8lklooAtzelNJj6RD+Uajk+iwyMeRmemld4hC9ZzDOYX1hS0aSOIriO9W32/t21aKOOCFangnDTxLY+MmOKORd8zcv1XobYt5f7+0/2Wg0vDaX/6BfUvZWjufjTr/qNkv2TWZYOTrtZQdGkR3swEjfyXoLQB7ySH+Z2UIs7L5F3tpHWp/72cf9S+tkBsycoFBn5KrnZ9Gkbk1SjJLFOQde6nd7e0YEN/zXqYyKk7pUS7qfk8r1p1n/AG/GGYqTXuE1puj6YjflU="
    

    // Get a licensed DataCaptureContext.
    static var licensed: DataCaptureContext {
        let sharedInstance = UcheckoutSingleton.shared
        if let scanditLicenseKey = sharedInstance.getprofileModelData?.appSettings?.scanditLicenseKey {
             return DataCaptureContext(licenseKey: scanditLicenseKey)
        }
        return DataCaptureContext(licenseKey: licenseKey)
    }
}



