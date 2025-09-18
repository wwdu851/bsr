//
//  Line.swift
//  bsr
//
//  Created by William Du on 8/19/25.
//

import Foundation
import SwiftData

@Model
class Line : Codable{
    @Attribute(.unique) var id: String
    
    var name: String
    var stations: [String]
    var fareTableId: String
    
    init(id: String, name: String, stations: [String], fareTableId: String) {
        self.id = id
        self.name = name
        self.stations = stations
        self.fareTableId = fareTableId
    }
    
    enum CodingKeys : String, CodingKey{
        case id
        case name
        case stations
        case fareTableId = "fare_table_id"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.stations = try container.decode([String].self, forKey: .stations)
        self.fareTableId = try container.decode(String.self, forKey: .fareTableId)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.id, forKey: .id)
        try container.encode(self.name, forKey: .name)
        try container.encode(self.stations, forKey: .stations)
        try container.encode(self.fareTableId, forKey: .fareTableId)
    }
}
