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
        // Initial import for core static data
        if !hasCoreDataBeenImported(context: context) {
            print("Core data import is initiated")
            StationData.importStations(context: context)
            LineData.importLines(context: context)
            print("Core data import is finished")
        } else {
            print("Core data (stations/lines) already imported.")
        }
        
        // Always check for new or updated train schedules
        print("Checking for new train schedules...")
        TrainData.importTrains(context: context)
    }
    
    private static func hasCoreDataBeenImported(context: ModelContext) -> Bool {
        let stationCount = try? context.fetchCount(FetchDescriptor<Station>())
        let lineCount = try? context.fetchCount(FetchDescriptor<Line>())
        return (stationCount ?? 0) > 0 && (lineCount ?? 0) > 0
    }
}

