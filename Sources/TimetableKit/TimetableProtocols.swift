//
//  File.swift
//  
//
//  Created by Simon Gaus on 26.06.20.
//

import UIKit

// MARK: Timetable Data Source

/// The `TimetableDataSource` protocol is adopted by an object that mediates the application’s data model for a `TimetableView` object.
/// The data source provides the timetable view object with the information it needs to construct a timetable.
public protocol TimetableDataSource {

    /// Asks the data source for the events associated with a row at a particular row in the timetable.
    /// - Parameters:
    ///   - timetableView: The timetable view requesting the data.
    ///   - indexPath: The index path locating the row in the timetable view.
    /// - Returns: The events for the given row.
    func timetableView(_ timetableView: TimetableView, eventsForRowAt indexPath: IndexPath) -> [TimetableEvent]
    
    /// Asks the data source to return the number of sections in the timetable.
    ///
    /// If the timetable should not have sections, return 0.
    /// - Parameter timetableView: The timetable view requesting the data.
    /// - Returns: The number of sections.
    func numberOfSections(in timetableView: TimetableView) -> Int
    
    /// Tells the data source to return the number of rows in a given section of a timetable.
    /// - Parameters:
    ///   - timetableView: The timetable view requesting the data.
    ///   - section: The index locating the section in the timetable view.
    /// - Returns: The number of rows in the given section.
    func timetableView(_ timetableView: TimetableView, numberOfRowsIn section: Int) -> Int
    
    /// Asks the data source for the title of the header of the specified section in the timetable.
    /// - Parameters:
    ///   - timetableView: The timetable view requesting the data.
    ///   - section: The index locating the section in the timetable view.
    /// - Returns: The string to use as the title of the section. If the data source returns nil , the section will have no title.
    func timetableView(_ timetableView: TimetableView, titleForHeaderOf section: Int) -> String?
    
    /// Asks the data source for the title of the row at a particular location in the timetable.
    /// - Parameters:
    ///   - timetableView: The timetable view requesting the data.
    ///   - indexPath: The index path locating the row in the timetable view.
    /// - Returns: The title for the given row.
    func timetableView(_ timetableView: TimetableView, titleForRowAt indexPath: IndexPath) -> String
    
    /// Asks the data source for the time interval the timetable view should display.
    ///
    /// This is not necessarily equal to the interval defined by the start date of the first event and the end date of the last event.
    /// It is recommended to use some offset to the first and last event for a more nice-looking and enjoyable timetable.
    /// - Parameter timetableView: The timetable view requesting the data.
    /// - Returns: The time interval of the timetable view.
    func interval(for timetableView: TimetableView) -> DateInterval
    
    /// Asks the data source to return the number of days in the timetable.
    /// - Parameter timetableView: The timetable view requesting the data.
    /// - Returns: The number of days in the  timetable.
    func numberOfDays(in timetableView: TimetableView) -> Int
    
    /// Asks the data source for the title of the day at the given index.
    /// - Parameters:
    ///   - timetableView: The timetable view requesting the data.
    ///   - index: The index of the day.
    /// - Returns: The title of the day.
    func timetableView(_ timetableView: TimetableView, titleForDayAt index: Int) -> String
    
    /// Asks the data source for the date interval of the day.
    ///
    /// To prevent broad empty spaces where no events take place through which user has to scroll,
    /// the data source can specify the interval of the days so the timetable view can fast scroll those empty spaces.
    /// - Parameters:
    ///   - timetableView: The timetable view requesting the data.
    ///   - index: The index of the day.
    /// - Returns: The date interval of the day.
    func timetableView(_ timetableView: TimetableView, intervalForDayAt index: Int) -> DateInterval
}

// MARK: Timetable Delegate

/// The delegate of a `TimetableView` object must adopt the `TimetableDelegate` protocol.
/// The methods of the protocol allow the delegate to manage selections and configure section headers and rows.
public protocol TimetableDelegate {

    /// Tells the delegate that the specified row was taped by the user.
    /// - Parameters:
    ///   - timetableView: The timetable view informing the delegate about the selected row.
    ///   - indexPath: The index path identifying the selected row in the timetable view.
    func timetableView(_ timetableView: TimetableView, didSelectRowAt indexPath: IndexPath) -> Void
    
    /// Tells the delegate that the specified event was selected by the user.
    /// - Parameters:
    ///   - timetableView: The timetable view informing the delegate about the selected event.
    ///   - indexPath: The index path identifying the selected event in the timetable view.
    func timetableView(_ timetableView: TimetableView, didSelectEventAt indexPath: IndexPath) -> Void
}

// MARK: Timetable Appearance Delegate

/**
The `TimetableAppearanceDelegate` protocol is adopted by an object that mediates the application’s appearance  for the `TimetableView` object.

The timetable comes with two styles, dark and light. If you want to have your own style (e.g. colors) you need to set the appearance delegate and return appropriate colors.
 If you want to change the tableviews style after it was created, you can change the colors the appearance delegate returns and call `reloadData()` for an immediate color change
 or ` transition(to style:, animated:)` with `TimetableStyle.custom` as the style parameter for an animated color change.

## Important
If you set the appearance delegate it will always be favoured over the set TimetableViewStyle.
*/
public protocol TimetableAppearanceDelegate {
    
    // MARK: Specifying the Color of the Timetable View
    
    /// The background color of the timetable.
    func timetabelBackgroundColor() -> UIColor
    /// The background color of the timetable section headers.
    func timetabelSectionHeaderColor() -> UIColor
    /// The background color of the timetable row headers.
    func timetabelRowHeaderColor() -> UIColor
    /// The background color of the timetable rows.
    func timetabelRowColor() -> UIColor
    /// The background color of the event tiles.
    func timetabelEventTileColor() -> UIColor
    /// The background color of the event tiles if the event is favoured.
    func timetabelEventTileHighlightColor() -> UIColor
    /// The color of the label of the event tile.
    func timetabelEventTileTextColor() -> UIColor
}

// MARK: Timetable Layout Delegate

/**
The `TimetableLayoutDelegate` protocol is adopted by an object that provide crucial information that are needed to layout the components for the `TimetableView` object.

Most of the timetable components depend on a conversion from time to pixels (or points) and vice versa to determin their frame and bounds. These calculations need to be precise and uniform throughout the components so that everything will fit together nicely.
This could be achived by using an easly accessible singleton objet, but that would mean an user of the `TimetableView` class would be left behind with an indestructible object in their apps memory.
I decided to put all properties that influence these frame defining conversion into this category, so they are some kind of logically grouped together, thereby i maybe won't lose overview.
*/
public protocol TimetableLayoutDelegate {
    
    /// A float value that defines by how many points a minute is represented.
    var pointsPerMinute: CGFloat { get set }
    /// The date interval the timetable is representing.
    var intervalOfTimetable: DateInterval { get set }
}
