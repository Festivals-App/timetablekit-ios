//
//  TimetableView_wrapper.swift
//  TimetableKit
//
//  Created by Simon Gaus on 24.09.20.
//

import SwiftUI


struct TimetableView_wrapper: UIViewRepresentable {

    func makeUIView(context: Context) -> TimetableView {
        
        let timetable = TimetableView(.infinite, with: TimetableStyle.dark)
        timetable.dataSource = ConcreteTimetableDelegate.init()
        return timetable
    
    }

    func updateUIView(_ uiView: TimetableView, context: Context) {

    }
}

struct TimetableView_wrapper_Previews: PreviewProvider {
    static var previews: some View {
        TimetableView_wrapper()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
}
