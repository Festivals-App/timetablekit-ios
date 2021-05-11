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
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                
                Color.init(UIColor.with(34.0, 34.0, 34.0)).ignoresSafeArea()
                
                
                
                VStack {
                    
                    HorizontalControllWrapperView(delegate: del)
                    
                    TimetableView_wrapper()
                                .ignoresSafeArea(.all, edges: .horizontal)
                }
            }
        }
    }
}

struct TimetableKitApp_Previews: PreviewProvider {
    static var previews: some View {
        TimetableView_wrapper()
            .ignoresSafeArea(.all, edges: .horizontal)
    }
}

struct TimetableView_wrapper: UIViewRepresentable {

    func makeUIView(context: Context) -> TimetableView {
        
        let timetable = TimetableView(.infinite, with: TimetableStyle.dark)
        let delegate = ConcreteTimetableDelegate.init()
        timetable.dataSource = delegate
        timetable.clock = delegate
        //timetable.appearanceDelegate = ConcreteTimetableDelegate.init()
        
        timetable.reloadData()
        return timetable
    
    }

    func updateUIView(_ uiView: TimetableView, context: Context) {
        
    }
}
