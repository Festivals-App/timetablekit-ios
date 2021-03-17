//
//  File.swift
//
//  Created by Simon Gaus on 20.05.20.
//

import UIKit

#warning("Remove and make delegate default")
/// The style of the timetable view.
public enum TimetableStyle {
    /// A dark timetable view style.
    case dark
    /// A light timetable view style.
    case light
    /// Style is based on system settings.
    case system
    /// The timetable view style is determined by the brightness of the screen.
    case automatic
    /// The timetable view style is determined the appearance delegate of the timetable.
    case custom
}

/// The brightness value of the screen under which the screen is considered "dark".
let kBrightnessTreshold: CGFloat = 0.35

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
 * The timetable view is meant for displaying events that have a duration of hours not days. If you need to display lengthy events please consider to use a calendar view.
 
 */
public class TimetableView: TimetableBaseView {

    public var dataSource: TimetableDataSource!
    public var appearanceDelegate: TimetableAppearanceDelegate?
    
    private(set) var style: TimetableStyle = .automatic
    private var automaticStyle: TimetableStyle = .automatic
    private var proxyAppearanceDelegate: TimetableAppearanceDelegate!
    
    private var scrollingCoordinator: ScrollingCoordinator!
    private var scaleCoordinator: ScaleCoordinator!
    
    private var reloadCoverView: UIImageView!

    public init(_ frame: CGRect, with style: TimetableStyle) {
        
        super.init(frame: frame)
        self.style = style
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.scrollingCoordinator = ScrollingCoordinator.init(with: self)
        self.navigationScrollView.delegate = self.scrollingCoordinator
        
        self.automaticStyle = (UIScreen.main.brightness > kBrightnessTreshold) ? .light : .dark
        
        self.proxyAppearanceDelegate = AppearanceDelegateProxy.init(with: self)
        self.scaleCoordinator = ScaleCoordinator.init(with: self, and: self.scrollingCoordinator)
        self.scrollingCoordinator.scaleCoordinator = self.scaleCoordinator
        
        NotificationCenter.default.addObserver(self, selector: #selector(brightnessChanged(_:)), name: UIScreen.brightnessDidChangeNotification, object: nil)
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        automaticStyle = (UIScreen.main.brightness > kBrightnessTreshold) ? .light : .dark
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()

        tableView.backgroundColor = proxyAppearanceDelegate.timetabelBackgroundColor()
        
        DispatchQueue.main.async { [self] in
            
            let height = tableView.contentSize.height
            let widht = CGFloat(scaleCoordinator.intervalOfTimetable.duration/60.0) * scaleCoordinator.pointsPerMinute
            navigationScrollView.contentSize = CGSize(width: widht, height: height)
            tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: dataSource.bottomPadding(for: self), right: 0)
            navigationScrollView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: dataSource.bottomPadding(for: self), right: 0)
        }
    }
    
    /// Reloads the rows, tiles and sections of the timetable view.
    ///
    /// Call this method to reload all the data that is used to construct the timetable, including cells, section headers, index arrays, tiles and so on.
    public func reloadData() {
        
        reloadData(animated: false)
    }
    
    public func reloadData(animated: Bool = false) {
        
        DispatchQueue.main.async { [self] in
            
            var muteTitleArray = [String]()
            for index in 0..<dataSource.numberOfDays(in: self) {
                muteTitleArray.append(dataSource.timetableView(self, titleForDayAt: index))
            }
            
            horizontalControl.configure(with: muteTitleArray)
            horizontalControl.backgroundColor = proxyAppearanceDelegate.timetabelBackgroundColor()
            horizontalControl.textColor = proxyAppearanceDelegate.timetabelBackgroundColor().contrastingColor()
            horizontalControl.highlightTextColor = proxyAppearanceDelegate.timetabelEventTileHighlightColor()
            horizontalControl.font = UIFont.systemFont(ofSize: 16.0, weight: .light)
            let days = dataSource.numberOfDays(in: self)
            horizontalControl.numberOfSegmentsToDisplay = (days > 3 ) ? 3 : days
            horizontalControl.delegate = self
            
            rowController = [TimetableRowController]()
            rowControllerByIndexPath = [IndexPath : TimetableRowController]()
            unusedRowController = Set.init()
            
            if animated {
                
                reloadCoverView = UIImageView.init(frame: bounds)
                reloadCoverView.image = self.capture()
                addSubview(reloadCoverView)
                
                tableView.backgroundColor = proxyAppearanceDelegate.timetabelSectionHeaderColor()
                
                timescale.interval = dataSource.interval(for: self)
                timescale.timescaleColor = proxyAppearanceDelegate.timetabelBackgroundColor()
                timescale.timescaleStrokeColor = proxyAppearanceDelegate.timetabelBackgroundColor().contrastingColor()
                timescale.reloadData()
                
                tableView.reloadData {
                    self.scrollingCoordinator.set(self.navigationScrollView.contentOffset, animated: false)
                    UIView.animate(withDuration: 0.5) {
                        self.reloadCoverView.alpha = 0.0
                    } completion: { success in
                        self.reloadCoverView.removeFromSuperview()
                        self.reloadCoverView = nil
                    }
                }
            }
            else {
                
                tableView.backgroundColor = proxyAppearanceDelegate.timetabelSectionHeaderColor()
                
                timescale.interval = dataSource.interval(for: self)
                timescale.timescaleColor = proxyAppearanceDelegate.timetabelBackgroundColor()
                timescale.timescaleStrokeColor = proxyAppearanceDelegate.timetabelBackgroundColor().contrastingColor()
                timescale.reloadData()
                
                tableView.reloadData {
                    self.scrollingCoordinator.set(self.navigationScrollView.contentOffset, animated: false)
                }
            }
        }
    }
    
    /// Transitions to the specified timetable view style.
    /// - Parameters:
    ///   - style: The new timtable view stlye.
    ///   - animated: If `true`, the style is changed using an animation. Defaults to `true`.
    public func transition(to style: TimetableStyle, animated: Bool = true) {
        
        self.style = style
        reloadData(animated: animated)
    }
    
    @objc func brightnessChanged(_ notification: Notification) {

    }
    
    func recycledOrNewRowController() -> TimetableRowController {
        if unusedRowController.count > 1 {
            let reusedController = unusedRowController.randomElement()!
            unusedRowController.remove(reusedController)
            return reusedController
        }
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        
        let contentViewController = TimetableRowController.init(collectionViewLayout: layout)
        contentViewController.layoutDelegate = scaleCoordinator
        contentViewController.appearanceDelegate = proxyAppearanceDelegate
        rowController.append(contentViewController)
        return contentViewController
    }
}

