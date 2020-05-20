//
//  File.swift
//  
//
//  Created by Simon Gaus on 20.05.20.
//

import Foundation

/**

The TimetableEvent protocol declares the methods that a class must implement, so that instances of that class can be used to populate a `TimetableView`.

A timetable displays events, so the elementary data to do that are events.
It is designed in a way, that an user of the 'TimetableView' class can still use their own app specific representation of events. He only needs to make his event representing class conform to the 'TimetableEvent' protocol and he is ready to use the timetable view. This could be done by adding a categorie or subclassing.

## Warning
AN EXCEPTION WILL BE THROWN if the used object does not conform to the 'TimetableEvent' protocol. No -respondToSelector: checks are made.

*/
protocol TimetableEvent: AnyObject {
    
    /// The name of the Item to display in the timeline.
    var title: String
    /// The interval of the item.
    var interval: DateInterval
    /// The favourite status of the item.
    var isFavourite: Bool
}
