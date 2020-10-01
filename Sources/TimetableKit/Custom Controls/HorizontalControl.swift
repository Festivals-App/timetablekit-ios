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

class HorizontalControl: UIView, UIScrollViewDelegate, HorizontalControlSegmentDelegate {
    
    @IBOutlet var delegate: HorizontalControlDelegate!
    var numberOfSegments: Int { return segments.count }
    var selectedSegmentIndex = Int(0)
    
    var numberOfSegmentsToDisplay = Int(3)
    
    var textColor = UIColor.darkText { didSet { updateTextColor() } }
    var highlightTextColor = UIColor.red { didSet { updateTextColor() } }
    var font = UIFont.systemFont(ofSize: UIFont.systemFontSize) { didSet { updateFont() } }
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    var segments: [HorizontalControlSegment] = [HorizontalControlSegment]()
    var containerViewWidthConstraint: NSLayoutConstraint!
    
    var selectedIndex: Int = 0
    var widthPerElement: CGFloat = 0
    var isScrolling: Bool = false
    
    convenience init(frame: CGRect, and items: [String]) {
        self.init(frame: frame)
        configure(with: items)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(with items: [String]) {
        
        scrollView = UIScrollView.init(frame: bounds)
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        addSubview(scrollView)
        let _ = scrollView.fit(to: self)
        
        contentView = UIView.init(frame: bounds)
        scrollView.addSubview(contentView)
        let _ = contentView.fit(to: scrollView)
        let heightsConstraint_container = contentView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1.0)
        heightsConstraint_container.isActive = true
        containerViewWidthConstraint = contentView.widthAnchor.constraint(equalToConstant: 0.0)
        containerViewWidthConstraint.isActive = true
        
        let numberOfItems = items.count
        let maxNumSegments = numberOfSegmentsToDisplay
        let currentWidthPerElement =  (numberOfItems > maxNumSegments) ? frame.size.width/CGFloat(maxNumSegments) : frame.size.width/CGFloat(numberOfItems)
        
        var leftAnchor_content = contentView.leadingAnchor
        
        NSLog("configure(with items: %@), numberOfSegments: %lu, subviews: %@", items, numberOfItems, scrollView.subviews)
        
        var newSegments: [HorizontalControlSegment] = [HorizontalControlSegment]()
        for index in 0..<numberOfItems {
            
            NSLog("NEW SEGMENT")
            
            let cell = HorizontalControlSegment.init(frame: bounds)
            cell.delegate = self
            contentView.addSubview(cell)
            let leadingConstraint_cell = cell.leadingAnchor.constraint(equalTo: leftAnchor_content)
            let topConstraint_cell = cell.topAnchor.constraint(equalTo: contentView.topAnchor)
            let bottomConstraint_cell = cell.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
            let widthConstraint_cell = cell.widthAnchor.constraint(equalToConstant: currentWidthPerElement)
            leadingConstraint_cell.isActive = true
            topConstraint_cell.isActive = true
            bottomConstraint_cell.isActive = true
            widthConstraint_cell.isActive = true
            
            cell.widthConstraint = widthConstraint_cell
            leftAnchor_content = cell.trailingAnchor
            
            cell.font = font
            cell.textColor = textColor
            cell.highlightTextColor = highlightTextColor
            cell.text = items[index]
            cell.selected = (index == selectedIndex)
            cell.index = index
            newSegments.append(cell)
        }
        
        segments = newSegments
        widthPerElement = 1.0
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let scrollView = scrollView else { return }
        
        let offsetInNumberOfSegments = scrollView.contentOffset.x/widthPerElement
        let oldWidth = widthPerElement
        NSLog("tttt- - > numberOfSegments: %lu, subviews: %@", numberOfSegments, scrollView.subviews)
        if numberOfSegments > 0 {
            let maxNumSegments = numberOfSegmentsToDisplay
            var newWidthPerElement = frame.size.width/CGFloat(numberOfSegments)
            if numberOfSegments > maxNumSegments { newWidthPerElement = frame.size.width/CGFloat(maxNumSegments) }
            if oldWidth != newWidthPerElement {
                containerViewWidthConstraint.constant = CGFloat(numberOfSegments)*newWidthPerElement
                scrollView.contentSize = CGSize.init(width: CGFloat(numberOfSegments)*newWidthPerElement, height: frame.size.height)
                segments.forEach({ $0.widthConstraint!.constant = newWidthPerElement })
                var scrollBounds = scrollView.bounds
                scrollBounds.origin =  CGPoint.init(x: CGFloat(offsetInNumberOfSegments)*newWidthPerElement, y: 0.0)
                scrollView.bounds = scrollBounds
                widthPerElement = newWidthPerElement
            }
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        isScrolling = true
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(scrollViewDidEndScrollingAnimation(_:)), with: scrollView, afterDelay: 0.3)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        let fRemainder = CGFloat(fmodf(Float(scrollView.contentOffset.x), Float(widthPerElement)))
        if fRemainder < widthPerElement/2.0 {
            scrollView.setContentOffset(CGPoint.init(x: scrollView.contentOffset.x-fRemainder, y: 0.0), animated: true)
        }
        else {
            scrollView.setContentOffset(CGPoint.init(x: scrollView.contentOffset.x+(widthPerElement-fRemainder), y: 0.0), animated: true)
        }
        isScrolling = false
    }
    
