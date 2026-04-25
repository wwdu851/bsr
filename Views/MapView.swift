//
//  MapView.swift
//  bsr
//
//  Created by Codex on 4/25/26.
//

import MapKit
import SwiftData
import SwiftUI

struct MapView: View {
    @Query(sort: \Station.name) private var stations: [Station]
    @Query(sort: \Line.name) private var lines: [Line]

    private var lineSegments: [LineSegment] {
        MapViewModel.makeLineSegments(lines: lines, stations: stations)
    }

    private var coverage: MapCoverage {
        MapViewModel.coverage(stations: stations, segments: lineSegments, lines: lines)
    }

    var body: some View {
        VStack(spacing: 8) {
            Map(initialPosition: initialPosition) {
                ForEach(lineSegments) { segment in
                    if segment.coordinates.count >= 2 {
                        MapPolyline(coordinates: segment.coordinates)
                            .stroke(segment.color, lineWidth: 4)
                    }
                }

                ForEach(stations, id: \.id) { station in
                    Marker(station.name, coordinate: station.coordinate)
                        .tint(.white)
                }
            }
            .mapStyle(.standard(elevation: .flat, emphasis: .muted))

            Text("Stations: \(coverage.plottedStationCount)/\(coverage.stationCount) • Lines rendered: \(coverage.renderedLineCount)/\(coverage.lineCount) • Geometry segs: \(coverage.geometrySegmentCount)")
                .font(.caption)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12)

            Text("Data © OpenStreetMap contributors")
                .font(.caption2)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 12)
                .padding(.bottom, 4)
        }
    }

    private var initialPosition: MapCameraPosition {
        guard !stations.isEmpty else {
            return .region(
                MKCoordinateRegion(
                    center: CLLocationCoordinate2D(latitude: 39.9042, longitude: 116.4074),
                    span: MKCoordinateSpan(latitudeDelta: 1.4, longitudeDelta: 1.4)
                )
            )
        }

        let latitudes = stations.map(\.latitude)
        let longitudes = stations.map(\.longitude)
        guard
            let minLatitude = latitudes.min(),
            let maxLatitude = latitudes.max(),
            let minLongitude = longitudes.min(),
            let maxLongitude = longitudes.max()
        else {
            return .automatic
        }

        let center = CLLocationCoordinate2D(
            latitude: (minLatitude + maxLatitude) / 2,
            longitude: (minLongitude + maxLongitude) / 2
        )
        let span = MKCoordinateSpan(
            latitudeDelta: max((maxLatitude - minLatitude) * 1.4, 0.2),
            longitudeDelta: max((maxLongitude - minLongitude) * 1.4, 0.2)
        )
        return .region(MKCoordinateRegion(center: center, span: span))
    }
}

private extension Station {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

#Preview {
    MapView()
}
