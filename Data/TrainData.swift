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
        guard let trainIndexUrl = Bundle.main.url(forResource: "train_index", withExtension: "json"),
        let trainIndexData = try? Data(contentsOf: trainIndexUrl)
        else {
            return
        }
        
        do {
            let trainIds = try JSONDecoder().decode([String].self, from: trainIndexData)
            var importedCount = 0
            for trainId in trainIds {
                guard let trainUrl = Bundle.main.url(forResource: trainId, withExtension: "json"),
                      let trainData = try? Data(contentsOf: trainUrl)
                else {
                    continue
                }
                
                do {
                    let train = try JSONDecoder().decode(Train.self, from: trainData)
                    context.insert(train)
                    importedCount += 1
                }
                try context.save()
                print("Imported \(importedCount) trains")
            }
        } catch {
            print("Error importing trains \(error)")
        }
        
    }
}
