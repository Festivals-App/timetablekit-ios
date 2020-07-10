//
//  File.swift
//  
//
//  Created by Simon Gaus on 03.07.20.
//

import UIKit

/// This is a convenient extension to install autolayout contraints on view's.
extension UIView {
    
    /// This method will create and activate constraints that will pin the view to its superview with the given margins via autolayout.
    /// - Parameters:
    ///   - superview: The superview.
    ///   - leading: The leading margin.
    ///   - trailing: The trailing margin.
    ///   - top: The top margin.
    ///   - bottom: The bottom margin.
    /// - Returns: true if the constraints are installed successfully, otherwise false.
    func fit(to superview: UIView, leading: CGFloat = 0.0, trailing: CGFloat = 0.0, top: CGFloat = 0.0, bottom: CGFloat = 0.0) -> Bool {
        
        if !self.isDescendant(of: superview) { return false }
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: leading).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: trailing).isActive = true
        self.topAnchor.constraint(equalTo: superview.topAnchor, constant: top).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: bottom).isActive = true
        
        return true
    }
    
    func stickToTop(of superview: UIView, height: CGFloat, sideMargin: CGFloat = 0.0) -> Bool {
        
        if !self.isDescendant(of: superview) { return false }
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: sideMargin).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -sideMargin).isActive = true
        self.topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        self.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        return true
    }
    
    func stickToBottom(of superview: UIView, heightRatio: CGFloat = 0.7142857143, sideMargin: CGFloat = 0.0) -> Bool {
        
        if !self.isDescendant(of: superview) { return false }
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: sideMargin).isActive = true
        self.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -sideMargin).isActive = true
        self.bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
        
        NSLayoutConstraint.init(item: self, attribute: .height, relatedBy: .equal, toItem: superview, attribute: .height, multiplier: heightRatio, constant: 0.0).isActive = true
        
        return true
    }
}
