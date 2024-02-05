//
//  LocationService.swift
//  vino
//
//  Created by Jon Grimes on 1/8/24.
//

import Foundation
import MapKit

struct SearchCompletions: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let subTitle: String
    var url: URL?
}

struct SearchResult: Identifiable, Hashable {
    let id = UUID()
    let location: CLLocationCoordinate2D

    static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

struct vineyardLocation: Identifiable, Hashable {
    let id = UUID()
    let location: CLLocationCoordinate2D

    static func == (lhs: vineyardLocation, rhs: vineyardLocation) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

@Observable
class LocationService: NSObject, MKLocalSearchCompleterDelegate {
    private let completer: MKLocalSearchCompleter

    var completions = [SearchCompletions]()

    init(completer: MKLocalSearchCompleter) {
        self.completer = completer
        super.init()
        self.completer.delegate = self
    }

    func update(queryFragment: String) {
        completer.resultTypes = .pointOfInterest
        completer.queryFragment = queryFragment
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completions = completer.results.map { completion in
            // Get the private _mapItem property
            let mapItem = completion.value(forKey: "_mapItem") as? MKMapItem

            return .init(
                title: completion.title,
                subTitle: completion.subtitle,
                url: mapItem?.url
            )
        }
    }
    
    func search(with query: String, coordinate: CLLocationCoordinate2D? = nil) async throws -> [SearchResult] {
           let mapKitRequest = MKLocalSearch.Request()
           mapKitRequest.naturalLanguageQuery = query
           mapKitRequest.resultTypes = .pointOfInterest
           if let coordinate {
               mapKitRequest.region = .init(.init(origin: .init(coordinate), size: .init(width: 1, height: 1)))
           }
           let search = MKLocalSearch(request: mapKitRequest)

           let response = try await search.start()

           return response.mapItems.compactMap { mapItem in
               guard let location = mapItem.placemark.location?.coordinate else { return nil }

               return .init(location: location)
           }
       }
}
