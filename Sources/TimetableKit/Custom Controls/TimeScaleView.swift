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

class TimescaleView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var interval = DateInterval.init(start: Date.distantPast, duration: 60) { didSet { self.reloadData() } }
    var pointsPerMinute: CGFloat = 2.1 { didSet { self.reloadData() } }
    var timescaleColor = UIColor.black { didSet { self.backgroundColor = timescaleColor } }
    var timescaleStrokeColor = UIColor.white { didSet { self.reloadData() } }
    
    let timeFormatter = TimeFormatter()
    
    init(frame: CGRect) {
        
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        super.init(frame: frame, collectionViewLayout: layout)
        configure()
    }
    
    required init?(coder: NSCoder) {
        
        super.init(coder: coder)
        configure()
    }
    
    func configure() {
        
        self.register(TimescaleCell.self, forCellWithReuseIdentifier: TimescaleCell.identifier)
        self.delegate = self
        self.dataSource = self
        self.showsHorizontalScrollIndicator = false
        self.isScrollEnabled = false
        self.isUserInteractionEnabled = false
        self.isPrefetchingEnabled = false
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let widthOfScale = CGFloat(interval.duration) * pointsPerMinute;
        let widthOfCell = lengthOfCellInMinutes * pointsPerMinute;
        return Int(widthOfScale/widthOfCell)+2;
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TimescaleCell.identifier, for: indexPath) as! TimescaleCell
        cell.isFirstCell = (indexPath.row == 0);
        cell.textLabel.isHidden = (indexPath.row == 0);
        cell.lineStrokeColor = self.timescaleStrokeColor;
        cell.backgroundColor = self.timescaleColor;
        cell.textLabel.textColor = self.timescaleStrokeColor;
        cell.textLabel.text = timeString(for: indexPath.row);
        cell.setNeedsDisplay()
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = lengthOfCellInMinutes * pointsPerMinute * ((indexPath.row == 0) ? 0.5 : 1.0)
        let height = frame.size.height
        return [width, height]
    }
    
    func timeString(for column: Int) -> String {
        
        let timeOffsetFromStart = CGFloat(column) * lengthOfCellInMinutes * 60.0
        let timeToDisplayInTile = interval.start.addingTimeInterval(Double(timeOffsetFromStart))
        return timeFormatter.string(from: timeToDisplayInTile)
    }
}

fileprivate class TimescaleCell: UICollectionViewCell {
    
    static let identifier = "SGTimescaleCellIdentifier"
    
    var textLabel: UILabel!
    var lineStrokeColor: UIColor = UIColor.black
    var isFirstCell: Bool = false
    
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
        let _ = label.stickToBottom(of: self)
        textLabel = label
    }
    
    func timeLabel() -> UILabel {
        let label = UILabel.init(frame: .zero)
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
            context.move(to: [0.0, 0.0])
            
            if (self.isFirstCell) {
                context.addLine(to: [0.0, (rect.size.height/3.5).picelAlligned()])
            }
            else {
                context.addLine(to: [0.0, (rect.size.height/6.0).picelAlligned()])
                context.strokePath();
                context.move(to: [(rect.size.width/2.0).picelAlligned(), 0.0])
                context.addLine(to: [(rect.size.width/2.0).picelAlligned(), (rect.size.height/3.5).picelAlligned()])
            }

            context.strokePath();
        }
    }
}


fileprivate extension CGFloat {
    
    func picelAlligned() -> CGFloat {
        return self //(value < 0.5f) ? 0.5f : floor(value * 2) / 2
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
