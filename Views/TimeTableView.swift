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
            List {
                Text("S101")
                Text("S102")
            }
        }
    }
}

#Preview {
    TimeTableView(origin: nil, destination: nil, editingField: .origin)
}
