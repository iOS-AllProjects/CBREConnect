//
//  UIImageExtensions.swift
//  CBREConnect
//
//  Created by Etjen Ymeraj on 12/18/16.
//  Copyright © 2016 Etjen Ymeraj. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    func scaleUIImageToSize(size: CGSize) -> UIImage {
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, scale)
        self.draw(in: CGRect(origin: CGPoint.zero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return scaledImage!
    }
}
