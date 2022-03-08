////
////  Place.swift
////  FOURSQUARE
////
////  Created by Van Ngoc Duc on 02/03/2022.
////
//
//import Foundation
//
//final class Place {
//    var namePlace: String
//    var imagePlace: String
//    var categoryPlace: String
//    var pointPlace: String
//    var distancePlace: String
//    var addressPlace: String
//    var descPlace: String
//
//    init(namePlace: String, imagePlace: String, categoryPlace: String, pointPlace: String,
//         distancePlace: String, addressPlace: String, descPlace: String){
//        self.namePlace = namePlace
//        self.imagePlace = imagePlace
//        self.categoryPlace = categoryPlace
//        self.pointPlace = pointPlace
//        self.distancePlace = distancePlace
//        self.addressPlace = addressPlace
//        self.descPlace = descPlace
//    }
//
//    static func getDummyData() -> [Place] {
//        var places: [Place] = []
//
//        let namePlace = ["SIX ON SIX", "H Coffee - The Coffee Art", "Bánh cuốn Tiến Hưng","Epice Beverage", "Thanh Tâm Coffee & Bakery", "Diamond Sea Hotel Da Nang", "Retro Kitchen & Bar", "Cộng Cafe", "Temple"]
//        let categoryPlace = ["Café", "Coffee Shop", "Vietnamese Restaurant", "Vietnamese Restaurant", "Bakery", "Hotel", "Restaurant", "Caffe Shop", "Restaurant"]
//        let pointPlace = ["7,8", "8,0", "7,6", "7,2", "8,9", "8,3", "6,2", "7,7", "8,6"]
//        let distancePlace = ["1,5km", "600m", "2,2km","1,5km", "600m", "2,2km","1,5km", "600m", "2,2km"]
//        let addressPlace = ["My An", "Da Nang", "Da Nang", "Da Nang", "Da Nang", "Da Nang", "Da Nang", "Da Nang", "Da Nang"]
//        let descPlace = ["People at this cafe talk about breakfast buritos, coffee, and how cozy it is.",
//                         "Cool assortment of coffee for very reasonable price: coconut coffeeead good - 20k vnd (1 usd), americano was very good - same price. They also have some fast snack menu (for meat lovers), books",
//                         "Really good local delicacy, in malaysia we call it chee cheong fan aka rice flour noodle that serve in brown sauce, in vietnam they serve with fish sauce and fried shallot. Friendly lady boss too",
//                         "People at this cafe talk about breakfast buritos, coffee, and how cozy it is.",
//                         "Cool assortment of coffee for very reasonable price: coconut coffeeead good - 20k vnd (1 usd), americano was very good - same price. They also have some fast snack menu (for meat lovers), books",
//                         "Really good local delicacy, in malaysia we call it chee cheong fan aka rice flour noodle that serve in brown sauce, in vietnam they serve with fish sauce and fried shallot. Friendly lady boss too",
//                         "People at this cafe talk about breakfast buritos, coffee, and how cozy it is.",
//                         "Cool assortment of coffee for very reasonable price: coconut coffeeead good - 20k vnd (1 usd), americano was very good - same price. They also have some fast snack menu (for meat lovers), books",
//                         "Really good local delicacy, in malaysia we call it chee cheong fan aka rice flour noodle that serve in brown sauce, in vietnam they serve with fish sauce and fried shallot. Friendly lady boss too"]
//
//
//        for i in 0...(namePlace.count-1) {
//            //let myPlace = Place(namePlace: "Place Name: \(i)", imagePlace: "demoImagePlace.png",categoryPlace: "Cafe", pointPlace: "8.0", distancePlace: "1,5 km", addressPlace: "Da Nang", descPlace: "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip")
//            let myPlace = Place(namePlace: namePlace[i], imagePlace: "demoImagePlace.png", categoryPlace: categoryPlace[i], pointPlace: pointPlace[i], distancePlace: distancePlace[i], addressPlace: addressPlace[i], descPlace: descPlace[i])
//            places.append(myPlace)
//        }
//        return places
//    }
//}
