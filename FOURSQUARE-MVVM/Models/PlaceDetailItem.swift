// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let detailPlace = try? newJSONDecoder().decode(DetailPlace.self, from: jsonData)

import Foundation

// MARK: - PlaceDetailItem
struct PlaceDetailItem: Codable {
    let fsqID: String
    let categories: [Category]
    let chains: [JSONAny]
    let geocodes: Geocodes
    let location: Location
    let name: String
    let relatedPlaces: RelatedPlaces
    let timezone: String

    enum CodingKeys: String, CodingKey {
        case fsqID = "fsq_id"
        case categories, chains, geocodes, location, name
        case relatedPlaces = "related_places"
        case timezone
    }
}
// MARK: - PlaceDetailViewMode
struct PlaceDetailViewMode {
    var id: String
    var name: String
    var address: String
    var category: String
    var latidute: Double
    var longitude: Double
}
