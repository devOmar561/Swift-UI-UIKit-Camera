//
//  CardModel.swift
//  ID3D iOS mid-level SwiftUI Test 03
//
//  Created by Elliott on 5/20/21.
//

import Foundation
import SwiftUI

/// Model for a CardView
struct CardModel: Identifiable {
    let id = UUID()
    let title: String
    let destination: AnyView
}
