# Rail Geometry Data Refresh

This project uses Apple Maps (`MapKit`) as the base map and overlays railway geometry from an offline GeoJSON file:

- `Resources/rail_geometry.geojson`

## Data Source

- Source network geometry from OpenStreetMap (OSM), optionally explored via OpenRailwayMap.
- Attribution requirement in app UI: `Data © OpenStreetMap contributors`.

## Recommended Refresh Workflow

1. Open [Overpass Turbo](https://overpass-turbo.eu/).
2. Run line-focused queries for each BSR line and export as GeoJSON.
3. Normalize each feature to include:
   - `lineID` (matches `Line.id` in app data),
   - `branchID` (use `to_shacheng` and `to_yanqing` for S2),
   - geometry as `LineString` or `MultiLineString`.
4. Merge exported features into one `FeatureCollection`.
5. Simplify geometry conservatively (preserve station-area bends and branch divergence points).
6. Save to `Resources/rail_geometry.geojson`.
7. Launch app and verify:
   - all expected lines render,
   - S2 has both branches after Badaling,
   - fallback paths appear only when geometry is missing.

## Example Overpass Query Skeleton

Use this as a starting point and adapt tags/area filters per line:

```overpass
[out:json][timeout:60];
(
  relation["route"="railway"]["ref"="S2"](around:40000,40.20,116.20);
);
(._;>;);
out geom;
```

## Notes

- Public Overpass endpoints are rate-limited; avoid high-frequency runtime queries in-app.
- Keep runtime behavior offline-first by bundling GeoJSON in app resources.
