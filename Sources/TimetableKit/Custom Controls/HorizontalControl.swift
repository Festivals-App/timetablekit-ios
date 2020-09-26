//
//  File.swift
//  
//
//  Created by Simon Gaus on 03.07.20.
//

import UIKit

@objc protocol HorizontalControlDelegate {
    
    func selectedSegment(at index: Int)
}

class HorizontalControl: UIView {
    
    @IBOutlet var delegate: HorizontalControlDelegate!
    var numberOfSegments = Int(0)
    var selectedSegmentIndex = Int(0)
    var numberOfSegmentsToDisplay = Int(3)
    var textColor = UIColor.darkText
    var highlightTextColor = UIColor.red
    var font = UIFont.systemFont(ofSize: UIFont.systemFontSize)
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with items: [String]) {
        
    }
    
    func selectSegment(at index: Int) {
        
    }
    
    
}

protocol HorizontalControlSegmentDelegate {
    
    func clicked(at index: Int)
}

class HorizontalControlSegment: UIView {
    
    var delegate: HorizontalControlSegmentDelegate!
    var index = Int(0)
    
    var textColor = UIColor.darkText { didSet { updateAppearance() } }
    var highlightTextColor = UIColor.red { didSet { updateAppearance() } }
    var widthConstraint: NSLayoutConstraint?
    
    private var label: UILabel!
    private var tapGestureRecognizer: UITapGestureRecognizer!
    private var selected = false { didSet { updateAppearance() } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupSubviews() {
        label = UILabel.init(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .light)
        label.numberOfLines = 0
        label.textAlignment = .center
        self.addSubview(label)
        let _ = label.fit(to: self)
    }
    
    private func setupGestureRecognizer() {
        tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handle(tap:)))
    }
    
    @objc func handle(tap: UITapGestureRecognizer) {
        delegate.clicked(at: index)
    }
    
    private func updateAppearance() {
        label.textColor = selected ? textColor : highlightTextColor
    }
    
    func set(selected: Bool) {
        self.selected = selected
        updateAppearance()
    }
    
    func set(text: String) {
        label.text = text
    }
    
    func set(font: UIFont) {
        label.font = font
    }
}
