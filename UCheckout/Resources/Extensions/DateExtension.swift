//
//  DateExtension.swift
//  UCheckout
//
//  Created by i2i innovations on 21/09/19.
//  Copyright © 2019 Pranav. All rights reserved.
//

import Foundation


extension Date {
    
    func totalDistance(from date: Date, resultIn component: Calendar.Component) -> Int? {
        return Calendar.current.dateComponents([component], from: self, to: date).value(for: component)
    }
    
    func compare(with date: Date, only component: Calendar.Component) -> Int {
        let days1 = Calendar.current.component(component, from: self)
        let days2 = Calendar.current.component(component, from: date)
        return days1 - days2
    }
    
    func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
        return self.compare(with: date, only: component) == 0
    }
   
    
    func isTimeDifference1hr(_ comparisonDate: Date) -> Bool {
       
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        if order == .orderedSame {
            if let minutes =  self.totalDistance(from: comparisonDate, resultIn: .minute) {
                if minutes <= 60 {
                    return true
                }
                return false
            }
            return true
        }
        else {
            return false
        }
        
    }
    // 24 hour format gives an error, hence 12 hour format
    
    func toString(format: String =  "MMM dd YYYY HH:mm a") -> String? {
        ///"Sept 8 2019 12:00 PM"//String = "MMM dd YYYY HH:mm a")
        //"MM/dd   h:mm a
        let formatter = DateFormatter()
        formatter.dateFormat = format
        let date = formatter.string(from: self)
        return date
    }

}


//String = "MMM dd YYYY hh:mm a"
