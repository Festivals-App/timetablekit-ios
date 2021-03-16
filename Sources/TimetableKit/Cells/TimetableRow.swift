//
//  TimetableRow.swift
//  TimetableKit
//
//  Created by Simon Gaus on 25.09.20.
//

import UIKit

/// The heigth of the rows tite label.
let kTimetableRowLabelHeight: CGFloat = 45

/// The `TimetableRow` class is a concrete `UITableViewCell` subclass.
///
/// The content of the row is managed by an instance of the `TimetableRowController` class. When the cell is prepared by the table view data source the row controllers view is set as hostedView.
/// 
class TimetableRow: UITableViewCell {
    
    static let cellIdentifier = "timetableRowReuseIdentifier"
    
    var hostedView: UIView! {
        didSet {
            if hostedView != nil {
                contentView.addSubview(hostedView)
                hostedView.fit(to: contentView, leading: 0, trailing: 0, top: kTimetableRowLabelHeight, bottom: 0)
            }
        }
    }
    var titleLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel = UILabel.init(frame: .infinite)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 15.0, weight: .light)
        contentView.addSubview(titleLabel)
        titleLabel.stickToTop(of: contentView, height: kTimetableRowLabelHeight, sideMargin: 15.0)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        hostedView.removeAllConstraints()
        hostedView.removeFromSuperview()
        hostedView = nil
    }
    
}
