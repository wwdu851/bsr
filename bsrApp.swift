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
    
    init() {
        Task {
            await importDataIfNeeded()
        }
    }
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Station.self,
            Item.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
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
    
    // 异步导入数据
    @MainActor
    private func importDataIfNeeded() async {
        let context = ModelContext(sharedModelContainer)
        DataImporter.importInitialData(context: context)
    }
}