    func clicked(at index: Int) {
        if !isScrolling { clicked(at: index, fromDelegate: true) }
    }
    
    func selectSegment(at index: Int) {
        clicked(at: index, fromDelegate: false)
    }
    
    func clicked(at index: Int, fromDelegate: Bool) {
        
        if index != selectedIndex {
            
            if segments.count > numberOfSegmentsToDisplay {
                
                var currentOffset = scrollView.contentOffset.x
                let offsetOfSegment = offsetForSegment(at: index)
                var needToScroll = true
                if currentOffset.isNearlyEqual(to: offsetOfSegment) {
                    if index != 0 {
                        currentOffset = currentOffset - widthPerElement
                        needToScroll = true
                    }
                }
                else if (currentOffset+(widthPerElement*CGFloat(numberOfSegmentsToDisplay-1))).isNearlyEqual(to: offsetOfSegment) {
                    if index != numberOfSegments-1 {
                        currentOffset = currentOffset + widthPerElement
                        needToScroll = true
                    }
                }
                
                if needToScroll {
                    UIView.animate(withDuration: 0.2) {
                        var scrollBounds = self.scrollView.bounds
                        scrollBounds.origin = CGPoint.init(x: currentOffset, y: 0.0)
                        self.scrollView.bounds = scrollBounds
                    }
                }
            }
            
            segments[selectedIndex].selected = false
            segments[index].selected = true
            
            selectedIndex = index
        }
        
        if fromDelegate { delegate.selectedSegment(at: index) }
    }
    
    func updateTextColor() {
        segments.forEach({
            $0.textColor = textColor
            $0.highlightTextColor = highlightTextColor
        })
    }
    
    func updateFont() {
        segments.forEach({ $0.font = font })
    }
    
    
    func offsetForSegment(at index: Int) -> CGFloat {
        return widthPerElement*CGFloat(index)
    }
}

extension CGFloat {
    func isNearlyEqual(to offset: CGFloat) -> Bool {
        return (self < offset) ? ((offset-self) < 2.0) : ((self-offset) < 2.0);
    }
}

protocol HorizontalControlSegmentDelegate {
    
    func clicked(at index: Int)
}

class HorizontalControlSegment: UIView {
    
    var delegate: HorizontalControlSegmentDelegate!
    var index = Int(0)
    
    var text = "" { didSet { if label != nil { label.text = text } } }
    var font = UIFont.systemFont(ofSize: 17.0) { didSet { if label != nil { label.font = font } } }
    var textColor = UIColor.darkText { didSet { updateAppearance() } }
    var highlightTextColor = UIColor.red { didSet { updateAppearance() } }
    var selected = false { didSet { updateAppearance() } }
    
    var widthConstraint: NSLayoutConstraint?
    
    private var label: UILabel!
    private var tapGestureRecognizer: UITapGestureRecognizer!
    
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
        if label != nil { label.textColor = selected ? textColor : highlightTextColor }
    }

}
