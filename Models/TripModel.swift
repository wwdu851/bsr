//
//  TripModel.swift
//  bsr
//
//  Created by William Du on 12/21/25.
//

import SwiftUI

@Observable
final class TripModel {
    var origin: String = ""
    var destination: String = ""
    
    func swap() {
        (origin, destination) = (destination, origin)
    }
}
