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
            let stations = try JSONDecoder().decode([Station].self, from: stationData)
            
            for station in stations {
                context.insert(station)
            }
            
            try context.save()
            print("Imported \(stations.count) stations")
        } catch {
            print("Error importing stations: \(error)")
        }
    }
}
