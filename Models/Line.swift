//
//  Line.swift
//  bsr
//
//  Created by William Du on 8/19/25.
//

import Foundation
import SwiftData

@Model
class Line {
    @Attribute(.unique) var id: String
    
    var name: String
    var stations: [Station]
    var fareTableId: String
    
    init(name: String, stations: [Station], fareTableId: String) {
        self.name = name
        self.stations = stations
        self.fareTableId = fareTableId
    }
}
