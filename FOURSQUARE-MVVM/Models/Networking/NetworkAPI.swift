//
//  NetworkAPI.swift
//  FOURSQUARE
//
//  Created by Van Ngoc Duc on 02/04/2022.
//

import Foundation
import Alamofire

protocol NetworkingService {
    func fetchNearByPlaces(latitude: Double, longitude: Double, completion: @escaping (([Result]) -> ()))
    func fetchPhotoWith(fsqID: String, completion: @escaping (([PlacePhotoElement]) -> ()))
    func fetchTipsWith(fsqID: String, completion: @escaping (([PlaceTipElement]) -> ()))
    func fetchDetailPlaceWith(fsqID: String, completion: @escaping ((PlaceDetailItem) -> ()))
}

final class NetworkingAPI: NetworkingService {
    
    func fetchPhotoWith(fsqID: String, completion: @escaping (([PlacePhotoElement]) -> ())) {
        let urlString: String = "https://api.foursquare.com/v3/places/\(fsqID)/photos"
        let headers: HTTPHeaders = [.authorization("fsq3bLyHTk3rptYmDCK2UC6COiqhyPlEkIqotgeQnebJB48="),
                                    .accept("application/json")]
        AF.request(urlString,
                   method: .get,
                   headers: headers)
        .validate()
        .responseDecodable(of: [PlacePhotoElement].self) { response in
            guard let data = response.value else { return }
            completion(data)
        }
    }

    func fetchNearByPlaces(latitude: Double, longitude: Double, completion: @escaping (([Result]) -> ())) {
        let parameters = ["ll" : "\(latitude),\(longitude)"]
        let headers: HTTPHeaders = [.authorization("fsq3bLyHTk3rptYmDCK2UC6COiqhyPlEkIqotgeQnebJB48="),
                                    .accept("application/json")]

        AF.request("https://api.foursquare.com/v3/places/nearby",parameters: parameters,headers: headers)
            .validate() // added validation
            .responseDecodable(of: Place.self) { response in
                debugPrint(response)
                guard let place = response.value
                else {
                    return
                }
                completion(place.results)
            }
    }

    func fetchDetailPlaceWith(fsqID: String, completion: @escaping ((PlaceDetailItem) -> ())) {
        let headers: HTTPHeaders = [.authorization("fsq3bLyHTk3rptYmDCK2UC6COiqhyPlEkIqotgeQnebJB48="),
                                    .accept("application/json")]
        AF.request("https://api.foursquare.com/v3/places/\(fsqID)",headers: headers)
            .validate() // added validation
            .responseDecodable(of: PlaceDetailItem.self) { response in
                guard let data = response.value else { return }
                completion(data)
            }
    }

    func fetchTipsWith(fsqID: String, completion: @escaping (([PlaceTipElement]) -> ())) {
        let urlString: String = "https://api.foursquare.com/v3/places/\(fsqID)/tips"
        let headers: HTTPHeaders = [.authorization("fsq3bLyHTk3rptYmDCK2UC6COiqhyPlEkIqotgeQnebJB48="),
                                    .accept("application/json")]
        AF.request(urlString,
                   method: .get,
                   headers: headers)
        .validate()
        .responseDecodable(of: [PlaceTipElement].self) { responseData in
            guard let data = responseData.value else { return }
            completion(data)
        }
    }
}
