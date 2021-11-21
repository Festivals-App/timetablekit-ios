//
//  TimetableView_wrapper.swift
//  TimetableKit
//
//  Created by Simon Gaus on 21.11.21.
//

import SwiftUI

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
        
        DispatchQueue.main.async {
            uiView.scrollToCurrentDate()
        }
    }
    
    func makeCoordinator() -> TimetableCoordinator {
        TimetableCoordinator(self)
    }
}

/*
struct TimetableView_wrapper_Previews: PreviewProvider {
    static var previews: some View {
        TimetableView_wrapper()
    }
}
*/
