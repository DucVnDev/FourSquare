import Foundation
import RealmSwift

class FavoritePlacesItem: Object {
    @Persisted(primaryKey: true) var id: String = ""
    @Persisted var name: String?
    @Persisted var address: String?
    @Persisted var category: String?
    @Persisted var distance: String?
    @Persisted var latitude: Double?
    @Persisted var longitude: Double?


    convenience init(id: String, name: String, address: String, category: String, latitude: Double, longitude: Double) {
        self.init()
        self.id = id
        self.name = name
        self.address = address
        self.category = category
        self.latitude =  latitude
        self.longitude = longitude
    }
}
