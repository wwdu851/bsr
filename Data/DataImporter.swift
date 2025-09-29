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
        
        print("Station data import is initiated")
        StationData.importStations(context: context)
        print("Station data import is finished")
        
        print("Train data import is initiated")
        TrainData.importTrains(context: context)
        print("Train data import is finished")
        
        print("Line data import is initiated")
        LineData.importLines(context: context)
        print("Line data import is finished")
    }
    
    private static func hasDataBeenImported(context: ModelContext) -> Bool {
        let stationCount = try? context.fetchCount(FetchDescriptor<Station>())
        let lineCount = try? context.fetchCount(FetchDescriptor<Line>())
        let trainCount = try? context.fetchCount(FetchDescriptor<Train>())
        return (stationCount ?? 0) > 0 && (lineCount ?? 0) > 0 && (trainCount ?? 0) > 0
    }
}

