//
//  SampleApp.swift
//  Sample
//
//  Created by Dhilip R on 22/12/25.
//

import SwiftUI
import CoreData

@main
struct SampleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
