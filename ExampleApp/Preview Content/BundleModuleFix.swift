//
//  BundleModuleFix.swift
//  TimetableKit
//
//  Created by Simon Gaus on 15.02.21.
//

import class Foundation.Bundle

private class BundleFinder {}

extension Foundation.Bundle {
    /// Returns the resource bundle associated with the current Swift module.
    static var module: Bundle = {
        return Bundle.main
    }()
}
