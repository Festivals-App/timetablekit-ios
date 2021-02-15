//
//  ScrollingCoordinator.swift
//  TimetableKit
//
//  Created by Simon Gaus on 27.09.20.
//

import UIKit


/**
 The `ScrollingCoordinator` class is responsible for coordinating the scrolling of the collection views and the table view.
 
 The scrolling coordinator manages all scrolling related calculations. It will send a notification if the scroll views should change their content offset and is the starting point if we need to intervene in the scrolling behaviour.
 */
class ScrollingCoordinator: NSObject, UIScrollViewDelegate {
    
    var timetable: TimetableView
    var scaleCoordinator: ScaleCoordinator!
    
    lazy var breakIntervals: [DateInterval] = { return calculateBreakIntervals(for: timetableDays) }()
    lazy var timetableDays: [DateInterval] = { return calculateTimetableDays() }()
    
    var skipDidEndScrollingMethodOnce = false
    
    required init(with timetable: TimetableView) {
        
        self.timetable = timetable
        super.init()
    }
    
    func set(_ contentOffset: CGPoint, animated: Bool) {
        
        willScroll(to: contentOffset.x)
        
        if animated {
            set(contentOffset, 0.5)
        }
        else {
            UIView.performWithoutAnimation { set(contentOffset) }
        }
    }
    
