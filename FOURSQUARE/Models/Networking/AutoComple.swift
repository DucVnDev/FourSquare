// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let autoComple = try? newJSONDecoder().decode(AutoComple.self, from: jsonData)

import Foundation

// MARK: - AutoComple
struct AutoComple: Codable {
    let results: [ResultAuto]
}

// MARK: - Result
struct ResultAuto: Codable {
    let type: TypeEnum
    let text: Text
    let link: String
    let place: Place
}
// MARK: - Text
struct Text: Codable {
    let primary, secondary: String
    let highlight: [Highlight]
}

// MARK: - Highlight
struct Highlight: Codable {
    let start, length: Int
}

enum TypeEnum: String, Codable {
    case place = "place"
}
