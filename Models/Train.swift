//
//  Train.swift
//  bsr
//
//  Created by William Du on 8/19/25.
//

import Foundation
import SwiftData

@Model
class Train {
    @Attribute(.unique) var id: String
    
    var name: String
    var line: Line
    var origin: Station
    var destination: Station
    var schedule: [Stop]
    var daysOfOperation: [Int]
    
    init(id: String, name: String, line: Line, origin: Station, destination: Station, schedule: [Stop], daysOfOperation: [Int]) {
        self.id = id
        self.name = name
        self.line = line
        self.origin = origin
        self.destination = destination
        self.schedule = schedule
        self.daysOfOperation = daysOfOperation
    }
    
}

@Model
class Stop {
    var id: String
    var arrivalTime: String?
    var departureTime: String?
    
    init(id: String, arrivalTime: String? = nil, departureTime: String? = nil) {
        self.id = id
        self.arrivalTime = arrivalTime
        self.departureTime = departureTime
    }
}
