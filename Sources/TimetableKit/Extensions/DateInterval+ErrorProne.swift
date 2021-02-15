//
//  DateInterval+ErrorProne.swift
//  TimetableKit
//
//  Created by Simon Gaus on 16.02.21.
//

import Foundation

extension DateInterval {
    
    static func safely(start: Date, end: Date) -> DateInterval {
        
        if end >= start {
            return DateInterval(start: start, end: end)
        }
        else {
            print("DateInterval initialization: Precondition: end >= start not fulfilled. start: \(start) end \(end)")
            return DateInterval()
        }
    }
}
