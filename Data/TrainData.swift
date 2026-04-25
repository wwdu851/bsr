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
            let trainIdsInJsonSet = Set(trainIdsInJson.map { $0.lowercased() })
            
            // Fetch existing trains from SwiftData
            let descriptor = FetchDescriptor<Train>()
            let existingTrains = try context.fetch(descriptor)
            
            // 1. Remove trains that are no longer in the index
            var removedCount = 0
            for train in existingTrains {
                if !trainIdsInJsonSet.contains(train.id.lowercased()) {
                    context.delete(train)
                    removedCount += 1
                }
            }
            
            if removedCount > 0 {
                print("Removed \(removedCount) non-operating trains.")
            }
            
            // 2. Add new trains that are in the index but not in SwiftData
            let existingTrainIds = Set(existingTrains.map { $0.id.lowercased() })
            let missingTrainIds = trainIdsInJson.filter { !existingTrainIds.contains($0.lowercased()) }
            
            if missingTrainIds.isEmpty && removedCount == 0 {
                print("Train schedules are up to date.")
                return
            }
            
            if !missingTrainIds.isEmpty {
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
                print("Successfully imported \(importedCount) trains.")
            }
            
            try context.save()
        } catch {
            print("Error synchronizing trains: \(error)")
        }
    }
}
