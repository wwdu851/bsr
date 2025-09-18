//
//  bsrApp.swift
//  bsr
//
//  Created by William Du on 8/12/25.
//

import SwiftUI
import SwiftData

@main
struct bsrApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Station.self,
            Item.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            
            Task { @MainActor in
                let context = ModelContext(container)
                DataImporter.importInitialData(context: context)
            }
            
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
