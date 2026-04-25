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
        // Initial import for core static data (Lines)
        if !hasLinesBeenImported(context: context) {
            print("Line data import is initiated")
            LineData.importLines(context: context)
            print("Line data import is finished")
        }
        
        // Always synchronize stations
        print("Checking for station updates...")
        StationData.importStations(context: context)
        
        // Always synchronize train schedules
        print("Checking for train schedule updates...")
        TrainData.importTrains(context: context)
    }
    
    private static func hasLinesBeenImported(context: ModelContext) -> Bool {
        let lineCount = try? context.fetchCount(FetchDescriptor<Line>())
        return (lineCount ?? 0) > 0
    }
}

