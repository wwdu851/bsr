//
//  TimeTableView.swift
//  bsr
//
//  Created by William Du on 10/30/25.
//

import SwiftUI
import SwiftData

enum TrainLine: String {
    case s2
    case huaimi
    case tongmi
    case subcenter
}

public struct TimeTableView : View {
    @Environment(TripModel.self) private var trip
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var viewModel: TimeTableViewModel?
    @State private var editingField: FieldKind? = nil
    
    public var body: some View {
        VStack {
            ZStack(alignment: .trailing) {
                VStack(spacing: 0) {
                    Button {
                        editingField = .origin
                    } label: {
                        HStack(spacing: 10) {
                            Circle()
                                .fill(Color.gray)
                                .frame(width: 8, height: 8)
                            Text(trip.origin.isEmpty ? "Origin" : trip.origin)
                                .foregroundColor(trip.origin.isEmpty ? .gray : .primary)
                            Spacer()
                        }
                        .padding(12)
                        .background(Color(.systemGray6))
                    }
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color(.separator))
                            .padding(.horizontal, 30),
                        alignment: .bottom
                    )
                    
                    Button {
                        editingField = .destination
                    } label: {
                        HStack(spacing: 10) {
                            RoundedRectangle(cornerRadius: 2)
                                .fill(Color.gray)
                                .frame(width: 8, height: 8)
                            Text(trip.destination.isEmpty ? "Destination" : trip.destination)
                                .foregroundColor(trip.destination.isEmpty ? .gray : .primary)
                            Spacer()
                        }
                        .padding(12)
                        .background(Color(.systemGray6))
                    }
                }
                .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                .padding(.horizontal)
                
                Button {
                    trip.swap()
                } label: {
                    Image(systemName: "arrow.up.arrow.down.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                        .background(Color(.systemGray6))
                        .clipShape(Circle())
                }
                .offset(x: -30)
            }
            Spacer()
            List {
                if let connections = viewModel?.connections {
                    ForEach(connections) { connection in
                        TimeTableCellView(connection: connection)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .tint(.accent)
                }
            }
        }
        .navigationTitle("Connections")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel = TimeTableViewModel(origin: trip.origin, destination: trip.destination, context: modelContext)
            viewModel?.loadConnections()
        }
    }
}

struct TimeTableCellView: View {
    let connection: TimetableConnection

    var body: some View {
        let trainLine = TrainLine(rawValue: connection.line)
        VStack(alignment: .leading) {
            HStack() {
                HStack(spacing: 8) {
                    Image(systemName: "lightrail.fill")
                    Text(trainLine?.rawValue.capitalized ?? "S2")
                }
                .frame(minWidth: 68, alignment: .leading)
                .font(.caption)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background {
                    switch trainLine {
                    case .s2: Color.s2Background
                    case .huaimi:
                        Color.huaimiBackground
                    case .tongmi:
                        Color.tongmiBackground
                    case .subcenter:
                        Color.subcenterBackground
                    default:
                        Color.s2Background
                    }
                }
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                Text("Direction \(connection.id)")
                Spacer()
            }
            HStack {
                Text(connection.departureTime)
                    .font(.title3)
                    .fontWeight(.bold)
                Circle()
                    .frame(width: 8, height: 8)
                Rectangle()
                    .frame(height: 2)
                    .padding(.horizontal, -8)
                Circle()
                    .frame(width: 8, height: 8)
                Text(connection.arrivalTime)
                    .font(.title3)
                    .fontWeight(.bold)
            }
            HStack {
                Text("\(connection.interval) mins")
                Spacer()
                Text("¥\(connection.fare)")
            }
            
        }
    }
}
