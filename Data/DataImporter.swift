//
//  DataImporter.swift
//  bsr
//
//  Created by William Du on 8/20/25.
//

import Foundation
import SwiftData

func importInitialData(context: ModelContext) {
    if let stationsUrl = Bundle.main.url(forResource: "stations", withExtension: "json"),
       let stationsData = try? Data(contentsOf: stationsUrl),
       let stationsArray = try? JSONDecoder().decode([Station].self, from: stationsData)
    {
        try! context.save(stationsArray)
    }
}
