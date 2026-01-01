//
//  ContentView.swift
//  bsr
//
//  Created by William Du on 8/12/25.
//

import SwiftUI
import SwiftData

enum FieldKind: String, Identifiable {
    case origin, destination
    var id: String { rawValue }
}

enum CurrentView: String, CaseIterable, Identifiable {
    case timetable, map
    var id: String { rawValue }
}

enum NavigationDestination: Hashable {
    case timetable
    case trainDetail(trainId: String)
    case stationInfo(stationId: String)
}

struct ContentView: View {
    @Environment(TripModel.self) private var trip

    @State private var editingField: FieldKind? = nil
    @State private var selectedView: CurrentView = .timetable
    
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath){
            VStack {
                Picker("CurrentView", selection: $selectedView) {
                    Text("Timetable").tag(CurrentView.timetable)
                    Text("Map").tag(CurrentView.map)
                }
                .pickerStyle(.segmented)
                .padding()
                ZStack(alignment: .trailing) {
                    VStack(spacing: 0) {
                        Button {
                            editingField = .origin
                        } label: {
                            HStack(spacing: 10) {
                                Circle()
                                    .fill(Color.gray)
                                    .frame(width: 8, height: 8)
                                Text(trip.originName.isEmpty ? "Origin" : trip.originName)
                                    .foregroundColor(
                                        trip.originName.isEmpty ? .gray : .primary
                                    )
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
                                Text(trip.destinationName.isEmpty ? "Destination" : trip.destinationName)
                                    .foregroundColor(trip.destinationName.isEmpty ? .gray : .primary)
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
            }
            .navigationTitle("Plan")
            .navigationBarTitleDisplayMode(.inline)
            .navigationDestination(for: NavigationDestination.self) { value in
                switch value {
                case .timetable:
                    TimeTableView()
                case .trainDetail:
                    Text("Train details comming soon...")
                case .stationInfo:
                    Text("Station info comming soon...")
                }
            }
            .sheet(item: $editingField) { field in
                @Bindable var trip = trip
                SearchSheetView(
                    originId: $trip.originId,
                    originName: $trip.originName,
                    destinationId: $trip.destinationId,
                    destinationName: $trip.destinationName,
                    editingField: field,
                    onStationSelected: {
                        if !trip.originId.isEmpty && !trip.destinationId.isEmpty {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                                navigationPath.append(NavigationDestination.timetable)
                            }
                        }
                    }
                )
                .presentationBackgroundInteraction(.disabled)
                .presentationDetents([.large])
                .presentationDragIndicator(.hidden)
            }
        }
    }
}

#Preview {
    ContentView()
}