extension TimetableView: HorizontalControlDelegate {
    
    func selectedSegment(at index: Int) {
        
        let timetableInterval = dataSource.interval(for: self)
        let intervalForSelectedDay = dataSource.timetableView(self, intervalForDayAt: index)
        
        let currentOffset_x = navigationScrollView.contentOffset.x
        var startOffset_x = DateInterval.safely(start: timetableInterval.start, end: intervalForSelectedDay.start).duration.minutes.floaty*scaleCoordinator.pointsPerMinute
        var endOffset_x = DateInterval.safely(start: timetableInterval.start, end: intervalForSelectedDay.end).duration.minutes.floaty*scaleCoordinator.pointsPerMinute
    
        let halfTimetabelWidth = frame.size.width/2.0
        endOffset_x = endOffset_x - halfTimetabelWidth
        startOffset_x = startOffset_x - halfTimetabelWidth
        
        #warning("Add code comments for explanation (offset logic)")
        if (!(currentOffset_x >= startOffset_x && currentOffset_x <= endOffset_x+halfTimetabelWidth)) {
            
            if (currentOffset_x < startOffset_x) {
                
                scrollingCoordinator.set(CGPoint(x: startOffset_x, y: tableView.contentOffset.y), animated: true)
            }
            else {
                scrollingCoordinator.set(CGPoint(x: endOffset_x, y: tableView.contentOffset.y), animated: true)
            }
        }
    }
}

let kTimetableSectionHeaderHeight: CGFloat = 40

