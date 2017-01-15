//
//  UIColorExtensions.swift
//  CBREConnect
//
//  Created by Etjen Ymeraj on 12/18/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import Foundation
import UIKit
extension String{
    
func hexStringToUIColor () -> UIColor {
    var cString:String = self.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.characters.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
    }
    
    func toDateFormattedWith(format:String)-> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)!
    }
}
