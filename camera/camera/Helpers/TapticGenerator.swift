//
//  TapticGenerator.swift
//  StoryboardSnippets
//
//  Created by Elliott Io on 4/28/20.
//  Copyright © 2020 elliott io. All rights reserved.
//

import Foundation
import UIKit

class TapticGenerator {
    /// UIImpactFeedbackGenerator is used to give user feedback when an impact between UI elements occurs
    static func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    /// UINotificationFeedbackGenerator is used to give user feedback when an notification is displayed
    static func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    /// UISelectionFeedbackGenerator is used to give user feedback when a selection changes
    static func selectionChanged() {
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()
    }
}
