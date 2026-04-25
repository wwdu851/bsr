//
//  RailGeometryData.swift
//  bsr
//
//  Created by Codex on 4/25/26.
//

import Foundation
import MapKit

struct RailGeometrySegment: Identifiable {
    let id: String
    let lineID: String
    let branchID: String?
    let coordinates: [CLLocationCoordinate2D]
}

enum RailGeometryData {
    static func loadSegments() -> [RailGeometrySegment] {
        guard let url = Bundle.main.url(forResource: "rail_geometry", withExtension: "geojson") else {
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let featureCollection = try JSONDecoder().decode(GeoJSONFeatureCollection.self, from: data)
            return featureCollection.features.compactMap(featureToSegment)
        } catch {
            print("⚠️ Failed to load rail geometry GeoJSON: \(error.localizedDescription)")
            return []
        }
    }

    private static func featureToSegment(_ feature: GeoJSONFeature) -> RailGeometrySegment? {
        guard let lineID = feature.properties.lineID else {
            return nil
        }

        let coordinates: [CLLocationCoordinate2D]
        switch feature.geometry {
        case .lineString(let points):
            coordinates = points.map(\.coordinate)
        case .multiLineString(let lines):
            coordinates = lines.flatMap { $0.map(\.coordinate) }
        }

        guard coordinates.count >= 2 else {
            return nil
        }

        return RailGeometrySegment(
            id: feature.id ?? "\(lineID)-\(feature.properties.branchID ?? "main")",
            lineID: lineID,
            branchID: feature.properties.branchID,
            coordinates: coordinates
        )
    }
}

private struct GeoJSONFeatureCollection: Decodable {
    let type: String
    let features: [GeoJSONFeature]
}

private struct GeoJSONFeature: Decodable {
    let id: String?
    let geometry: GeoJSONGeometry
    let properties: GeoJSONProperties
}

private struct GeoJSONProperties: Decodable {
    let lineID: String?
    let branchID: String?

    enum CodingKeys: String, CodingKey {
        case lineID
        case branchID
    }
}

private enum GeoJSONGeometry: Decodable {
    case lineString([GeoPoint])
    case multiLineString([[GeoPoint]])

    private enum CodingKeys: String, CodingKey {
        case type
        case coordinates
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "LineString":
            let coordinates = try container.decode([[Double]].self, forKey: .coordinates)
            self = .lineString(coordinates.compactMap(GeoPoint.init(raw:)))
        case "MultiLineString":
            let coordinates = try container.decode([[[Double]]].self, forKey: .coordinates)
            self = .multiLineString(coordinates.map { $0.compactMap(GeoPoint.init(raw:)) })
        default:
            throw DecodingError.dataCorruptedError(
                forKey: .type,
                in: container,
                debugDescription: "Unsupported geometry type: \(type)"
            )
        }
    }
}

private struct GeoPoint {
    let longitude: Double
    let latitude: Double

    init?(raw: [Double]) {
        guard raw.count >= 2 else {
            return nil
        }
        self.longitude = raw[0]
        self.latitude = raw[1]
    }

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
