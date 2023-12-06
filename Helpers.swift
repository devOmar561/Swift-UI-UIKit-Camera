//
//  Helpers.swift
//  ID3D iOS mid-level SwiftUI Test 03
//
//  Created by Elliott Io on 5/21/21.
//

import Foundation

import SwiftUI

/// Color extension for custom colors defined in the Colors.xcassets
extension Color {
    static let appBackground = Color("appBackground")
    static let appLabel = Color("appLabel")
    static let appBackgroundSecondary = Color("appBackgroundSecondary")
    static let appBackgroundTertiary = Color("appBackgroundTertiary")
}

extension String {
    /// Gets value from Localizable.strings
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