extension TimetableView: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: TimetableRow.cellIdentifier, for: indexPath) as! TimetableRow

        let rowController = recycledOrNewRowController()
        rowController.events = dataSource.timetableView(self, eventsForRowAt: indexPath)
        rowControllerByIndexPath[indexPath] = rowController
        
        cell.backgroundColor = proxyAppearanceDelegate.timetabelBackgroundColor()
        cell.contentView.backgroundColor = proxyAppearanceDelegate.timetabelRowHeaderColor()
        cell.titleLabel.textColor = proxyAppearanceDelegate.timetabelRowHeaderColor().contrastingColor()
        cell.hostedView = rowController.view
        cell.titleLabel.text = dataSource.timetableView(self, titleForRowAt: indexPath)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.timetableView(self, numberOfRowsIn: section)
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.numberOfSections(in: self)
    }
    
    public func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rowController = rowControllerByIndexPath[indexPath]
        if rowController != nil {
            rowController!.view = nil
            rowControllerByIndexPath.removeValue(forKey: indexPath)
            unusedRowController.insert(rowController!)
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return kDefaultTableViewCellHeigth
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return kTimetableSectionHeaderHeight
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let label = UILabel.init()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .semibold)
        label.text = dataSource.timetableView(self, titleForHeaderOf: section)
        label.backgroundColor = proxyAppearanceDelegate.timetabelSectionHeaderColor()
        label.textColor = proxyAppearanceDelegate.timetabelBackgroundColor().contrastingColor()//.withAlphaComponent(0.5)
        return label
    }
}

extension Notification.Name {

    static let tapWasRegistered = Notification.Name("SGTapWasRegisteredNotification")
    static let longPressWasRegistered = Notification.Name("SGLongPressWasRegisteredNotification")
}

public class TimetableBaseView: UIView {
    
    var horizontalControl: HorizontalControl!
    var timescale: TimescaleView!
    var tableView: SGTableView!
    var currentTimeScrollView: UIScrollView!
    var navigationScrollView: UIScrollView!
    
    var tapGestureRecognizer: UITapGestureRecognizer!
    var longPressGestureRecognizer: UILongPressGestureRecognizer!
    
    var rowController = [TimetableRowController]()
    var unusedRowController: Set<TimetableRowController> = Set.init()
    lazy var rowControllerByIndexPath: [IndexPath: TimetableRowController] = { return [IndexPath: TimetableRowController]() }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
     
