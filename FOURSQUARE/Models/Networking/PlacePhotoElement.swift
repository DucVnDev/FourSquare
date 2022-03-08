import Foundation

//// MARK: - PlacePhoto
//struct PlacePhoto: Codable {
//    let results: [PlacePhotoElement]
//}

// MARK: - PlacePhotoElement
struct PlacePhotoElement: Decodable {
    let id, createdAt: String
    let placePhotoPrefix: String
    let suffix: String
    let width, height: Int
    let classifications: [String]?

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case placePhotoPrefix = "prefix"
        case suffix, width, height, classifications
    }
}
