//
//  Navigation.swift
//  ID3D iOS mid-level SwiftUI Test 03
//
//  Created by Elliott on 5/20/21.
//

import SwiftUI

public struct Navigation {
    /// Dismisses the current view from the navigation stack
    /// - Parameter presentationMode: @Environment presentationMode
    public static func dismiss(with presentationMode: Binding<PresentationMode>) {
        presentationMode.wrappedValue.dismiss()
    }
}
