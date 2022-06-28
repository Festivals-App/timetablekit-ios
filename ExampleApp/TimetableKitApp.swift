//
//  TimetableKitApp.swift
//  TimetableKit
//
//  Created by Simon Gaus on 24.09.20.
//

import SwiftUI

@main
struct TimetableKitApp: App {
    
    let del = Del()
    
    @State var timetableOffset: CGPoint = CGPoint(x: 300, y: 0)
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                
                Color.init(UIColor.with(34.0, 34.0, 34.0)).ignoresSafeArea()
                
                VStack {
                
                    HorizontalControlTestWrapper(items: ["One", "Two", "Three"], index: 2) { newIndex in
                        print("new index \(newIndex))")
                    }
                    
                    TimetableView_wrapper(offset: $timetableOffset)
                                .ignoresSafeArea(.all, edges: .horizontal)
                }
            }
        }
    }
}

struct TimetableKitApp_Previews: PreviewProvider {
    static var previews: some View {
        TimetableView_wrapper(offset: .constant(.zero))
            .ignoresSafeArea(.all, edges: .horizontal)
    }
}
