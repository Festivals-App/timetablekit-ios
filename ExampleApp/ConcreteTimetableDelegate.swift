//
//  ConcreteTimetableDelegate.swift
//  TimetableKit
//
//  Created by Simon Gaus on 29.09.20.
//

import Foundation
import UIKit

let kTESTMONTH = 9
let kTESTDAY = 29
let kTESTYEAR = 2020

class TimetableCoordinator: NSObject, TimetableDataSource, TimetableDelegate, TimetableAppearanceDelegate, TimetableClock {
    
    
    var parent: TimetableView_wrapper
    
    init(_ parent: TimetableView_wrapper) {
        self.parent = parent
    }
    
    func timetableView(_ timetableView: TimetableView, didSelectEventWith identifier: Int) {
        print("didSelectEventWith: \(identifier)")
    }
    
    func timetableView(_ timetableView: TimetableView, didScrollTo offset: CGPoint) {
        print("timetableView didScrollTo: \(offset)")
        parent.offset = offset
    }
    
    var sections: [SECTION] = SECTION.testData()
    
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
        return DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY, H: 13, M: 0), end: Date.date(m: kTESTMONTH, d: kTESTDAY+2, H: 7, M: 0))
    }
    
    func numberOfDays(in timetableView: TimetableView) -> Int {
        return 2
    }
    
    func timetableView(_ timetableView: TimetableView, titleForDayAt index: Int) -> String {
        
        if index == 0 {
            return "Heute"
        }
        if index == 1 {
            return "Sa., 1. April"
        }
        return "<unknown>"
    }
    
    func timetableView(_ timetableView: TimetableView, intervalForDayAt index: Int) -> DateInterval {
        if index == 0 { return DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY, H: 14, M: 15), end: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 4, M: 15)) }
        else { return DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 14, M: 15), end: Date.date(m: kTESTMONTH, d: kTESTDAY+2, H: 5, M: 30)) }
    }
    
    func bottomPadding(for timetableView: TimetableView) -> CGFloat {
        return 200
    }
    
    func timetabelBackgroundColor() -> UIColor {
        return .cyan
    }
    
    func timetabelSectionHeaderColor() -> UIColor {
        return .yellow
    }
    
    func timetabelRowHeaderColor() -> UIColor {
        return .green
    }
    
    func timetabelRowColor() -> UIColor {
        return .lightGray
    }
    
    func timetabelEventTileColor() -> UIColor {
        return .black
    }
    
    func timetabelEventTileHighlightColor() -> UIColor {
        return .red
    }
    
    func timetabelEventTileTextColor() -> UIColor {
        return .blue
    }
    
    func currentDate(_ timetableView: TimetableView) -> Date {
        return Date.date(m: kTESTMONTH, d: kTESTDAY, H: 15, M: 7)
    }
    
    func timetableView(_ timetableView: TimetableView, didSelectRowAt indexPath: IndexPath) {
            
    }
    
    func timetableView(_ timetableView: TimetableView, didSelectEventAt indexPath: IndexPath) {
                
    }
}

class SECTION {
    
    var title: String!
    var rows: [TimetableRowData]!
    
    static func testData() -> [SECTION] {
        
        let music = musicSection()
        let food = foodSection()
        return [music, food]
    }
}

class EVENT: TimetableEvent {
    var title: String
    var interval: DateInterval
    var isFavourite: Bool
    var uniqueIdentifier: Int { title.hash }
    
    init(_ title: String = "", _ interval: DateInterval = DateInterval(), _ isFavourite: Bool = false) {
        self.title = title
        self.interval = interval
        self.isFavourite = isFavourite
    }
}


