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

    let hctrl = HorizontalControl(frame: .zero, and: ["1", "2", "3"])
    
    func makeUIView(context: Context) -> HorizontalControl {
        
        print("HorizontalControllWrapperView makeUIView")
        return hctrl
    }

    func updateUIView(_ uiView: HorizontalControl, context: Context) {
        
        //hctrl.setNeedsLayout()
    }
}

class Del: HorizontalControlDelegate {
    func selectedSegment(at index: Int) {
        print("selected segment")
    }
    
    
}
