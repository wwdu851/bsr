//
//  StationData.swift
//  bsr
//
//  Created by William Du on 8/19/25.
//

import SwiftUI
import SwiftData

class StationData {
    static func importStations(context: ModelContext) {
        guard let stationUrl = Bundle.main.url(forResource: "stations", withExtension: "json"),
              let stationData = try? Data(contentsOf: stationUrl) else {
            print("Cannot read stations.json")
            return
        }
        
        do {
            let stationsInJson = try JSONDecoder().decode([Station].self, from: stationData)
            let stationIdsInJsonSet = Set(stationsInJson.map { $0.id.lowercased() })
            
            // Fetch existing stations from SwiftData
            let descriptor = FetchDescriptor<Station>()
            let existingStations = try context.fetch(descriptor)
            
            // 1. Remove stations that are no longer in the JSON
            var removedCount = 0
            for station in existingStations {
                if !stationIdsInJsonSet.contains(station.id.lowercased()) {
                    context.delete(station)
                    removedCount += 1
                }
            }
            
            if removedCount > 0 {
                print("Removed \(removedCount) non-operating stations.")
            }
            
            // 2. Add new stations that are in the JSON but not in SwiftData
            let existingStationIds = Set(existingStations.map { $0.id.lowercased() })
            var importedCount = 0
            for station in stationsInJson {
                if !existingStationIds.contains(station.id.lowercased()) {
                    context.insert(station)
                    importedCount += 1
                }
            }
            
            if importedCount > 0 || removedCount > 0 {
                try context.save()
                print("Station synchronization finished: Imported \(importedCount), Removed \(removedCount)")
            } else {
                print("Station data is up to date.")
            }
        } catch {
            print("Error synchronizing stations: \(error)")
        }
    }
}
