//
//  File.swift
//  
//
//  Created by Simon Gaus on 20.05.20.
//

#if !os(iOS)
import AppKit
#else
import UIKit
#endif

/// The style of the timetable view.
enum TimetableStyle {
    /// A dark timetable view style.
    case dark
    /// A light timetable view style.
    case light
    /// The timetable view style is determined by the brightness of the screen.
    case automatic
    /// The timetable view style is determined the appearance delegate of the timetable.
    case custom
}

/**
 
 An object that manages an ordered collection of event items and presents them in the planned order.
 
 ## Overview
 
 When adding a timetable view to your user interface, your app’s main job is to manage the event data associated with that timetable view. The timetable view gets its data from the data source object, which is an object that conforms to the 'SGTimetableViewDataSource' protocol and is provided by your app. Data in the timetable view is organized into individual event items, which can then be grouped into locations and sections for presentation. An event item is the elementary data for the timetable view.
 
 A timetable view is made up of zero or more sections, each with its own locations. Sections are identified by their index number within the timetable view, and locations are identified by their index number within a section. Each row has one ore more tiles. Tiles are  identified by their index number within the location.
 
 ## Data Structure
 
 The structure of the timetable includes following components:
 
 * Event          Events are the elementary data for the timetable. An event is basically an entity which is defined by it's occurence in time specified by a time interval and a name attribute and a location where it occures.
 * Location     A group of events associated with the same location where they occure.
 * Section       A number of locations which are grouped together by theme or motto. This can be anything, for a festival there could be one section for the stages and one for the food shops.
 
 ## Limitations
 
 * The timetable view is not able to display overlapping or simultan occuring events at the same location, you have to split these locations into sub-locations if this happens in your scenario.
 * The timetable view is meant for displaying events that have a duration of houres not days. If you need to display lengthy events please consider to use a calendar view.
 
 */
class TimetableView: TimetableBaseView {
    
    var style: TimetableStyle = .automatic
    
    //initWithFrame to init view from code
    init(_ frame: CGRect, with style: TimetableStyle) {
        
        self.style = style
        super.init(frame: frame)
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //common func to init our view
    private func setupView() {
        backgroundColor = .red
    }
    
    /// Reloads the rows, tiles and sections of the timetable view.
    ///
    /// Call this method to reload all the data that is used to construct the timetable, including cells, section headers, index arrays, tiles and so on.
    func reloadData() {
        
    }
    
    /// Transitions to the specified timetable view style.
    /// - Parameters:
    ///   - style: The new timtable view stlye.
    ///   - animated: If `true`, the style is changed using an animation. Defaults to `true`.
    func transition(to style: TimetableStyle, animated: Bool = true) {
        
    }
    
}



class TimetableBaseView: View {
    //initWithFrame to init view from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    //initWithCode to init view from xib or storyboard
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    //common func to init our view
    private func setupView() {
        backgroundColor = .red
    }
}
