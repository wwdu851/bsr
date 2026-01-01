//
//  TimeTableViewModel.swift
//  bsr
//
//  Created by William Du on 12/28/25.
//

import Foundation
import SwiftUI
import SwiftData

@Observable
final class TimeTableViewModel {
    let origin: String
    let destination: String
    let context: ModelContext
    
    var connections: [TimetableConnection] = []
    
    init(origin: String, destination: String, context: ModelContext) {
        self.origin = origin
        self.destination = destination
        self.context = context
    }
    
    func loadConnections() {
        do {
            let fetchDescriptor = FetchDescriptor<Train>()
            let trains = try context.fetch(fetchDescriptor)

            var results: [TimetableConnection] = []

            for train in trains {
                guard
                    let departureStop = train.schedule.first(where: { $0.stationId == origin }),
                    let arrivalStop = train.schedule.first(where: { $0.stationId == destination }),
                    let departureTime = departureStop.departureTime,
                    let arrivalTime = arrivalStop.arrivalTime,
                    let interval = interval(departureTime, arrivalTime)
                else {
                    continue
                }

                let connection = TimetableConnection(
                    id: train.id,
                    line: train.line,
                    departureTime: departureTime,
                    arrivalTime: arrivalTime,
                    terminus: train.destination,
                    interval: interval,
                    fare: 8
                )

                results.append(connection)
            }
            
            results = results.sorted {
                guard let lhs = minutesSinceMidnight($0.departureTime), let rhs = minutesSinceMidnight($1.departureTime) else {
                    return false
                }
                return lhs < rhs
            }
            self.connections = results
        } catch {
            print("❌ Failed to load connections:", error)
        }
    }

}

extension TimeTableViewModel {
    private func minutesSinceMidnight(_ time: String) -> Int? {
        let components = time.split(separator: ":")
        guard
            components.count == 2,
            let hour = Int(components[0]),
            let minute = Int(components[1]),
            (0..<24).contains(hour),
            (0..<60).contains(minute)
        else {
            return nil
        }
        return hour * 60 + minute
    }

    private func interval(_ departureTime: String, _ arrivalTime: String) -> Int? {
        guard
            let dep = minutesSinceMidnight(departureTime),
            let arr = minutesSinceMidnight(arrivalTime),
            arr > dep
        else {
            return nil
        }
        return arr - dep
    }
}


struct TimetableConnection: Identifiable {
    let id: String
    let line: String
    let departureTime: String
    let arrivalTime: String
    let terminus: String
    let interval: Int
    let fare: Int
}

