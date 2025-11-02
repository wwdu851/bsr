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

struct ContentView: View {
    @State private var origin: String = ""
    @State private var destination: String = ""

    @State private var editingField: FieldKind? = nil
    @State private var selectedView: CurrentView = .timetable
    
    @State private var navigationPath: [AnyHashable] = []

    var body: some View {
        NavigationStack{
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
                                Text(origin.isEmpty ? "Origin" : origin)
                                    .foregroundColor(origin.isEmpty ? .gray : .primary)
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
                                Text(destination.isEmpty ? "Destination" : destination)
                                    .foregroundColor(destination.isEmpty ? .gray : .primary)
                                Spacer()
                            }
                            .padding(12)
                            .background(Color(.systemGray6))
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .padding(.horizontal)

                    Button {
                        swap(&origin, &destination)
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
            .sheet(item: $editingField) { field in
                SearchSheetView(
                    origin: $origin,
                    destination: $destination,
                    editingField: field
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
