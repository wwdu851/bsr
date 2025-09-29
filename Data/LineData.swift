//
//  LineData.swift
//  bsr
//
//  Created by William Du on 8/19/25.
//

import SwiftUI
import SwiftData

class LineData {
    static func importLines(context: ModelContext) {
        guard let lineURL = Bundle.main.url(forResource: "lines", withExtension: "json"),
              let lineData = try? Data(contentsOf: lineURL)
        else {
            print("Couldn't find lines.json")
            return
        }
        do {
            guard let lines = try? JSONDecoder().decode([Line].self, from: lineData) else {
                return
            }
            for line in lines {
                context.insert(line)
            }
            try context.save()
        } catch {
            print("Could not save lines: \(error)")
        }
        
    }
}
