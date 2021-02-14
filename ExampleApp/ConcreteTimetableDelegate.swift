//
//  ConcreteTimetableDelegate.swift
//  TimetableKit
//
//  Created by Simon Gaus on 29.09.20.
//

import Foundation

let kMONTH = 9
let kDAY = 29

class ConcreteTimetableDelegate: TimetableDataSource {
    
    var sections: [SECTION] = SECTION.testData()
    
    init() {
        
    }
    
    func timetableView(_ timetableView: TimetableView, eventsForRowAt indexPath: IndexPath) -> [TimetableEvent] {
        return sections[indexPath.section].rows[indexPath.row].events
    }
    
    func numberOfSections(in timetableView: TimetableView) -> Int {
        return sections.count
    }
    
    func timetableView(_ timetableView: TimetableView, numberOfRowsIn section: Int) -> Int {
        return sections[section].rows.count
    }
    
    func timetableView(_ timetableView: TimetableView, titleForHeaderOf section: Int) -> String? {
        return sections[section].title
    }
    
    func timetableView(_ timetableView: TimetableView, titleForRowAt indexPath: IndexPath) -> String {
        return sections[indexPath.section].rows[indexPath.row].title
    }
    
    func interval(for timetableView: TimetableView) -> DateInterval {
        return DateInterval.init(start: Date.date(m: kMONTH, d: kDAY, H: 13, M: 0), end: Date.date(m: kMONTH, d: kDAY+1, H: 23, M: 30))
    }
    
    func numberOfDays(in timetableView: TimetableView) -> Int {
        return 2
    }
    
    func timetableView(_ timetableView: TimetableView, titleForDayAt index: Int) -> String {
        
        if index == 0 {
            return "Fr., 31. März"
        }
        if index == 1 {
            return "Sa., 1. April"
        }
        return "<unknown>"
    }
    
    func timetableView(_ timetableView: TimetableView, intervalForDayAt index: Int) -> DateInterval {
        if index == 0 { return DateInterval.init(start: Date.date(m: kMONTH, d: kDAY, H: 14, M: 15), end: Date.date(m: kMONTH, d: kDAY+1, H: 3, M: 30)) }
        else { return DateInterval.init(start: Date.date(m: kMONTH, d: kDAY+1, H: 13, M: 0), end: Date.date(m: kMONTH, d: kDAY+1, H: 23, M: 0)) }
    }
}

class SECTION {
    
    var title: String!
    var rows: [ROW]!
    
    static func testData() -> [SECTION] {
        
        let music = musicSection()
        let food = foodSection()
        return [music, food]
    }
}

class ROW {
    var title: String!
    var events: [TimetableEvent]!
}

class EVENT: TimetableEvent {
    var title: String
    var interval: DateInterval
    var isFavourite: Bool
    
    init(_ title: String = "", _ interval: DateInterval = DateInterval(), _ isFavourite: Bool = false) {
        self.title = title
        self.interval = interval
        self.isFavourite = isFavourite
    }
}


func musicSection() -> SECTION {
    
    let music = SECTION.init()
    music.title = "Music"
    
    let schoko = ROW.init()
    schoko.title = "Schokoladen"
    
    let event1 = EVENT.init()
    event1.title = "Tosin Abasi"
    event1.interval = DateInterval.init(start: Date.date(m: kMONTH, d: kDAY, H: 14, M: 15), end: Date.date(m: kMONTH, d: kDAY, H: 15, M: 30))
    event1.isFavourite = true
    
    let event2 = EVENT.init()
    event2.title = "Rückkopplung"
    event2.interval = DateInterval.init(start: Date.date(m: kMONTH, d: kDAY, H: 16, M: 0), end: Date.date(m: kMONTH, d: kDAY, H: 17, M: 15))
    event2.isFavourite = false
    
    schoko.events = [event1, event2]
    
    let wald = ROW.init()
    wald.title = "Waldbühne"
    wald.events = [TimetableEvent]()
    
    let future = ROW.init()
    future.title = "Zukunft am Ostkreuz"
    future.events = [TimetableEvent]()

    music.rows = [schoko, wald, future]
    
    return music
}

func foodSection() -> SECTION {
    
    let food = SECTION.init()
    food.title = "Food"
    
    let brot = ROW.init()
    brot.title = "HandBrotZeit"
    brot.events = [TimetableEvent]()
    let döna = ROW.init()
    döna.title = "Kaplan Döner"
    döna.events = [TimetableEvent]()

    food.rows = [brot, döna]
    
    return food
}

let kYEAR = 2020

extension Date {
    
    /// month, day, Hour, Minute
    static func date(m: Int, d: Int, H: Int, M: Int) -> Date {
        
        var components = DateComponents.init()
        components.year = kYEAR
        components.month = m
        components.day = d
        components.hour = H
        components.minute = M
        
        var gregorian = Calendar.init(identifier: .gregorian)
        gregorian.timeZone = TimeZone.init(identifier: "Europe/Berlin")!
        
        return gregorian.date(from: components)!
    }
}
