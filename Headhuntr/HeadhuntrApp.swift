//
//  HeadhuntrApp.swift
//  Headhuntr
//
//  Created by StartupBuilder.INFO on 10/22/20.
//

import SwiftUI

@main
struct HeadhuntrApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
