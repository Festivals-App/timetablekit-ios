//
//  ScaleCoordinator.swift
//  TimetableKit
//
//  Created by Simon Gaus on 27.09.20.
//

import UIKit

let kMaxPointsPerMinute: CGFloat = 5.0
let kDefaultPointsPerMinute: CGFloat = 2.1
let kMinPointsPerMinute: CGFloat = 1.0
let kDefaultTableViewCellHeigth: CGFloat = 55+kTimetableRowLabelHeight

/**
 The `ScaleCoordinator` class is responsible for coordinating the scale of the collection views and the tablew view.

 The scaling coordinator manages the resizing of the timetable elements. It will inform the `ScrollingCoordinator` about needed scrolling after scale updates.
 */
class ScaleCoordinator: NSObject, UIGestureRecognizerDelegate, TimetableLayoutDelegate {
    
    var isScaling: Bool = false
    
    var pointsPerMinute: CGFloat = kDefaultPointsPerMinute
    lazy var intervalOfTimetable: DateInterval = {
        guard let timetable = timetable else { return DateInterval() }
        guard let dataSource = timetable.dataSource else { return DateInterval() }
        return dataSource.interval(for: timetable)
    }()
    
    weak var timetable: TimetableView?
    weak var scrollingCoordinator: ScrollingCoordinator?
    
    var pinchGestureRecognizer: UIPinchGestureRecognizer!
    
    var pinchCenter: CGPoint = .zero
    var pinchCenterInMinutes: CGFloat = 0
    
    init(with timetable: TimetableView, and scrollingCoordinator: ScrollingCoordinator) {
        
        super.init()
        
        self.timetable = timetable
        self.scrollingCoordinator = scrollingCoordinator
        
        // we want to recognize pinching gestures for scalling the timetable
        // so to ensure that a pinch gesture that is not performed perfectly (e.g. both fingers hit the screen at the same time)
        // gets recognized we set delaysContentTouches to YES, see UIScrollView docs for detailes
        // about the effect of this value.
        timetable.navigationScrollView.delaysContentTouches = true
        
        pinchGestureRecognizer = UIPinchGestureRecognizer.init(target: self, action: #selector(pinched(recognizer:)))
        pinchGestureRecognizer.delegate = self
        timetable.addGestureRecognizer(pinchGestureRecognizer)
    }
    
    @objc func pinched(recognizer: UIPinchGestureRecognizer) {
        
        if recognizer.numberOfTouches >= 2 {
            switch recognizer.state {
            case .began:
                pinchingDidStart(recognizer: recognizer)
            case .changed:
                pinchingWithChange(recognizer: recognizer)
            default:
                pinchingDidEnd(recognizer: recognizer)
            }
        }
        else {
            if recognizer.state != .began && recognizer.state != .changed {
                pinchingDidEnd(recognizer: recognizer)
            }
        }
    }
    
    func pinchingDidStart(recognizer: UIPinchGestureRecognizer) {
        
        guard let timetable = timetable else { return }
        
        isScaling = true
        
        // save the pinch center for later reconstructing the content offset
        pinchCenter = recognizer.location(in: timetable.tableView)
        
        // as the widht of the timetable (well contentSize) will change during the scaling
        // we need a way to save the relativ scroll offset not the absolut content offset (then the pinch center would suffice)
        // to do that we calcuate at what "minute" the  pinch center is (x-axis value) and save that value
        // to later get the content offset for the pinch center
        let offsetToTableViewLeftEdge = pinchCenter.x
        let offsetToTimetableLedtEdge = timetable.navigationScrollView.contentOffset.x
        let pinchCenterOffsetToTimeTableToLeftEdge = offsetToTableViewLeftEdge + offsetToTimetableLedtEdge
        pinchCenterInMinutes = pinchCenterOffsetToTimeTableToLeftEdge/pointsPerMinute
        
        scaleTimetableIfNeeded(recognizer: recognizer)
    }
    
    func pinchingWithChange(recognizer: UIPinchGestureRecognizer) {
        
        scaleTimetableIfNeeded(recognizer: recognizer)
    }
    
    func pinchingDidEnd(recognizer: UIPinchGestureRecognizer) {
        
        scaleTimetableIfNeeded(recognizer: recognizer)
        isScaling = false
    }
    
    func scaleTimetableIfNeeded(recognizer: UIPinchGestureRecognizer) {
        
        guard let timetable = timetable else { return }
        
        DispatchQueue.global(qos: .userInteractive).sync {
            let dampedScale = recognizer.scale
            
            let oldPointsPermMinute = pointsPerMinute
            let newPointsPerMinute = oldPointsPermMinute*dampedScale
            if (newPointsPerMinute >= kMinPointsPerMinute && newPointsPerMinute <= kMaxPointsPerMinute) {
                
                let width = intervalOfTimetable.duration.minutes.floaty*pointsPerMinute
                let canShrinkHorizontal = (width >= timetable.tableView.frame.size.width)
                if canShrinkHorizontal {
                    pointsPerMinute = newPointsPerMinute
                    recognizer.scale = 1.0
                    let height = timetable.tableView.contentSize.height
                    scaleTimetable(to: width, height)
                }
            }
        }
    }
    
    func scaleTimetable(to width: CGFloat, _ height: CGFloat) {
        
        guard let timetable = timetable else { return }
        
        // see comment in pinchingDidStart: for an explanation ...
        let pinchCenterOffsetToTimeTableToLeftEdge = pinchCenterInMinutes * pointsPerMinute
        let offsetToTableViewLeftEdge = pinchCenter.x
        var newContentOffsetXAxis = pinchCenterOffsetToTimeTableToLeftEdge-offsetToTableViewLeftEdge
        
        // some bound checking.
        // we dont want to exceed the bounds of the scrollable ontentn when we scale at the
        // edges of the timetable view.
        let widhtOfTimetable = pointsPerMinute * intervalOfTimetable.duration.minutes.floaty
        #warning("Normalize if we use timetable.frame or timetable.tableView.frame")
        let maxOffset = widhtOfTimetable - timetable.frame.size.width
        if newContentOffsetXAxis < 0.0 { newContentOffsetXAxis = 0.0 }
        if newContentOffsetXAxis > maxOffset { newContentOffsetXAxis = maxOffset }
        let navigationContentOffset = CGPoint.init(x: newContentOffsetXAxis, y: timetable.navigationScrollView.contentOffset.y)
        
        DispatchQueue.main.async { [weak self] in
            timetable.navigationScrollView.contentSize = CGSize.init(width: width, height: height)
            timetable.timescale.pointsPerMinute = self?.pointsPerMinute ?? 0
            timetable.rowController.forEach({ $0.collectionView.reloadData() })
            timetable.setNeedsLayout()
            self?.scrollingCoordinator?.set(navigationContentOffset, animated: false)
        }
    }
    
    #warning("Maybe this method has no effect, but it's cheap. Investigate further.")
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // the pan gesture recognizer has a maximum number of touches set to 1 so if either
        // of the gesture recognizers has two touches it must be the pinch gesture recognizer
        // and a pinch gesture is favoured over a pan gesture and we dont want simultaneous gestures.
        // the delegate of the pan recognizer could return YES, than it's pointless...
        return !(gestureRecognizer.numberOfTouches == 2 || otherGestureRecognizer.numberOfTouches == 2);
    }
}
