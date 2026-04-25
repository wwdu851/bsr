//
//  TrainData.swift
//  bsr
//
//  Created by William Du on 8/19/25.
//

import Foundation
import SwiftData

class TrainData {
    static func importTrains(context: ModelContext) {
        guard let trainIndexUrl = Bundle.main.url(forResource: "trains_index", withExtension: "json"),
              let trainIndexData = try? Data(contentsOf: trainIndexUrl) else {
            return
        }
        
        do {
            let trainIdsInJson = try JSONDecoder().decode([String].self, from: trainIndexData)
            
            // Fetch existing train IDs from SwiftData
            let descriptor = FetchDescriptor<Train>()
            let existingTrains = try context.fetch(descriptor)
            let existingTrainIds = Set(existingTrains.map { $0.id.lowercased() })
            
            let missingTrainIds = trainIdsInJson.filter { !existingTrainIds.contains($0.lowercased()) }
            
            if missingTrainIds.isEmpty {
                print("No new trains to import.")
                return
            }
            
            print("Importing \(missingTrainIds.count) new trains...")
            
            var importedCount = 0
            for trainId in missingTrainIds {
                guard let trainUrl = Bundle.main.url(forResource: trainId, withExtension: "json"),
                      let trainData = try? Data(contentsOf: trainUrl) else {
                    print("⚠️ Could not find file for train: \(trainId)")
                    continue
                }
                
                do {
                    let train = try JSONDecoder().decode(Train.self, from: trainData)
                    context.insert(train)
                    importedCount += 1
                } catch {
                    print("❌ Error decoding train \(trainId): \(error)")
                }
            }
            
            try context.save()
            print("Successfully imported \(importedCount) trains.")
        } catch {
            print("Error importing trains: \(error)")
        }
    }
}
