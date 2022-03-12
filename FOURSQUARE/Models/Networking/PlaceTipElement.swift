import Foundation

// MARK: - PlaceTipElement
struct PlaceTipElement: Codable {
    let id, createdAt, text: String

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case text
    }
}

typealias PlaceTip = [PlaceTipElement]
