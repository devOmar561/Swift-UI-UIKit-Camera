//
//  Constants.swift
//  ID3D iOS mid-level SwiftUI Test 03
//
//  Created by Alex Nagy on 22/09/2021.
//

import Foundation

var LAST_SESSION_ID: String? {
    get {
        return UserDefaults.standard.value(forKey: "lastSession") as? String
    } set {
        UserDefaults.standard.setValue(newValue, forKey: "lastSession")
    }
}

let MAIN_QUEUE = DispatchQueue.main
let FOLDER_NAME  : String = "captureSession"
let IS_DISMISSED : Observable<Bool> = Observable(false)

