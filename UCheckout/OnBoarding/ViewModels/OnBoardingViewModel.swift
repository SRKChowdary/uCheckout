//
//  OnBoardingViewModel.swift
//  UCheckout
//
//  Created by i2i innovations on 21/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation

class OnBoardingViewModel {
    
    public func getOnBoardingBaseData() -> [OnBoardingModel]{
        if let plistDict = Bundle.parsePlist(ofName: "OnBoarding") {
            var onBoardingModelArray = [OnBoardingModel]()
            if let onBoardingDataArray = plistDict["onBoardingData"] as? [[String: Any]] {
                for item in onBoardingDataArray {
                    onBoardingModelArray.append(OnBoardingModel(item))
                }
            }
            
            return onBoardingModelArray
        }
        else {
            return [OnBoardingModel]()
        }
    }
}
