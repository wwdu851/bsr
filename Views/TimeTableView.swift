//
//  TimeTableView.swift
//  bsr
//
//  Created by William Du on 10/30/25.
//

import SwiftUI
import SwiftData


public struct TimeTableView : View {
    @Environment(TripModel.self) private var trip
    @Environment(\.dismiss) private var dismiss
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
                Text("S101")
                Text("S102")
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
    }
    
}

#Preview {
    TimeTableView()
}
