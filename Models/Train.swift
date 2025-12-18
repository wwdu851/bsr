//
//  Train.swift
//  bsr
//
//  Created by William Du on 8/19/25.
//

import Foundation
import SwiftData

@Model
class Train : Codable {
    @Attribute(.unique) var id: String
    
    var line: String
    var origin: String
    var destination: String
    
    var schedule: [Stop]
    var daysOfOperation: [Int]
    
    init(id: String, line: String, origin: String, destination: String, schedule: [Stop], daysOfOperation: [Int]) {
        self.id = id
        self.line = line
        self.origin = origin
        self.destination = destination
        self.schedule = schedule
        self.daysOfOperation = daysOfOperation
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case line
        case origin
        case destination
        case schedule
        case daysOfOperation = "days_of_operation"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.line = try container.decode(String.self, forKey: .line)
        self.origin = try container.decode(String.self, forKey: .origin)
        self.destination = try container.decode(String.self, forKey: .destination)
        self.schedule = try container.decode([Stop].self, forKey: .schedule)
        self.daysOfOperation = try container.decode([Int].self, forKey: .daysOfOperation)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(line, forKey: .line)
        try container.encode(origin, forKey: .origin)
        try container.encode(destination, forKey: .destination)
        try container.encode(schedule, forKey: .schedule)
        try container.encode(daysOfOperation, forKey: .daysOfOperation)
    }
    
    
}

@Model
class Stop : Codable {
    var stationId: String
    var arrivalTime: String?
    var departureTime: String?
    
    @Relationship(inverse: \Train.schedule) var train: Train?
    
    enum CodingKeys: String, CodingKey {
        case stationId = "station_id"
        case arrivalTime = "arrival_time"
        case departureTime = "departure_time"
    }
    
    init(stationId: String, arrivalTime: String? = nil, departureTime: String? = nil) {
        self.stationId = stationId
        self.arrivalTime = arrivalTime
        self.departureTime = departureTime
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.stationId = try container.decode(String.self, forKey: .stationId)
        self.departureTime = try container.decodeIfPresent(String.self, forKey: .departureTime)
        self.arrivalTime = try container.decodeIfPresent(String.self, forKey: .arrivalTime)
    }
    
    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.stationId, forKey: .stationId)
        try container.encodeIfPresent(self.arrivalTime, forKey: .arrivalTime)
        try container.encodeIfPresent(self.departureTime, forKey: .departureTime)
    }
}
