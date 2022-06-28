//
//  HorizontalPicker.swift
//  FestivalsApp
//
//  Created by Simon Gaus on 30.04.21.
//  Copyright © 2021 Simon Gaus. All rights reserved.
//

import SwiftUI

struct HorizontalControlTestWrapper: UIViewRepresentable {
    
    var items: [String]
    var index: Int
    var visibleSegments: Int = 3
    var picked: (Int)->()
    
    func makeUIView(context: Context) -> HorizontalControl {
        
        let ctrl = HorizontalControl(frame: .zero)
        ctrl.delegate = context.coordinator
        ctrl.numberOfSegmentsToDisplay = visibleSegments
        ctrl.selectedIndex = index
        ctrl.textColor = .black
        ctrl.highlightTextColor = .red
        ctrl.font = UIFont.systemFont(ofSize: UIFont.buttonFontSize)
        ctrl.configure(with: items)
        return ctrl
    }

    func updateUIView(_ uiView: HorizontalControl, context: Context) {

    }
    
    func didChangeIndex(newIndex: Int) {
        picked(newIndex)
    }
    
    func makeCoordinator() -> ConcretHorizontalControlDelegate {
        ConcretHorizontalControlDelegate(picker: self)
    }
    
    class ConcretHorizontalControlDelegate: NSObject, HorizontalControlDelegate {
        
        var picker: HorizontalControlTestWrapper
        
        init(picker: HorizontalControlTestWrapper) {
            self.picker = picker
        }
        
        func selectedSegment(at index: Int) {
            self.picker.didChangeIndex(newIndex: index)
        }
    }
}

struct HorizontalControlTestWrapper_Previews: PreviewProvider {
    static var previews: some View {
        HorizontalControlTestWrapper(items: ["One", "Two", "Three"], index: 0) { newIndex in
            print("new index \(newIndex))")
        }
    }
}
