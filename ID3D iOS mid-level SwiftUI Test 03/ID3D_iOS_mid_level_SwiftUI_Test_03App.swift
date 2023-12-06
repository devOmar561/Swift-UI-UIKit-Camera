//
//  ID3D_iOS_mid_level_SwiftUI_Test_03App.swift
//  ID3D iOS mid-level SwiftUI Test 03
//
//  Created by Elliott on 5/14/21.
//

import SwiftUI

@main
struct ID3D_iOS_mid_level_SwiftUI_Test_03App: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
