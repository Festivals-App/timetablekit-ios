//
//  EventTile.swift
//  TimetableKit
//
//  Created by Simon Gaus on 25.09.20.
//

import UIKit

/// The state describing what informtion is displayed by the tile.
enum EventTileState {
    case showTitle, showTime, showTimeTillShow
}

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
    private var timeFormatter: TimeFormatter = TimeFormatter.init()
    private var tileState: EventTileState = .showTitle
    private var getsLongPressed = false
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(EventTile.cellWasLongPressed(with:)), name: .longPressWasRegistered, object: nil)
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
        tileState = .showTitle
        textLabel.text = nil
    }
    
    #warning("Check if this is still needed")
    /// https://rbnsn.me/uicollectionviewcell-auto-layout-performance
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        return layoutAttributes
    }
    
    @objc func cellWasTapped(with notification: NSNotification) {
        
        let recognizer = notification.object as! UIGestureRecognizer
        let touchPoint = recognizer.location(in: self)
        if self.bounds.contains(touchPoint) {
            switch tileState {
            case .showTitle:
                tileState = .showTime
                textLabel.numberOfLines = 3
            case .showTime:
                tileState = .showTimeTillShow
                textLabel.numberOfLines = 3
            case .showTimeTillShow:
                tileState = .showTitle
                textLabel.numberOfLines = event?.title.components(separatedBy: " ").count ?? 1
                textLabel.text = event?.title
            }
        }
    }
    
    @objc func cellWasLongPressed(with notification: NSNotification) {
        
        let recognizer = notification.object as! UILongPressGestureRecognizer
        if recognizer.state == .began {
            let touchPoint = recognizer.location(in: self)
            if self.bounds.contains(touchPoint) {
                textLabel.backgroundColor = textLabel.backgroundColor?.darker()
                getsLongPressed = true
            }
        }
        else {
            if getsLongPressed {
                textLabel.backgroundColor = textLabel.backgroundColor?.lighter()
                getsLongPressed = false
            }
        }
    }
}
