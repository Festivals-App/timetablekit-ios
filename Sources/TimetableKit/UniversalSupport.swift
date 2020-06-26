//
//  File.swift
//  
//
//  Created by Simon Gaus on 26.06.20.
//

#if !os(iOS)
import AppKit
#else
import UIKit
#endif

#if !os(iOS)
class View: NSView {

    var backgroundColor: NSColor = .white
}
#else
class View: UIView {
    
    
}
#endif

