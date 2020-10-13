//
//  File.swift
//  
//
//  Created by Simon Gaus on 03.07.20.
//

import UIKit
import CoreGraphics

enum CellWidth: CGFloat {
    case min = 50.0
    case max = 90.0
}

enum TimeIntervalFactor: CGFloat {
    case min = 15.0
    case standard = 30.0
    case max = 60.0
}

class TimescaleView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var interval = DateInterval.init(start: Date.init(), duration: 3600) { didSet { reloadData() } }
    var pointsPerMinute: CGFloat = 2.1 { didSet { reloadData() } }
    var timescaleColor = UIColor.black { didSet { backgroundColor = timescaleColor } }
    var timescaleStrokeColor = UIColor.white { didSet { reloadData() } }
    
    let timeIntervalFactor = 1
    let timeFormatter = TimeFormatter()
    
    init(frame: CGRect) {
        
        super.init(frame: frame, collectionViewLayout: TimescaleView.flowLayout())
        configure()
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        configure()
    }
    
    static func flowLayout() -> UICollectionViewFlowLayout {
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        return layout
    }
    
    func configure() {
        
        self.contentInset = .zero
        self.register(TimescaleCell.self, forCellWithReuseIdentifier: TimescaleCell.identifier)
        self.delegate = self
        self.dataSource = self
        self.showsHorizontalScrollIndicator = false
        self.isScrollEnabled = false
        self.isUserInteractionEnabled = false
        self.isPrefetchingEnabled = false
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let widthOfScale = CGFloat(interval.duration) * pointsPerMinute;
        let widthOfCell = lengthOfCellInMinutes * pointsPerMinute;
        return Int(widthOfScale/widthOfCell)+2;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimescaleCell.identifier, for: indexPath) as! TimescaleCell
        cell.isFirstCell = (indexPath.row == 0)
        cell.textLabel.isHidden = (indexPath.row == 0)
        cell.lineStrokeColor = timescaleStrokeColor
        cell.backgroundColor = timescaleColor
        cell.textLabel.textColor = timescaleStrokeColor
        cell.textLabel.text = timeString(for: indexPath.row)
        cell.setNeedsDisplay()
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = lengthOfCellInMinutes * pointsPerMinute
        let size: CGSize = [(indexPath.row == 0) ? width/2.0 : width, (safeAreaLayoutGuide.layoutFrame.size.height - (safeAreaInsets.top + safeAreaInsets.bottom) - (contentInset.top + contentInset.bottom))]
        return size
    }

    func timeString(for column: Int) -> String {
        
        let timeOffsetFromStart = CGFloat(column) * lengthOfCellInMinutes * 60.0
        let timeToDisplayInTile = interval.start.addingTimeInterval(Double(timeOffsetFromStart))
        return timeFormatter.string(from: timeToDisplayInTile)
    }
    
    var lengthOfCellInMinutes: CGFloat {
    
        #warning("TimeIntervalFactor and this whole lengthOfCellInMinutes naming is suboptimal, REFACTOR!")
        let resultingWidth = TimeIntervalFactor.standard.rawValue * pointsPerMinute;
        if resultingWidth > CellWidth.max.rawValue {
            return TimeIntervalFactor.min.rawValue
        }
        if resultingWidth < CellWidth.min.rawValue {
            return TimeIntervalFactor.max.rawValue
        }
        return TimeIntervalFactor.standard.rawValue
    }
}

fileprivate class TimescaleCell: UICollectionViewCell {
    
    static let identifier = "SGTimescaleCellIdentifier"
    
    var textLabel: UILabel!
    var lineStrokeColor: UIColor = UIColor.blue
    var isFirstCell: Bool = false
    
    override var backgroundColor: UIColor? {
        didSet {
            guard let backgroundColor = backgroundColor else { return }
            guard let textLabel = textLabel else { return }
            textLabel.backgroundColor = backgroundColor
        }
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        let label = timeLabel()
        self.addSubview(label)
        let _ = label.stickToBottom(of: self)
        textLabel = label
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        
        let label = timeLabel()
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        let _ = label.stickToBottom(of: self)
        textLabel = label
    }
    
    func timeLabel() -> UILabel {
        let label = UILabel.init(frame: .infinite)
        label.textColor = lineStrokeColor
        label.font = UIFont.systemFont(ofSize: 13.0, weight: .light)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.adjustsFontSizeToFitWidth = true
        return label
    }
    
    override func draw(_ rect: CGRect) {
        
        (backgroundColor ?? UIColor.clear).setFill()
        UIRectFill(rect)
        
        if let context = UIGraphicsGetCurrentContext() {
            
            context.setStrokeColor(lineStrokeColor.cgColor)
            context.setLineWidth(1.5)
            
            if (!self.isFirstCell) {
                context.move(to: [0.0, 0.0])
                context.addLine(to: [0.0, (rect.size.height/6.0).pixelAlligned()])
                context.strokePath()
                context.move(to: [(rect.size.width/2.0).pixelAlligned(), 0.0])
                context.addLine(to: [(rect.size.width/2.0).pixelAlligned(), (rect.size.height/3.5).pixelAlligned()])
            }
            else {
                context.move(to: [0.0, 0.0])
                context.addLine(to: [0.0, (rect.size.height/3.5).pixelAlligned()])
            }

            context.strokePath();
        }
    }
}


fileprivate extension CGFloat {
    func pixelAlligned() -> CGFloat {
        return self// (self < 0.5) ? 0.5 : floor(self * 2) / 2
    }
}

// Taken from: https://github.com/leavez/Literal/blob/master/Sources/Literal.swift
extension CGPoint: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: CGFloat...) {
        assert(elements.count == 2)
        let numbers = clip(elements, to: 2, defaultValue: 0)
        self.init(x: numbers[0], y: numbers[1])
    }
}

extension CGSize: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: CGFloat...) {
        assert(elements.count == 2)
        let numbers = clip(elements, to: 2, defaultValue: 0)
        self.init(width: numbers[0], height: numbers[1])
    }
}

private func clip<T>(_ array: [T], to count:Int, defaultValue:T) -> [T] {
    if array.count == count {
        return array
    } else if array.count < count {
        return array + (0..<(count-array.count)).map{ _ in defaultValue }
    } else {
        return Array(array[0..<count])
    }
}
