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
    var event: TimetableEvent?
    
    private var textLabel: InsetLabel!
    private var timeFormatter: TimeFormatter!
    private var tileState: EventTileState = .showTitle
    private var getsLongPressed = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        isUserInteractionEnabled = false#
        clipsToBounds = true
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
}
