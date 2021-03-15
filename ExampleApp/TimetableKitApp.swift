//
//  TimetableKitApp.swift
//  TimetableKit
//
//  Created by Simon Gaus on 24.09.20.
//

import SwiftUI

@main
struct TimetableKitApp: App {
    var body: some Scene {
        WindowGroup {
            TimetableView_wrapper()
                        .ignoresSafeArea(.all, edges: .horizontal)
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
        
        let timetable = TimetableView(.infinite, with: TimetableStyle.light)
        timetable.dataSource = ConcreteTimetableDelegate.init()
        timetable.appearanceDelegate = ConcreteTimetableDelegate.init()
        timetable.reloadData()
        return timetable
    
    }

    func updateUIView(_ uiView: TimetableView, context: Context) {

    }
}
