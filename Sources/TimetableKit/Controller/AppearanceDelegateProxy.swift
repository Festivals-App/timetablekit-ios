//
//  AppearanceDelegateProxy.swift
//  TimetableKit
//
//  Created by Simon Gaus on 27.09.20.
//

import UIKit

/**
 The `AppearanceDelegateProxy` class is used as a proxy appearance delegate object for the timetable view.
 
 If the user of the timetable provides a appearance delegate the proxy will return the values of the delegate, if not it will return default values.
 */
class AppearanceDelegateProxy: TimetableAppearanceDelegate {
    
    private weak var timetable: TimetableView?
    
    required init(with timetable: TimetableView) {
        self.timetable = timetable
    }
    
    private var backgroundColor_light: UIColor = UIColor.with(248.0,248.0,248.0)
    private var sectionHeaderColor_light: UIColor = UIColor.with(248.0,248.0,248.0)
    private var rowHeaderColor_light: UIColor = UIColor.with(248.0,248.0,248.0)
    private var rowColor_light: UIColor = UIColor.with(242.0,242.0,242.0)
    private var eventTileColor_light: UIColor = UIColor.with(227.0,227.0,227.0)
    private var eventTileHighlightColor_light: UIColor = UIColor.with(237.0,61.0,82.0)
    private var eventTileTextColor_light: UIColor = UIColor.black
    
    private var backgroundColor: UIColor = UIColor.with(34.0, 34.0, 34.0)
    private var sectionHeaderColor: UIColor = UIColor.with(34.0, 34.0, 34.0)
    private var rowHeaderColor: UIColor = UIColor.with(34.0, 34.0, 34.0)
    private var rowColor: UIColor = UIColor.with(42.0, 42.0, 42.0)
    private var eventTileColor: UIColor = UIColor.with(68.0, 68.0, 68.0)
    private var eventTileHighlightColor: UIColor = UIColor.with(237.0, 61.0, 82.0)
    private var eventTileTextColor: UIColor = UIColor.white

    func timetabelBackgroundColor() -> UIColor {
    
        if self.appearanceDelegate != nil { return self.appearanceDelegate!.timetabelBackgroundColor() }
        guard let timetable = timetable else { return .systemBlue }
        return (timetable.style == .light) ? backgroundColor_light : backgroundColor
    }
    
    func timetabelSectionHeaderColor() -> UIColor {
        if self.appearanceDelegate != nil { return self.appearanceDelegate!.timetabelSectionHeaderColor() }
        guard let timetable = timetable else { return .systemBlue }
        return (timetable.style == .light) ? sectionHeaderColor_light : sectionHeaderColor
    }
    
    func timetabelRowHeaderColor() -> UIColor {
        if self.appearanceDelegate != nil { return self.appearanceDelegate!.timetabelRowHeaderColor() }
        guard let timetable = timetable else { return .systemBlue }
        return (timetable.style == .light) ? rowHeaderColor_light : rowHeaderColor
    }
    
    func timetabelRowColor() -> UIColor {
        if self.appearanceDelegate != nil { return self.appearanceDelegate!.timetabelRowColor() }
        guard let timetable = timetable else { return .systemBlue }
        return (timetable.style == .light) ? rowColor_light : rowColor
    }
    
    func timetabelEventTileColor() -> UIColor {
        if self.appearanceDelegate != nil { return self.appearanceDelegate!.timetabelEventTileColor() }
        guard let timetable = timetable else { return .systemBlue }
        return (timetable.style == .light) ? eventTileColor_light : eventTileColor
    }
    
    func timetabelEventTileHighlightColor() -> UIColor {
        if self.appearanceDelegate != nil { return self.appearanceDelegate!.timetabelEventTileHighlightColor() }
        guard let timetable = timetable else { return .systemBlue }
        return (timetable.style == .light) ? eventTileHighlightColor_light : eventTileHighlightColor
    }
    
    func timetabelEventTileTextColor() -> UIColor {
        if self.appearanceDelegate != nil { return self.appearanceDelegate!.timetabelEventTileTextColor() }
        guard let timetable = timetable else { return .systemBlue }
        return (timetable.style == .light) ? eventTileTextColor_light : eventTileTextColor
    }
    
    private var appearanceDelegate: TimetableAppearanceDelegate? {
        guard let timetable = timetable else { return nil }
        return timetable.appearanceDelegate
    }

}


extension UIColor {
    
    static func with(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat) -> UIColor {
        return UIColor.init(red: (r/255.0), green: (g/255.0), blue: (b/255.0), alpha: 1.0)
    }
}
