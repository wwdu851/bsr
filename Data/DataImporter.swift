//
//  DataImporter.swift
//  bsr
//
//  Created by William Du on 8/20/25.
//

import Foundation
import SwiftData

class DataImporter {
    static func importInitialData(context: ModelContext) {
        if hasDataBeenImported(context: context) {
            print("Data has been already imported")
            return
        }
        
        print ("Data import is initiated")
        importStations(context: context)
        print ("Data import is finished")
    }
    
    private static func hasDataBeenImported(context: ModelContext) -> Bool {
        let stationCount = try? context.fetchCount(FetchDescriptor<Station>())
        return (stationCount ?? 0) > 0
    }
    
    private static func importStations(context: ModelContext) {
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

    func importInitialData(context: ModelContext) {
        if let stationsUrl = Bundle.main.url(forResource: "stations", withExtension: "json"),
           let stationsData = try? Data(contentsOf: stationsUrl),
           let stationsArray = try? JSONDecoder().decode([Station].self, from: stationsData)
        {
            try! context.save(stationsArray)
        }
    }

    
}

