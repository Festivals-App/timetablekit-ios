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

struct TimetableView_wrapper: UIViewRepresentable {
    
    @Binding var offset: CGPoint

    func makeUIView(context: Context) -> TimetableView {
        
        let timetable = TimetableView(.infinite, with: TimetableStyle.dark)
        timetable.dataSource = context.coordinator
        timetable.delegate = context.coordinator
        timetable.clock = context.coordinator
        //timetable.appearanceDelegate = ConcreteTimetableDelegate.init()
        timetable.reloadData()
        return timetable
    }

    func updateUIView(_ uiView: TimetableView, context: Context) {
        uiView.reloadData()
        uiView.scrollToCurrentDate()
    }
    
    func makeCoordinator() -> TimetableCoordinator {
        TimetableCoordinator(self)
    }
}