    private func setupView() {
        
        tableView = SGTableView.init(frame: .infinite, style: .grouped)
        tableView.register(TimetableRow.self, forCellReuseIdentifier: TimetableRow.cellIdentifier)
        tableView.allowsSelection = false
        tableView.showsVerticalScrollIndicator = false
        tableView.showsHorizontalScrollIndicator = false
        tableView.sectionFooterHeight = 0.0
        tableView.backgroundView = nil
        tableView.insetsContentViewsToSafeArea = false
        tableView.automaticallyAdjustsScrollIndicatorInsets = false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.1))
        self.addSubview(tableView)
        tableView.fit(to: self, leading: 0.0, trailing: 0.0, top: 88.0, bottom: 0.0)
        
        horizontalControl = HorizontalControl.init(frame: .zero)
        horizontalControl.font = UIFont.systemFont(ofSize: 17.0, weight: .light)
        self.addSubview(horizontalControl)
        horizontalControl.stickToTop(of: self, height: 44.0, sideMargin: 8.0)
        
        timescale = TimescaleView.init(frame: .zero)
        self.addSubview(timescale)
        timescale.stickToTop(of: self, height: 44.0, topMargin: 44.0)
        
        currentTimeScrollView = UIScrollView.init(frame: .infinite)
        currentTimeScrollView.backgroundColor = .clear
        currentTimeScrollView.showsVerticalScrollIndicator = false
        currentTimeScrollView.showsHorizontalScrollIndicator = false
        currentTimeScrollView.automaticallyAdjustsScrollIndicatorInsets = false
        currentTimeScrollView.isOpaque = false
        currentTimeScrollView.decelerationRate = .fast
        currentTimeScrollView.panGestureRecognizer.maximumNumberOfTouches = 1
        self.addSubview(currentTimeScrollView)
        currentTimeScrollView.fit(to: self, leading: 0, trailing: 0, top: 88.0, bottom: 0)
        
        navigationScrollView = UIScrollView.init(frame: .infinite)
        navigationScrollView.backgroundColor = .clear
        navigationScrollView.showsVerticalScrollIndicator = false
        navigationScrollView.showsHorizontalScrollIndicator = false
        navigationScrollView.automaticallyAdjustsScrollIndicatorInsets = false
        navigationScrollView.isOpaque = false
        navigationScrollView.decelerationRate = .fast
        navigationScrollView.panGestureRecognizer.maximumNumberOfTouches = 1
        self.addSubview(navigationScrollView)
        navigationScrollView.fit(to: self, leading: 0, trailing: 0, top: 88.0, bottom: 0)
        
        tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(TimetableBaseView.tapped(recognizer:)))
        longPressGestureRecognizer = UILongPressGestureRecognizer.init(target: self, action: #selector(TimetableBaseView.longPress(recognizer:)))
        self.addGestureRecognizer(tapGestureRecognizer)
        self.addGestureRecognizer(longPressGestureRecognizer)
    }
    
    @objc func tapped(recognizer: UIPinchGestureRecognizer) {
        
        // views (or their controllers) that could be tapped should register
        // as observers for the 'Notification.tapWasRegistered' notification and
        // test if the touch event happend inside their bounds.
        //
        // let recognizer = notification.object as! UIPinchGestureRecognizer
        // let touchPoint = recognizer.location(in: self.myTappableView)
        // let wasTapped = self.myTappableView.bounds.contains(touchPoint)
        //
        NotificationCenter.default.post(name: .tapWasRegistered, object: recognizer)
    }
    
    @objc func longPress(recognizer: UILongPressGestureRecognizer) {
        
        // views (or their controllers) that could be long pressed should register
        // as observers for the 'SGLongPressWasRegisteredNotification' notification and
        // test if the touch event happend inside their bounds.
        //
        // let recognizer = notification.object as! UILongPressGestureRecognizer
        // let touchPoint = recognizer.location(in: self.myTappableView)
        // let wasTapped = self.myTappableView.bounds.contains(touchPoint)
        //
        switch recognizer.state {
        case .began:
            NotificationCenter.default.post(name: .longPressWasRegistered, object: recognizer)
        case .ended:
            NotificationCenter.default.post(name: .longPressWasRegistered, object: recognizer)
        default:
            break
        }
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        // hide seperators
        // doing it in setUpSubviews won't suffice...
        tableView.separatorStyle = .none
    }
}

/**
 The 'SGTableView' class adds the ability to synchronously reload the tabel view to the 'UITableView' class.
 
 There was the problem that when i tried to set the content offset of some collection views inside the table view cells directly after a call to -reloadData: the frame wont update and the collection views had still an offset of 0.
 
 - seealso: https://stackoverflow.com/questions/16071503/how-to-tell-when-uitableview-has-completed-reloaddata
 */
class SGTableView: UITableView {
    
    private var completionBlock: ( () -> Void )?
    
    /// Reloads the rows and sections of the table view and executes the completionBlock when finished.
    ///
    /// Call this method to reload all the data that is used to construct the table, including cells, section headers and footers, index arrays, and so on. For efficiency, the table view redisplays only those rows that are visible. It adjusts offsets if the table shrinks as a result of the reload. The table view’s delegate or data source calls this method when it wants the table view to completely reload its data. It should not be called in the methods that insert or delete rows, especially within an animation block implemented with calls to beginUpdates and endUpdates.
    ///
    /// - Warning: If you call this method before a previous invocation finished, the old completion block won't be executed.
    /// - seealso: https://stackoverflow.com/questions/16071503/how-to-tell-when-uitableview-has-completed-reloaddata
    /// - Parameter completion: The block to execute after the reload finished.
    func reloadData(calling completion:  @escaping () -> Void) {
        
        #if DEBUG
        if self.completionBlock != nil {
            print("Warning: Called before old completion block was executed! \(#file) Line \(#line) \(#function)")
        }
        #endif
        
        completionBlock = completion
        super.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard let block = self.completionBlock else { return }
        block()
        self.completionBlock = nil
    }
}

extension UIView {
    
    func capture() -> UIImage {

        #warning("Force unwrapp or not?")
        UIGraphicsBeginImageContext(bounds.size)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let img = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return img
    }
}
