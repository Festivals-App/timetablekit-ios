//
//  TimetableRowController.swift
//  TimetableKit
//
//  Created by Simon Gaus on 25.09.20.
//

import UIKit


/**
 The 'TimetableRowController' is a concrete 'UICollectionViewController' subclass.

 The 'SGTimetableRowController' is responsible for managing a collection view that displays events.
 The widht of the collection view and its cells (hereafter called tiles) represents the duration of the events
 and the time interval the collection view is displaying.
 
 - warning: Determin the widht of the collection view and it's tiles is quite expensive, try to avoid unneeded recalculations.
 */
class TimetableRowController: UICollectionViewController {
    
    var layoutDelegate: TimetableLayoutDelegate!
    var appearanceDelegate: TimetableAppearanceDelegate!
    var events: [TimetableEvent] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(EventTile.self, forCellWithReuseIdentifier: EventTile.cellIdentifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.clipsToBounds = false
        collectionView.backgroundColor = appearanceDelegate.timetabelRowColor()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // we will have one section for each event
        // as we use the section header (and footer) to represent the pauses between the events.
        return events.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // one event per section
        // see numberOfSectionsInCollectionView
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let tile = collectionView.dequeueReusableCell(withReuseIdentifier: EventTile.cellIdentifier, for: indexPath) as! EventTile
        tile.event = events[indexPath.section]
        tile.backgroundColor = tile.event!.isFavourite ? appearanceDelegate.timetabelEventTileHighlightColor() : appearanceDelegate.timetabelEventTileColor()
        return tile
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let durationInMinutes = events[indexPath.section].interval.duration/60.0
        return CGSize.init(width: CGFloat(durationInMinutes)*layoutDelegate.pointsPerMinute(), height: view.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        // The section header view is used to represent a pause between the diplayed events.
        // We could have used collection view cells, but this seemed a bit "messy"
        // as the collection view delegate methodes would have always to differentiate between
        // pause items and event items.
        // By doing it this way the pauses will remain some kind of non-data as it should be.
        let event = events[section]
        var durationInMinutes = 0.0
        
        // first header
        // for the first header we calculate the width of the header using
        // the start date of the timetable (which is not related to an event but given by the delegate)
        if section == 0 {
            let start = layoutDelegate.intervalOfTimetable().start
            let end = event.interval.start
            durationInMinutes = DateInterval.init(start: start, end: end).duration/60.0
        }
        // other headers
        // we calculate the width by determin the time interval between the
        // end date of the previous event and the start date of the current event.
        else {
            let previousEvent = events[section-1]
            let start = previousEvent.interval.end
            let end = event.interval.start
            durationInMinutes = DateInterval.init(start: start, end: end).duration/60.0
        }
        return CGSize.init(width: CGFloat(durationInMinutes)*layoutDelegate.pointsPerMinute(), height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        // the last section will have a footer to represend the pause between the last event
        // and the end of the interval displayed by the timetable.
        // For more information on the handling of pauses see the comments in the
        // - collectionView:layout:referenceSizeForHeaderInSection: method
        if section == self.numberOfSections(in: collectionView)-1 {
            let event = events[section]
            let start = event.interval.end
            let end = layoutDelegate.intervalOfTimetable().end
            let durationInMinutes = DateInterval.init(start: start, end: end).duration/60.0
            return CGSize.init(width: CGFloat(durationInMinutes)*layoutDelegate.pointsPerMinute(), height: collectionView.frame.size.height)
        }
        return .zero
    }
}
