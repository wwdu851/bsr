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
        StationData.importStations(context: context)
        print ("Data import is finished")
    }
    
    private static func hasDataBeenImported(context: ModelContext) -> Bool {
        let stationCount = try? context.fetchCount(FetchDescriptor<Station>())
        return (stationCount ?? 0) > 0
    }
}

