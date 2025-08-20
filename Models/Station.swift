//
//  Station.swift
//  bsr
//
//  Created by William Du on 8/19/25.
//

import Foundation
import SwiftData

@Model
class Station: Identifiable {
    @Attribute(.unique) var id: String
    
    var name: String
    var latitude: String
    var longitude: Double
    var lines: [String]
    
    public init(name: String, latitude: String, longitude: Double, lines: [String]) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.lines = lines
    }
}
