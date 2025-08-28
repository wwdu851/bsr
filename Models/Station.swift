//
//  Station.swift
//  bsr
//
//  Created by William Du on 8/19/25.
//

import Foundation
import SwiftData

@Model
class Station: Codable {
    @Attribute(.unique) var id: String
    
    var name: String
    var latitude: Double
    var longitude: Double
    var lines: [String]
    
    public init(name: String, latitude: String, longitude: Double, lines: [String]) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.lines = lines
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case latitude
        case longitude
        case lines
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.latitude = try container.decode(Double.self, forKey: .latitude)
        self.longitude = try container.decode(Double.self, forKey: .longitude)
        self.lines = try container.decode([String].self, forKey: .lines)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(lines, forKey: .lines)
    }
}
