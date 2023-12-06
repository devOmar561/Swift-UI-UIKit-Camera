//
//  Helpers.swift
//  ID3D iOS mid-level SwiftUI Test 03
//
//  Created by Elliott Io on 5/21/21.
//

import Foundation

import SwiftUI

//MARK: Color Extension Functions
/// Color extension for custom colors defined in the Colors.xcassets
extension Color {
    static let appBackground = Color("appBackground")
    static let appLabel = Color("appLabel")
    static let appButton = Color("appButton")
    static let appLabelSecondary = Color("appLabelSecondary")
    static let appBackgroundSecondary = Color("appBackgroundSecondary")
    static let appBackgroundTertiary = Color("appBackgroundTertiary")
}

//MARK: String Extension Functions
extension String {
    /// Gets value from Localizable.strings
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

//MARK: UIViewController Extension Functions
extension UIViewController {
    /// Display alert popup with an error.
    ///
    /// ```
    /// // where `self` is a UIViewController
    /// self.showError(at: #function, in: #file, error: error)
    /// ```
    ///
    /// - Parameter at: The name of the function this error happened in.
    /// - Parameter error: The `Error` to be displayed.
    /// - Important: buttonTitle is unused unless a buttonHandler is passed.
    /// - Parameter buttonTitle: Option to name the confirm button. Default is `OK`.
    /// - Parameter buttonHandler: Option for the confirm button to have it's own handler function. Default is `nil`.
    func showError(at function: String,
                   in file: String,
                   error: Error,
                   buttonTitle: String = "OK",
                   buttonHandler: ((UIAlertAction) -> Void)? = nil) {
        
        let alertController = UIAlertController(title: "Error @ \(function) in \(file)", message: error.errorDescription, preferredStyle: .alert)
        if let handler = buttonHandler {
            alertController.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: handler))
        }
        alertController.addAction(UIAlertAction(title: "Close", style: .cancel))
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

//MARK: Extension to display error strings directly
extension String: LocalizedError {
    public var errorDescription: String? { return self }

    /// capitalizes first letter of a string
    /// ```
    /// "make the 'm' in 'make' capital".capitalizingFirstLetter()
    /// ```
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    /// helper for `capitalizeFirstLetter`
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }
}
extension Error {
    /// access error decription string for custom errors
    var errorDescription: String? {
        switch self {
        case is CameraError:
            return (self as? CameraError)?.rawValue.errorDescription ?? self.localizedDescription
        default:
            return self.localizedDescription
        }
    }
}
