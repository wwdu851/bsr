# Beijing Suburban Railway (BSR) Project

This project is a mobile application (SwiftUI) designed for planning trips and viewing information about the Beijing Suburban Railway (BSR) system.

## Core Stack
- **Language:** Swift
- **UI Framework:** SwiftUI
- **Persistence:** SwiftData
- **Mapping:** MapKit
- **Data Format:** JSON / GeoJSON

## Project Structure

### Data Models (`Models/`)
- `Station`: Represents a railway station with its geographic coordinates and associated lines.
- `Line`: Represents a railway line and the sequence of stations it serves.
- `Train`: Represents a specific train service, including its schedule and days of operation.
- `Stop`: A component of a train's schedule, linking it to a station with arrival/departure times.
- `TripModel`: An `@Observable` class managing the current origin and destination selection for trip planning.

### Data Management (`Data/`)
- `DataImporter`: Orchestrates the initial import of data from JSON resources into the SwiftData container upon app launch.
- `StationData`, `LineData`, `TrainData`: Specialized importers for each data type.
- `RailGeometryData`: Handles loading GeoJSON data for accurate map rendering of rail lines.

### ViewModels (`ViewModels/`)
- `TimeTableViewModel`: Finds and sorts train connections between selected origin and destination stations.
- `MapViewModel`: Processes station and line data to generate segments for the map view, utilizing GeoJSON geometry when available or falling back to station-to-station lines.

### Views (`Views/`)
- `ContentView`: The main application shell, featuring a toggle between Timetable and Map views.
- `MapView`: An interactive map displaying stations as markers and rail lines as polylines.
- `TimeTableView`: Displays a list of available train connections for the planned trip, including departure/arrival times, duration, and fare.
- `SearchSheetView`: A searchable interface for selecting stations.

## Resources
- `Resources/stations.json`: Master list of stations.
- `Resources/lines.json`: Definition of railway lines and their station sequences.
- `Resources/trains_index.json`: Index of all train service files.
- `Resources/trains/*.json`: Individual schedule data for each train service.
- `Resources/rail_geometry.geojson`: Geographic segments for high-fidelity line rendering on the map.

## Key Features
1. **Trip Planning:** Select origin and destination stations to see available train connections.
2. **Interactive Map:** View the entire suburban railway network with accurate geographic paths.
3. **Persistent Storage:** Uses SwiftData to store and query railway information efficiently.
4. **Data-Driven:** The app's content is entirely defined by local JSON resources, allowing for easy updates to schedules and network changes.