func musicSection() -> SECTION {
    
    let music = SECTION.init()
    music.title = "Music"
    
    let schoko = TimetableRowData()
    schoko.title = "Schokoladen"
    
    let event1 = EVENT("Tosin Abasi", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY, H: 14, M: 15), end: Date.date(m: kTESTMONTH, d: kTESTDAY, H: 15, M: 30)))
    event1.isFavourite = true
    let event2 = EVENT("Rückkopplung", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY, H: 16, M: 0), end: Date.date(m: kTESTMONTH, d: kTESTDAY, H: 17, M: 15)))
    let event3 = EVENT("Ursina", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY, H: 17, M: 45), end: Date.date(m: kTESTMONTH, d: kTESTDAY, H: 18, M: 45)))
    let event4 = EVENT("Bleu Roi", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY, H: 19, M: 15), end: Date.date(m: kTESTMONTH, d: kTESTDAY, H: 20, M: 30)))
    let event5 = EVENT("Yes I'm Very Tired Now", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY, H: 20, M: 45), end: Date.date(m: kTESTMONTH, d: kTESTDAY, H: 22, M: 0)))
    
    let event6 = EVENT("Parrot to the Moon", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 14, M: 15), end: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 16, M: 0)))
    let event7 = EVENT("Soybomb", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 16, M: 30), end: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 17, M: 45)))
    let event8 = EVENT("Frank Powers", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 18, M: 15), end: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 19, M: 30)))
    let event9 = EVENT("Panda Lux", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 20, M: 0), end: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 21, M: 0)))
    let event10 = EVENT("GeilerAsDu", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 21, M: 15), end: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 22, M: 45)))
    
    schoko.events = [event1, event2, event3, event4, event5, event6, event7, event8, event9, event10]
    
    let wald = TimetableRowData()
    wald.title = "Waldbühne"

    let event11 = EVENT("Nemo", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY, H: 20, M: 00), end: Date.date(m: kTESTMONTH, d: kTESTDAY, H: 21, M: 15)))
    let event22 = EVENT("Roosevelt", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY, H: 21, M: 30), end: Date.date(m: kTESTMONTH, d: kTESTDAY, H: 22, M: 30)))
    let event33 = EVENT("Young Fathers", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY, H: 23, M: 0), end: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 0, M: 0)))
    let event44 = EVENT("The Shins", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 0, M: 30), end: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 2, M: 30)))
    
    let event55 = EVENT("Baba Shrimps", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 20, M: 0), end: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 21, M: 15)))
    let event66 = EVENT("Frank Turner", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 21, M: 30), end: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 22, M: 30)))
    let event77 = EVENT("The Slow Show", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 23, M: 0), end: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 23, M: 55)))
    let event87 = EVENT("SBTRKT (DJ-Set)", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY+2, H: 0, M: 30), end: Date.date(m: kTESTMONTH, d: kTESTDAY+2, H: 2, M: 30)))
    
    wald.events = [event11, event22, event33, event44, event55, event66, event77, event87]
    
    let future = TimetableRowData()
    future.title = "Zukunft am Ostkreuz"

    let event111 = EVENT("Odd Beholder", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY, H: 20, M: 0), end: Date.date(m: kTESTMONTH, d: kTESTDAY, H: 21, M: 0)))
    let event222 = EVENT("S.O.S. (Dawill & Nativ)", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY, H: 21, M: 15), end: Date.date(m: kTESTMONTH, d: kTESTDAY, H: 22, M: 15)))
    let event333 = EVENT("Hyperculte", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY, H: 22, M: 30), end: Date.date(m: kTESTMONTH, d: kTESTDAY, H: 23, M: 20)))
    let event444 = EVENT("Crimer", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY, H: 23, M: 45), end: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 0, M: 30)))
    let event555 = EVENT("Cakes Da Killa Milano", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 1, M: 0), end: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 2, M: 0)))
    let event666 = EVENT("Audio Dope", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 2, M: 15), end: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 3, M: 0)))
    let event777 = EVENT("Afterparty (Hodini DJ-Set)", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 3, M: 15), end: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 4, M: 15)))
    
    let event888 = EVENT("MoreEats", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 20, M: 0), end: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 21, M: 0)))
    let event999 = EVENT("JPTR", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 21, M: 15), end: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 22, M: 15)))
    let event100 = EVENT("Parcels", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 22, M: 30), end: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 23, M: 30)))
    let event101 = EVENT("Klangstof", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 23, M: 45), end: Date.date(m: kTESTMONTH, d: kTESTDAY+2, H: 0, M: 45)))
    let event102 = EVENT("SWK (Pink Flamingo, Makala, Di-Meh, SlimKa)", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY+2, H: 1, M: 0), end: Date.date(m: kTESTMONTH, d: kTESTDAY+2, H: 2, M: 0)))
    let event103 = EVENT("Crack Ignaz", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY+2, H: 2, M: 30), end: Date.date(m: kTESTMONTH, d: kTESTDAY+2, H: 3, M: 0)))
    let event104 = EVENT("Afterparty mit Manuel Fischer (Drumpoet Community)", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY+2, H: 3, M: 15), end: Date.date(m: kTESTMONTH, d: kTESTDAY+2, H: 5, M: 30)))
    
    future.events = [event111, event222, event333, event444, event555, event666, event777, event888, event999, event100, event101, event102, event103, event104]

    music.rows = [schoko, wald, future]
    
    return music
}

func foodSection() -> SECTION {
    
    let food = SECTION.init()
    food.title = "Food"
    
    let brot = TimetableRowData()
    brot.title = "HandBrotZeit"
    let event21 = EVENT("Öffnungszeiten ", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY, H: 14, M: 30), end: Date.date(m: kTESTMONTH, d: kTESTDAY, H: 22, M: 30)))
    let event221 = EVENT("Öffnungszeiten", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 14, M: 30), end: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 22, M: 30)))
    brot.events = [event21, event221]
    let döna = TimetableRowData()
    döna.title = "Kaplan Döner"
    let event211 = EVENT("Öffnungszeiten ", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY, H: 14, M: 0), end: Date.date(m: kTESTMONTH, d: kTESTDAY, H: 23, M: 0)))
    let event2211 = EVENT("Öffnungszeiten", DateInterval(start: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 14, M: 0), end: Date.date(m: kTESTMONTH, d: kTESTDAY+1, H: 23, M: 0)))
    döna.events = [event211, event2211]

    food.rows = [brot, döna]
    
    return food
}

extension Date {
    
    /// month, day, Hour, Minute
    static func date(m: Int, d: Int, H: Int, M: Int) -> Date {
        
        var components = DateComponents.init()
        components.year = kTESTYEAR
        components.month = m
        components.day = d
        components.hour = H
        components.minute = M
        
        var gregorian = Calendar.init(identifier: .gregorian)
        gregorian.timeZone = TimeZone.init(identifier: "Europe/Berlin")!
        
        return gregorian.date(from: components)!
    }
}
