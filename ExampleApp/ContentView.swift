//
//  ContentView.swift
//  TimetableKit
//
//  Created by Simon Gaus on 24.09.20.
//

import SwiftUI

struct ContentView: View {
    
    let del = Del()
    
    var body: some View {
        
        VStack {
            Text("1")
            Rectangle()
                .foregroundColor(.red)
            HorizontalControllWrapperView(delegate: del)
            Rectangle()
                .foregroundColor(.blue)
        }
        .foregroundColor(.blue)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .foregroundColor(.blue)
    }
}

struct HorizontalControllWrapperView: UIViewRepresentable {
    
    var delegate: HorizontalControlDelegate

    func makeUIView(context: Context) -> HorizontalControl {
    
        print("HorizontalControl makeUIView")
        let hctrl = HorizontalControl(frame: .zero, items: ["0", "1", "2", "3", "4", "5", "6"], initialIndex:3)
        hctrl.numberOfSegmentsToDisplay = 4
        hctrl.delegate = delegate
        return hctrl
    }

    func updateUIView(_ uiView: HorizontalControl, context: Context) {
        
        //hctrl.setNeedsLayout()
        // uiView.selectSegment(at: 3)
        //uiView.setNeedsLayout()
    }
}

class Del: HorizontalControlDelegate {
    func selectedSegment(at index: Int) {
        print("selected segment \(index)")
    }
    
    
}
