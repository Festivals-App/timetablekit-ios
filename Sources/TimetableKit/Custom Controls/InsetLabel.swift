//
//  InsetLabel.swift
//  TimetableKit
//
//  Created by Simon Gaus on 25.09.20.
//

import UIKit

/// A label that displays one or more lines of read-only text, with a customizable edge inset.
///
/// Expect from the edgeInsets this label behaves exactly as an 'UILabel' object.
class InsetLabel: UILabel {
    
    /// The distance that the text is inset from the labels bounds.
    var edgeInsets: UIEdgeInsets = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 5)
    
    override func draw(_ rect: CGRect) {
        super.drawText(in: rect.inset(by: edgeInsets))
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.width += edgeInsets.left + edgeInsets.right
        size.height += edgeInsets.top + edgeInsets.bottom
        return size
    }
}
