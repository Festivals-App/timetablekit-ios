//
//  File.swift
//  
//
//  Created by Simon Gaus on 03.07.20.
//

import UIKit

@objc public protocol HorizontalControlDelegate {
    
    func selectedSegment(at index: Int)
}

public class HorizontalControl: UIView {
    
    @IBOutlet public var delegate: HorizontalControlDelegate!
    var numberOfSegments: Int { return segments.count }
    var selectedSegmentIndex = Int(0)
    
    var numberOfSegmentsToDisplay = Int(3)
    
    public var textColor = UIColor.darkText { didSet { updateTextColor() } }
    public var highlightTextColor = UIColor.red { didSet { updateTextColor() } }
    public var font = UIFont.systemFont(ofSize: UIFont.systemFontSize) { didSet { updateFont() } }
    
    var scrollView: UIScrollView!
    var contentView: UIView!
    
    var segments = [HorizontalControlSegment]()
    var containerViewWidthConstraint: NSLayoutConstraint!
    
    var selectedIndex: Int = 0
    var widthPerElement: CGFloat = 0
    var isScrolling: Bool = false
    
    public convenience init(frame: CGRect, and items: [String]) {
        self.init(frame: frame)
        configure(with: items)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public func configure(with items: [String]) {
        
        if items.count > 0 {
            
            subviews.forEach { $0.removeFromSuperview() }
            
            scrollView = UIScrollView.init(frame: bounds)
            scrollView.delegate = self
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.showsVerticalScrollIndicator = false
            addSubview(scrollView)
            scrollView.fit(to: self)
            
            contentView = UIView.init(frame: bounds)
            scrollView.addSubview(contentView)
            contentView.fit(to: scrollView)
            
            contentView.translatesAutoresizingMaskIntoConstraints = false
            
            let leadingAnchor = contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor)
            let trailingAnchor = contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor)
            let topAnchor = contentView.topAnchor.constraint(equalTo: scrollView.topAnchor)
            let bottomAnchor = contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            
            let heightsConstraint_container = contentView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 1.0)
            let widhtConstraint_container = contentView.widthAnchor.constraint(equalToConstant: 0.0)
            
            
            leadingAnchor.isActive = true
            trailingAnchor.isActive = true
            topAnchor.isActive = true
            bottomAnchor.isActive = true
            
            widhtConstraint_container.isActive = true
            heightsConstraint_container.isActive = true
            
            containerViewWidthConstraint = widhtConstraint_container
            
            let numberOfItems = items.count
            let maxNumSegments = numberOfSegmentsToDisplay
            var dontZero = (numberOfItems > maxNumSegments) ? maxNumSegments : numberOfItems
            if dontZero == 0 { dontZero = 1 }
            let currentWidthPerElement = frame.size.width/CGFloat(dontZero)
            
            var leftAnchor_content = contentView.leadingAnchor
            
            contentView.subviews.forEach({ $0.removeFromSuperview() })
            
            var newSegments = [HorizontalControlSegment]()
            for index in 0..<numberOfItems {
                
                let cell = HorizontalControlSegment.init(frame: bounds)
                cell.delegate = self
                contentView.addSubview(cell)
                
                cell.translatesAutoresizingMaskIntoConstraints = false
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
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        guard let scrollView = scrollView else { return }
        
        let offsetInNumberOfSegments = scrollView.contentOffset.x/widthPerElement
        let oldWidth = widthPerElement
        
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
    
    public func selectSegment(at index: Int) {
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
            
            if segments.count > selectedIndex {
                segments[selectedIndex].selected = false
            }
            
            if segments.count > index {
                segments[index].selected = true
            }
            
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

extension HorizontalControl: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        isScrolling = true
        NSObject.cancelPreviousPerformRequests(withTarget: self)
        perform(#selector(scrollViewDidEndScrollingAnimation(_:)), with: scrollView, afterDelay: 0.3)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
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
}

extension HorizontalControl: HorizontalControlSegmentDelegate  {
    
    func clicked(at index: Int) {
        if !isScrolling { clicked(at: index, fromDelegate: true) }
    }
}

protocol HorizontalControlSegmentDelegate {
    
    func clicked(at index: Int)
}

class HorizontalControlSegment: UIView {
    
    var delegate: HorizontalControlSegmentDelegate!
    var index = Int(0)
    
    var text = "Segment<>" { didSet { label.text = text } }
    var font = UIFont.systemFont(ofSize: 17.0) { didSet { label.font = font } }
    var textColor = UIColor.darkText { didSet { updateAppearance() } }
    var highlightTextColor = UIColor.red { didSet { updateAppearance() } }
    var selected = false { didSet { updateAppearance() } }
    
    var widthConstraint: NSLayoutConstraint?
    
    private var label: UILabel
    private var tapGestureRecognizer: UITapGestureRecognizer!
    
    override init(frame: CGRect) {
        
        label = UILabel.init(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .light)
        label.numberOfLines = 0
        label.textAlignment = .center
        
        super.init(frame: frame)
        
        self.addSubview(label)
        label.fit(to: self)
        
        tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handle(tap:)))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    required init?(coder: NSCoder) {
        
        label = UILabel.init(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 17.0, weight: .light)
        label.numberOfLines = 0
        label.textAlignment = .center
        
        super.init(coder: coder)
        
        self.addSubview(label)
        label.fit(to: self)
        
        tapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(handle(tap:)))
        addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func handle(tap: UITapGestureRecognizer) {
        
        delegate.clicked(at: index)
    }
    
    private func updateAppearance() {
        
        label.textColor = selected ? highlightTextColor : textColor
    }
}

