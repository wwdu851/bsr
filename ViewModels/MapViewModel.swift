//
//  MapViewModel.swift
//  bsr
//
//  Created by Codex on 4/25/26.
//

import Foundation
import MapKit
import SwiftUI

struct LineSegment: Identifiable {
    let id: String
    let lineID: String
    let lineName: String
    let branchID: String?
    let name: String
    let coordinates: [CLLocationCoordinate2D]
    let color: Color
    let source: SegmentSource
}

enum SegmentSource {
    case geometry
    case stationFallback
}

struct MapCoverage {
    let stationCount: Int
    let plottedStationCount: Int
    let lineCount: Int
    let renderedLineCount: Int
    let geometrySegmentCount: Int
    let fallbackSegmentCount: Int
}

enum MapViewModel {
    static func makeLineSegments(lines: [Line], stations: [Station]) -> [LineSegment] {
        let stationByID = Dictionary(uniqueKeysWithValues: stations.map { ($0.id, $0) })
        let geometryByLineID = Dictionary(grouping: RailGeometryData.loadSegments(), by: \.lineID)
        var segments: [LineSegment] = []

        for line in lines {
            if let geometrySegments = geometryByLineID[line.id], !geometrySegments.isEmpty {
                for geometrySegment in geometrySegments {
                    guard geometrySegment.coordinates.count >= 2 else {
                        continue
                    }
                    segments.append(
                        LineSegment(
                            id: geometrySegment.id,
                            lineID: line.id,
                            lineName: line.name,
                            branchID: geometrySegment.branchID,
                            name: line.name,
                            coordinates: geometrySegment.coordinates,
                            color: color(for: line.id),
                            source: .geometry
                        )
                    )
                }
                validateS2GeometryIfNeeded(lineID: line.id, geometrySegments: geometrySegments)
                continue
            }

            let fallbackSegments = fallbackSegments(for: line, stationByID: stationByID)
            if line.id == "s2", fallbackSegments.count < 2 {
                print("⚠️ S2 fallback did not produce both expected branches.")
            }
            segments.append(contentsOf: fallbackSegments)
        }

        return segments
    }

    static func coverage(stations: [Station], segments: [LineSegment], lines: [Line]) -> MapCoverage {
        let renderedLineCount = Set(segments.map(\.lineID)).count
        let geometrySegmentCount = segments.filter { $0.source == .geometry }.count
        let fallbackSegmentCount = segments.filter { $0.source == .stationFallback }.count
        return MapCoverage(
            stationCount: stations.count,
            plottedStationCount: stations.count,
            lineCount: lines.count,
            renderedLineCount: renderedLineCount,
            geometrySegmentCount: geometrySegmentCount,
            fallbackSegmentCount: fallbackSegmentCount
        )
    }

    private static func fallbackSegments(for line: Line, stationByID: [String: Station]) -> [LineSegment] {
        var missingStationIDs: [String] = []

        func coordinates(from stationIDs: [String]) -> [CLLocationCoordinate2D] {
            stationIDs.compactMap { stationID in
                guard let station = stationByID[stationID] else {
                    missingStationIDs.append(stationID)
                    return nil
                }
                return CLLocationCoordinate2D(latitude: station.latitude, longitude: station.longitude)
            }
        }

        let stationPaths: [[String]]
        if line.id == "s2" {
            stationPaths = [
                ["huangtudian", "nankou", "badaling", "kangzhuang", "shacheng"],
                ["huangtudian", "nankou", "badaling", "yanqing"]
            ]
        } else {
            stationPaths = [line.stations]
        }

        let segments = stationPaths.enumerated().compactMap { index, stationIDs -> LineSegment? in
            let coordinates = coordinates(from: stationIDs)
            guard coordinates.count >= 2 else {
                return nil
            }
            let branchID = line.id == "s2" ? (index == 0 ? "to_shacheng" : "to_yanqing") : nil
            return LineSegment(
                id: "\(line.id)-fallback-\(branchID ?? "main")",
                lineID: line.id,
                lineName: line.name,
                branchID: branchID,
                name: line.name,
                coordinates: coordinates,
                color: color(for: line.id),
                source: .stationFallback
            )
        }

        if !missingStationIDs.isEmpty {
            print("⚠️ Map missing station IDs for line \(line.id): \(missingStationIDs.joined(separator: ", "))")
        }
        return segments
    }

    private static func validateS2GeometryIfNeeded(lineID: String, geometrySegments: [RailGeometrySegment]) {
        guard lineID == "s2" else {
            return
        }
        let branchIDs = Set(geometrySegments.compactMap(\.branchID))
        let expected: Set<String> = ["to_shacheng", "to_yanqing"]
        let missing = expected.subtracting(branchIDs)
        if !missing.isEmpty {
            print("⚠️ S2 geometry missing branch IDs: \(missing.sorted().joined(separator: ", "))")
        }
    }

    private static func color(for lineID: String) -> Color {
        let palette: [Color] = [.blue, .green, .orange, .purple, .red, .teal, .pink, .indigo, .mint]
        let hashValue = lineID.unicodeScalars.reduce(0) { partialResult, scalar in
            partialResult + Int(scalar.value)
        }
        return palette[hashValue % palette.count]
    }
}
