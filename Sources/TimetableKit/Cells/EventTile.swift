//
//  EventTile.swift
//  TimetableKit
//
//  Created by Simon Gaus on 25.09.20.
//

import UIKit

extension Notification.Name {
    static let eventTileWasTapped = Notification.Name("SGEventTileWasTappedPressedNotification")
}

/// A tile view representing an event in the timetable.
class EventTile: UICollectionViewCell {
    
    static let cellIdentifier = "eventTileReuseIdentifier"
    
    var event: TimetableEvent? {
        didSet {
            if let event = event {
                textLabel.numberOfLines = event.title.components(separatedBy: " ").count
                textLabel.text = event.title
            }
        }
    }
    
    var textLabel: InsetLabel!
    
    private var timeFormatter: TimeFormatter = TimeFormatter.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = false
        clipsToBounds = true
        
        textLabel = InsetLabel.init(frame: frame)
        textLabel.font = UIFont.boldSystemFont(ofSize: 15.0)
        textLabel.textAlignment = .center
        textLabel.numberOfLines = 3
        contentView.addSubview(textLabel)
        textLabel.fit(to: contentView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(EventTile.cellWasTapped(with:)), name: .tapWasRegistered, object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        event = nil
        textLabel.text = nil
    }
    
    #warning("Check if this is still needed")
    /// https://rbnsn.me/uicollectionviewcell-auto-layout-performance
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return layoutAttributes
    }
    
    @objc func cellWasTapped(with notification: NSNotification) {
        
        if let recognizer = notification.object as? UIGestureRecognizer {
            let touchPoint = recognizer.location(in: self)
            if touchPoint != .zero && self.bounds.contains(touchPoint) {
                NotificationCenter.default.post(name: .eventTileWasTapped, object: self)
            }
        }
    }
}
