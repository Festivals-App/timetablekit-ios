//
//  CalulatedColors.swift
//  TimetableKit
//
//  Created by Simon Gaus on 25.09.20.
//

import UIKit

extension UIColor {
    
    func darker(_ amount: CGFloat = 0.2) -> UIColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor.init(red: max(r-amount, 0.0), green: max(g-amount, 0.0), blue: max(b-amount, 0.0), alpha: a)
        }
        return self
    }
    
    func lighter(_ amount: CGFloat = 0.2) -> UIColor {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return UIColor.init(red: min(r+amount, 1.0), green: min(g+amount, 1.0), blue: min(b+amount, 1.0), alpha: a)
        }
        return self
    }
    
    /// https://github.com/mattjgalloway/MJGFoundation/blob/master/Source/Categories/UIColor/UIColor-MJGAdditions.m#L68
    func contrastingColor() -> UIColor {
        
        let black = UIColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        let white = UIColor.init(red: 1, green: 1, blue: 1, alpha: 1)
        
        let blackDiff = self.luminosityDifference(to: black)
        let whiteDiff = self.luminosityDifference(to: white)
        
        return (blackDiff > whiteDiff) ? black : white
    }
    
    /// https://github.com/mattjgalloway/MJGFoundation/blob/master/Source/Categories/UIColor/UIColor-MJGAdditions.m#L68
    private func luminosity() -> CGFloat {
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        if self.getRed(&r, green: &g, blue: &b, alpha: &a) {
            return 0.2126 * pow(r, 2.2) + 0.7152 * pow(g, 2.2) + 0.0722 * pow(b, 2.2)
        }
        
        var white: CGFloat = 0
        if self.getWhite(&white, alpha: &a) {
            return pow(white, 2.2)
        }
        
        return -1
    }
    
    /// https://github.com/mattjgalloway/MJGFoundation/blob/master/Source/Categories/UIColor/UIColor-MJGAdditions.m#L68
    private func luminosityDifference(to color: UIColor) -> CGFloat {
        
        let l1 = self.luminosity()
        let l2 = color.luminosity()
        if (l1 >= 0 && l2 >= 0) {
            if (l1 > l2) {
                return (l1+0.05) / (l2+0.05);
            } else {
                return (l2+0.05) / (l1+0.05);
            }
        }
        return 0.0;
    }
}