    func set( _ contentOffset: CGPoint, _ duration: TimeInterval) {
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseInOut) { self.set(contentOffset) }
    }
    
    func set( _ contentOffset: CGPoint) {
        
        let collectionViewOffset = CGPoint.init(x: contentOffset.x, y: 0)
        let tableViewOffset = CGPoint.init(x: 0, y: contentOffset.y)
        
        timetable.timescale.contentOffset = collectionViewOffset
        timetable.rowController.forEach({ $0.collectionView.contentOffset = collectionViewOffset })
        timetable.tableView.contentOffset = tableViewOffset
        
        // if the content offset changed based on the dragging of the navigation scrollview
        // we dont want to set the content offset here, if it was set programmatically we want to
        // change it.
        if !timetable.navigationScrollView.contentOffset.equalTo(contentOffset) {
            timetable.navigationScrollView.contentOffset = contentOffset
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        set(scrollView.contentOffset, animated: false)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        if !skipDidEndScrollingMethodOnce { scrollingDidEnd() }
        else { skipDidEndScrollingMethodOnce = false }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if !scaleCoordinator.isScaling {
            
            // this method is fired when the user lifts his/her finger from the screen (or the finger left the touch area of the screen)
            // we want to check the content offset the subsequent scrolling will lead to (target offset)
            // if the target offset will be above (or below) a trashhold we wannt to scroll (segue) to the opposit end of the pause
            // if the target offset will be in-between segue offset and another offset (but above or below the pause offset)
            // we want to scroll only to the pause offset
            //
            // start is synonym with left and end is synonym with rigth when we talk about the offset
            let width = timetable.frame.size.width
            let currentOffset = timetable.navigationScrollView.contentOffset.x
            let targetOffset = targetContentOffset.pointee.x
            let pointsPerMinute = scaleCoordinator.pointsPerMinute
            let timetableStartDate = timetable.dataSource.interval(for: timetable).start
  
            for pause in breakIntervals {
                
                let startOffset = CGFloat(pause.start.timeIntervalSince(timetableStartDate)/60.0) * pointsPerMinute
                let endOffset = CGFloat(pause.end.timeIntervalSince(timetableStartDate)) * pointsPerMinute
                
                // adjust left and right offsets, the left offset needs to be less,
                // so there is a little gap beween the last event tile and the timetables right border
                // and the right needs to be a highter, so there is a gap between the first event tile
                // and the timetables left border..
                let adjustedStartOffset = startOffset - (width*0.8)
                let adjustedEndOffset = endOffset - (width*0.2)
                
                // we check if the target offset is inside the pause or bounce trashholds
                // if it's not, we dont need to do anything here (yeay)
                if adjustedStartOffset < targetOffset && targetOffset < adjustedEndOffset {
                    
                    // here we need to check the left bounds of a pause,
                    // the trashhold offset that will lead to an scroll to the next "day", e.g. to the end the pause
                    // we trigger a segue if 70% of the pause will be visible
                    let triggerSegueToStartOffset = startOffset - (width*0.3)
                    let triggerSegueToEndOffset = endOffset - (width*0.7)
                    
                    let currentOffset_YAxis = timetable.navigationScrollView.contentOffset.y
                    let isLeft = targetOffset.isNearer(to: adjustedStartOffset, than: adjustedEndOffset)
                    
                    // check if the target offset is inside the trashholds which will lead to a segue to the other end of the pause
                    if (triggerSegueToStartOffset < targetOffset && targetOffset < triggerSegueToEndOffset) {
                        
                        // we need to scroll to the other side of the pause manually
                        // (else the current velocity would be used for scrolling to the other side which is impractical for low velocities)
                        // so we stop at the current offset and animate the content offset from now on
                        // we set skipDidEndScrollingMethodOnce to YES because we don't want scrollingDidEnd to be executed
                        // (which is normally called when the scrolling ends and would be triggerd here by setting the target offset to the current offset)
                        targetContentOffset.pointee.x = (isLeft) ? adjustedEndOffset : adjustedStartOffset
                    }
                    // else we only scroll to bounce trashholds
                    else {
                        // if the scroll view scroll after this method else everything is handled in the scrollingDidEnd method
                        if (targetOffset != currentOffset) {
                            let deltaOffset = velocity.x*15
                            var newXValue = (currentOffset+deltaOffset < 15.0) ? targetOffset : currentOffset+deltaOffset
                            
                            if isLeft {
                                if currentOffset < adjustedStartOffset {
                                    newXValue = adjustedStartOffset
                                }
                            }
                            else {
                                if currentOffset > adjustedEndOffset {
                                    newXValue = adjustedEndOffset
                                }
                            }
                            
                            if abs(velocity.x) > 2.0 {
                                targetContentOffset.pointee.x = newXValue
                            }
                            else {
                                targetContentOffset.pointee.x = currentOffset
                                set(CGPoint.init(x: newXValue, y: currentOffset_YAxis), 0.2)
                            }
                        }
                        break
                    }
                    break
                }
            }
            
        }
    }
    
    func scrollingDidEnd() {
        
        if !scaleCoordinator.isScaling {
            
            // this method is fired when the user lifts his/her finger from the screen (or the finger left the touch area of the screen)
            // we want to check the content offset the subsequent scrolling will lead to (target offset)
            // if the target offset will be above (or below) a trashhold we wannt to scroll (segue) to the opposit end of the pause
            // if the target offset will be in-between segue offset and another offset (but above or below the pause offset)
            // we want to scroll only to the pause offset
            //
            // start is sysnonym with left and end is synonym with rigth when we talk about the offset
            let width = timetable.frame.size.width
            let currentOffset = timetable.navigationScrollView.contentOffset.x
            let pointsPerMinute = scaleCoordinator.pointsPerMinute
            let timetableStartDate = timetable.dataSource.interval(for: timetable).start
            
            for pause in breakIntervals {
                
                let startOffset = CGFloat(pause.start.timeIntervalSince(timetableStartDate)/60.0) * pointsPerMinute
                let endOffset = CGFloat(pause.end.timeIntervalSince(timetableStartDate)) * pointsPerMinute
                
                // adjust left and right offsets, the left offset needs to be less,
                // so there is a little gap beween the last event tile and the timetables right border
                // and the right needs to be a highter, so there is a gap between the first event tile
                // and the timetables left border..
                let adjustedStartOffset = startOffset - (width*0.8)
                let adjustedEndOffset = endOffset - (width*0.2)
                
                // we check if the target offset is inside the bounce trashholds
                // if it's not, we dont need to do anything here (yeay)
                if (adjustedStartOffset < currentOffset && currentOffset < adjustedEndOffset) {
                
                    let currentOffset_YAxis = timetable.navigationScrollView.contentOffset.y
                    let isLeft = currentOffset.isNearer(to: adjustedStartOffset, than: adjustedEndOffset)
                    let offsetToScrollTo = CGPoint.init(x: (isLeft) ? adjustedStartOffset : adjustedEndOffset, y: currentOffset_YAxis)
                    set(offsetToScrollTo, 0.3)
                    skipDidEndScrollingMethodOnce = true
                }
            }
        }
    }
    
    func willScroll(to XAxisOffset: CGFloat) {
        
        let currentOffsetX = XAxisOffset+timetable.tableView.frame.size.width/2.0
        let timetableStartDate = timetable.dataSource.interval(for: timetable).start
        let pointsPerMinute = scaleCoordinator.pointsPerMinute
        let secondsTillStart = (currentOffsetX/pointsPerMinute)*60.0
        let offsetAsDate = timetableStartDate.addingTimeInterval(TimeInterval(secondsTillStart))
        timetableDays.enumerated().forEach({ if $0.1.contains(offsetAsDate) { timetable.horizontalControl.selectSegment(at: $0.0) } })
    }
    
    func offsetIsNearer(to leftBound: CGFloat, _ offset: CGFloat, or rightBound: CGFloat) -> Bool {
        return ((offset - leftBound) <= (rightBound - offset))
    }
    
    func calculateBreakIntervals(for timetableDays: [DateInterval]) -> [DateInterval] {
        
        if timetableDays.count < 2 { return [] }
        
        var breaks = [DateInterval]()
        var previousEndDate: Date?
        
        for interval in timetableDays {
            if let endDate = previousEndDate {
                breaks.append(DateInterval(start: endDate, end: interval.start))
            }
            previousEndDate = interval.end
        }
        return breaks
    }
    
    func calculateTimetableDays() -> [DateInterval] {
    
        let numberOfDays = timetable.dataSource.numberOfDays(in: timetable)
        var days = [DateInterval]()
        for index in 0..<numberOfDays {
            days.append(timetable.dataSource.timetableView(timetable, intervalForDayAt: index))
        }
        return days
    }
}

extension CGFloat {
    
    func isNearer(to leftBound: CGFloat, than rightBound: CGFloat) -> Bool {
        return ((self - leftBound) <= (rightBound - self))
    }
}
