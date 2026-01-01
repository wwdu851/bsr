//
//  SearchSheetView.swift
//  bsr
//
//  Created by William Du on 8/13/25.
//

import SwiftUI
import SwiftData

struct SearchSheetView: View {
    @Binding var originId: String
    @Binding var originName: String
    @Binding var destinationId: String
    @Binding var destinationName: String
    
    let editingField: FieldKind

    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: FieldKind?
    
    let onStationSelected: () -> Void

    @Query var allStations: [Station]

    private var filteredStations: [Station] {
        let q = currentText.trimmingCharacters(in: .whitespacesAndNewlines)
        return q.isEmpty
            ? allStations
            : allStations.filter { $0.name.localizedCaseInsensitiveContains(q) }
    }

    private var currentText: String {
        editingField == .origin ? originName : destinationName
    }

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Spacer()
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.secondary)
                }
                .padding(.trailing)
            }
            VStack(spacing: 0) {
                HStack(spacing: 10) {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 8, height: 8)
                    TextField("Origin", text: $originName)
                        .focused($focusedField, equals: .origin)
                }
                .padding(12)
                .background(Color(.systemGray6))
                .overlay(
                    Rectangle()
                        .frame(height: 1)
                        .foregroundColor(Color(.separator))
                        .padding(.leading, 30)
                        .padding(.trailing, 12),
                    alignment: .bottom
                )

                HStack(spacing: 10) {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(Color.gray)
                        .frame(width: 8, height: 8)
                    TextField("Destination", text: $destinationName)
                        .focused($focusedField, equals: .destination)
                }
                .padding(12)
                .background(Color(.systemGray6))
            }
            .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
            .padding(.horizontal)

            List {
                ForEach(filteredStations, id: \.self) { station in
                    Button {
                        if editingField == .origin {
                            originName = station.name
                            originId = station.id
                        } else {
                            destinationName = station.name
                            destinationId = station.id
                        }
                        onStationSelected()
                        dismiss()
                    } label: {
                        Text(station.name)
                    }
                    
                }
            }
            .listStyle(.plain)
        }
        .padding(.top, 15)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                focusedField = editingField
            }
        }
    }
}
