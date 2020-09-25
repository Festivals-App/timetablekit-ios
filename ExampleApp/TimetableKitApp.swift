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
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
        }
    }
}

struct TimetableKitApp_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
