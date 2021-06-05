//
//  File.swift
//  
//
//  Created by Simon Gaus on 10.07.20.
//

import UIKit


/// The time formatter can be used to create representations of dates, times and of dates and times relative to each other.
public class TimeFormatter {
    
    public static let shared = TimeFormatter()
    public static func prepare() { let _ = TimeFormatter.shared }
    
    public var componentsFormatter: DateComponentsFormatter
    
    private var calendar: Calendar
    private var houreFormatter: DateFormatter
    private var dayFormatter: DateFormatter
    
    public init() {
        
        var cal = Calendar.current
        cal.timeZone = TimeZone.current
        calendar = cal
        
        let hFormatter = DateFormatter.init()
        hFormatter.dateFormat = "HH:mm"
        houreFormatter = hFormatter
        
        let dFormatter = DateFormatter.init()
        dFormatter.dateFormat = "EEEE, d MMM"
        dayFormatter = dFormatter
        
        let formatter = DateComponentsFormatter.init()
        formatter.unitsStyle = .full
        formatter.calendar = cal
        componentsFormatter = formatter
    }
    
    /// Creates a string represetation of the given date using only the time information. Format: HH:mm
    /// - Parameter date: The date to get the string representation from.
    /// - Returns: The description of the date.
    public func string(from date: Date) -> String {
        return houreFormatter.string(from: date)
    }
    
    /// Creates a string represetation of the given date interval using only the time information. Format: HH:mm - HH:mm
    /// - Parameter interval: The interval to get the string representation from.
    /// - Returns: The description of the date interval.
    public func string(from interval: DateInterval) -> String {
        return "\(houreFormatter.string(from: interval.start)) - \(houreFormatter.string(from: interval.end))"
    }
    
    /// Creates a string represetation of the given date using only the date information. Format: EEEE, d MMM
    /// - Parameter date: The date to get the string representation from.
    /// - Returns: The description of the date.
    public func dayString(from date: Date) -> String {
        return dayFormatter.string(from: date)
    }
    
    /// Creates a description of the given date relative to the given date interval. The description is based on whether the date is before, after or in between the given date interval.
    /// - Parameters:
    ///   - date: The date to get the description from.
    ///   - interval: The date interval the description is relativ to.
    /// - Returns: The description of the date.
    public func description(of date: Date, relativeTo interval: DateInterval) -> String {
        
        var value = ""
        var timeTillShowStart = interval.start.timeIntervalSince(date)
        // interval.start is earlier than date
        if timeTillShowStart < 0 {
            
            let timeTillShowEnd = interval.end.timeIntervalSince(date)
            // interval.end is earlier than date / the show is over!
            if timeTillShowEnd == 0 {
                value = NSLocalizedString("Over", bundle: .module, comment: "UI String - String describing Over.")
            }
            else if timeTillShowEnd < 0 {
                let formatString = NSLocalizedString("Over since %@", bundle: .module, comment: "UI String - String describing how long the date is after the time interval.")
                value = String.init(format: formatString, reasonableTimeString(from: timeTillShowEnd, false))
            }
            // the show is still running ...
            else {
                let lengthOfShow = interval.duration
                let timePlayed = lengthOfShow-timeTillShowEnd
                // there is more than half of the event left
                if timePlayed < lengthOfShow/1.8 {
                    let formatString = NSLocalizedString("Running since %@", bundle: .module, comment: "UI String - String describing how long the date is after the start of the time interval.")
                    value = String.init(format: formatString, reasonableTimeString(from: timePlayed))
                }
                // There is less than half of the event left
                else {
                    let formatString = NSLocalizedString("Approx. %@ left", bundle: .module, comment: "UI String - String describing how much time is left until the end of the the time interval.")
                    value = String.init(format: formatString, reasonableTimeString(from: timeTillShowEnd, false))
                }
            }
        }
        // date is earlier than interval.start
        else {
            // we need time without indicator of relativ time
            timeTillShowStart = abs(timeTillShowStart)
            
            if timeTillShowStart.minutes < 1.0 {
                value = NSLocalizedString("Now!", bundle: .module, comment: "UI String - String describing NOW!.")
            }
            else {
                let formatString = NSLocalizedString("%@ left", bundle: .module, comment: "UI String - String describing how much time is left till the start of the time interval.")
                value = String.init(format: formatString, reasonableTimeString(from: timeTillShowStart, false, true))
            }
        }
        
        return value
    }
    
    /// Creates a string representation of the given duration. Reasonable means in this case that the function
    /// will try to create descriptions that feel reasonable for the domain of events.
    /// - Parameters:
    ///   - duration: The duration to describe.
    ///   - approx: Boolean value indicating if approximately should be included in the description.
    /// - Returns: The description of the duration.
    private func reasonableTimeString(from duration: TimeInterval, _ approx: Bool = true, _ capital: Bool = false) -> String {

        let absoluteDuration = abs(duration)
                
        var value = ""
        let hours = Int(absoluteDuration) / 3600
        let minutes = Int(absoluteDuration) % 3600 / 60
        
        if hours >= 24 {
            value = NSLocalizedString("more than 24 hours", bundle: .module, comment: "UI String - More than 24 hours.")
            if capital {
                value = NSLocalizedString("More than 24 hours", bundle: .module, comment: "UI String - EN captialization - More than 24 hours.")
            }
        }
        else if hours > 4 {
            var components = DateComponents.init()
            components.hour = hours
            let hoursString = componentsFormatter.string(from: components) ?? "<invalid>"
            if approx {
                let formatString = NSLocalizedString("approx. %@", bundle: .module, comment: "UI String - Approximately <time>")
                value = String.init(format: formatString, hoursString)
            }
            else {
                value = String.init(format: "%@", hoursString)
            }
        }
        else {
            var components = DateComponents.init()
            components.hour = hours
            components.minute = minutes
            value = componentsFormatter.string(from: components) ?? "<invalid>"
        }
        
        return value
    }
}
