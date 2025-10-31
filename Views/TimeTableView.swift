//
//  TimeTableView.swift
//  bsr
//
//  Created by William Du on 10/30/25.
//

import SwiftUI
import SwiftData

public struct TimeTableView : View {
    @Binding var origin: String
    @Binding var destination: String
    
    public var body: some View {
        List {
            Text("S101")
            Text("S102")
        }
    }
}
