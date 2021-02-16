//
//  Numbers+Convenient.swift
//  TimetableKit
//
//  Created by Simon Gaus on 16.02.21.
//

import UIKit

extension Double {
    
    var floaty: CGFloat {
        CGFloat(self)
    }
}

extension CGFloat {
    
    func isNearlyEqual(to offset: CGFloat) -> Bool {
        return (self < offset) ? ((offset-self) < 2.0) : ((self-offset) < 2.0);
    }
}
