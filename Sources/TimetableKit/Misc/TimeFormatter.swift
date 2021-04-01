//
//  File.swift
//  
//
//  Created by Simon Gaus on 10.07.20.
//

import UIKit

public class TimeFormatter: TimetableClock {
    
    public init() { }
    
    lazy private var calendar: Calendar = {
        var cal = Calendar.current
        cal.timeZone = TimeZone.init(identifier: "Europe/Berlin")!
        return cal
    }()
    
    lazy private var houreFormatter: DateFormatter = {
        var houreFormatter = DateFormatter.init()
        houreFormatter.dateFormat = "HH:mm"
        return houreFormatter
    }()
    
    lazy private var dayFormatter: DateFormatter = {
        var dayFormatter = DateFormatter.init()
        dayFormatter.dateFormat = "EEEE, d MMM"
        return dayFormatter
    }()
    
    lazy private var componentsFormatter: DateComponentsFormatter = {
        var formatter = DateComponentsFormatter.init()
        formatter.unitsStyle = .full
        formatter.calendar = self.calendar
        return formatter
    }()
    
    public func string(from date: Date) -> String {
        return houreFormatter.string(from: date)
    }
    
    public func string(from interval: DateInterval) -> String {
        return "\(houreFormatter.string(from: interval.start)) - \(houreFormatter.string(from: interval.end))"
    }
    
    public func dayString(from date: Date) -> String {
        return dayFormatter.string(from: date)
    }
    
    public func description(of date: Date, relativeTo interval: DateInterval) -> String {
        
        var value = ""
        var timeTillShowStart = interval.start.timeIntervalSince(date)
        // interval.start is earlier than date
        if timeTillShowStart < 0 {
            
            let timeTillShowEnd = interval.end.timeIntervalSince(date)
            // interval.end is earlier than date the show is over!
            if timeTillShowEnd < 0 {
                value = String.init(format: "Seit %@ vorbei", reasonableTimeString(from: timeTillShowEnd))
            }
            // the show is still running ...
            else {
                let lengthOfShow = interval.duration
                let timePlayed = lengthOfShow-timeTillShowEnd
                // there is more than half of the event left
                if timePlayed < lengthOfShow/1.8 {
                    value = String.init(format: "Läuft seit %@", reasonableTimeString(from: timePlayed))
                }
                // There is less than half of the event left
                else {
                    value = String.init(format: "Läuft noch %@", reasonableTimeString(from: timeTillShowEnd))
                }
            }
        }
        // date is earlier than interval.start
        else {
            // we need time without indicator of relativ time
            timeTillShowStart = abs(timeTillShowStart)
            
            if timeTillShowStart.minutes < 1.0 {
                value = "Jetzt!"
            }
            else {
                value = String.init(format: "Noch %@", reasonableTimeString(from: timeTillShowStart))
            }
        }
        
        
        
    
        
        return value
    }

    private func reasonableTimeString(from duration: TimeInterval) -> String {

        let absoluteDuration = abs(duration)
                
        var value = ""
        let hours = Int(absoluteDuration) / 3600
        let minutes = Int(absoluteDuration) % 3600 / 60
        
        //print("hours: \(hours) minutes: \(minutes)")
        
        if hours >= 24 {
            value = "mehr als 24 Stunden"
        }
        else if hours > 4 {
            var components = DateComponents.init()
            components.hour = hours
            let hoursString = componentsFormatter.string(from: components) ?? "<invalid>"
            value = String.init(format: "ca. %@", hoursString)
        }
        else {
            var components = DateComponents.init()
            components.hour = hours
            components.minute = minutes
            value = componentsFormatter.string(from: components) ?? "<invalid>"
        }
        
        return value
    }
    
    public func currentDate(_ timetableView: TimetableView) -> Date {
        return timetableView.clock?.currentDate(timetableView) ?? Date()
    }
}
