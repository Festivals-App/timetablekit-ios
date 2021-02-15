//
//  TimetableDataEntities.swift
//  TimetableKit
//
//  Created by Simon Gaus on 15.02.21.
//

import Foundation

class TimetableSectionData {
    
    var title: String
    var rows: [TimetableRowData]
    
    init(with title: String = "", and rows: [TimetableRowData] = []) {
        self.title = title
        self.rows = rows
    }
}

class TimetableRowData {
    
    var title: String
    var events: [TimetableEvent]
    
    init(with title: String = "", and events: [TimetableEvent] = []) {
        self.title = title
        self.events = events
    }
}

class TimetableIntervalData {
    
    var title: String
    var interval: DateInterval
    
    init(with title: String, and interval: DateInterval) {
        self.title = title
        self.interval = interval
    }
}
