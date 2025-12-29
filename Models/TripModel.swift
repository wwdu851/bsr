//
//  TripModel.swift
//  bsr
//
//  Created by William Du on 12/21/25.
//

import SwiftUI

@Observable
final class TripModel {
    var originName: String = ""
    var destinationName: String = ""
    var originId: String = ""
    var destinationId: String = ""
    
    func swap() {
        (originName, destinationName) = (destinationName, originName)
        (originId, destinationId) = (destinationId, originId)
    }
}
