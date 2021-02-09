//
//  File.swift
//  
//
//  Created by Simon Gaus on 10.07.20.
//

import UIKit

public class TimeFormatter {
    
    public init() { }
    
    lazy private var calendar: Calendar = {
        var cal = Calendar.current
        cal.timeZone = TimeZone.init(identifier: "Europe/Berlin")!
        return cal
    }()
    
    lazy private var dateFormatter: DateFormatter = {
        var dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter
    }()
    
    lazy private var componentsFormatter: DateComponentsFormatter = {
        var formatter = DateComponentsFormatter.init()
        formatter.unitsStyle = .full
        formatter.calendar = self.calendar
        return formatter
    }()
    
    func string(from date: Date) -> String {
        return dateFormatter.string(from: date)
    }
    
    func string(from interval: DateInterval) -> String {
        return "\(dateFormatter.string(from: interval.start)) - \(dateFormatter.string(from: interval.end))"
    }
    
    func descriptionOfRelativePosition(of interval: DateInterval, to date: Date) -> String {
        
        var value = ""
        let timeTillShowStart = interval.start.timeIntervalSince(date)
        
        // current time is before the start of the event
        if timeTillShowStart >= 0 {
            let format = NSLocalizedString("Noch %@", bundle: .module, comment: "UI String - TimeFormatter - String describing how much time is left before an event starts.")
            value = String.init(format: format, reasonableTimeString(from: timeTillShowStart))
        }
        // current time is after the start of the event
        else {
            let timeTillShowEnd = interval.end.timeIntervalSince(currentDate())
            if timeTillShowEnd >= 0 {
                let format = NSLocalizedString("Läuft seit %@", bundle: .module, comment: "UI String - TimeFormatter - String describing how much time is left before an event ends.")
                value = String.init(format: format, reasonableTimeString(from: timeTillShowEnd))
            }
            else {
                let format = NSLocalizedString("Seit %@ vorbei", bundle: .module, comment: "UI String - TimeFormatter - String describing how much time has passed since an event ended.")
                value = String.init(format: format, reasonableTimeString(from: timeTillShowEnd))
            }
        }
        return value
    }
    
    func descriptionOfRelativePositionToNow(and interval: DateInterval) -> String {
        
        var value = ""
        let timeTillShowStart = interval.start.timeIntervalSince(currentDate())
        
        // current time is before the start of the event
        if timeTillShowStart >= 0 {
            let format = NSLocalizedString("Noch %@", bundle: .module, comment: "UI String - TimeFormatter - String describing how much time is left before an event starts.")
            value = String.init(format: format, reasonableTimeString(from: timeTillShowStart))
        }
        // current time is after the start of the event
        else {
            let timeTillShowEnd = interval.end.timeIntervalSince(currentDate())
            if timeTillShowEnd >= 0 {
                let format = NSLocalizedString("Läuft seit %@", bundle: .module, comment: "UI String - TimeFormatter - String describing how much time is left before an event ends.")
                value = String.init(format: format, reasonableTimeString(from: timeTillShowEnd))
            }
            else {
                let format = NSLocalizedString("Seit %@ vorbei", bundle: .module, comment: "UI String - TimeFormatter - String describing how much time has passed since an event ended.")
                value = String.init(format: format, reasonableTimeString(from: timeTillShowEnd))
            }
        }
        return value
    }

    private func reasonableTimeString(from duration: TimeInterval) -> String {
        
        var value = ""
        let hours = Int(duration)/3600
        let minutes = Int(duration) % 3600 / 60
        
        if hours >= 24 {
            value = NSLocalizedString("mehr als 24 Stunden", bundle: .module, comment: "UI String - TimeFormatter - String describing that an event is (or was) more than 24 hours from now.")
        }
        else if hours > 4 {
            var components = DateComponents.init()
            components.hour = hours
            let hoursString = componentsFormatter.string(from: components) ?? "<invalid>"
            let format = NSLocalizedString("ca. %@", bundle: .module, comment: "UI String - TimeFormatter - String describing an duration of approximately '%@' hours.")
            value = String.init(format: format, hoursString)
        }
        else {
            var components = DateComponents.init()
            components.hour = hours
            components.minute = minutes
            value = componentsFormatter.string(from: components) ?? "<invalid>"
        }
        
        return value
    }
    
    #warning("make this a delegate function")
    private func currentDate() -> Date {
        return Date.init()
    }
}
