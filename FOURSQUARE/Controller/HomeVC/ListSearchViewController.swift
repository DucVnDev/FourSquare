//
//  ListSearchViewController.swift
//  FOURSQUARE
//
//  Created by Van Ngoc Duc on 02/03/2022.
//

import UIKit
import Alamofire //1
import CoreLocation

class ListSearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var resultPlace : [Result] = []

    var manager = CLLocationManager()
    var latitude: Double?
    var longitude: Double?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List Places Near Me"
        

        //tableView
        tableView.register(UINib(nibName: "PlaceTableViewCell", bundle: .main), forCellReuseIdentifier: "PlaceTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension

        //Get Current Location
        getCurrentLocation()

        //Load API nearby Place
        fetchNearByPlaces(latitude: String(self.latitude ?? 0), longitude: String(self.longitude ?? 0))
    }

    func getCurrentLocation() {
        //Get my Location
        manager.desiredAccuracy = kCLLocationAccuracyBest //Battery
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        guard let sourceCoordinate = manager.location?.coordinate
        else {
            print("Error Source Coordinate")
            return
        }
        self.latitude = sourceCoordinate.latitude
        self.longitude = sourceCoordinate.longitude
        print(sourceCoordinate.latitude, sourceCoordinate.longitude)
        
    }
}
//MARK: -ListSearchViewController: UITableViewDelegate, UITableViewDataSource
extension ListSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultPlace.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceTableViewCell", for: indexPath) as! PlaceTableViewCell
        let item = resultPlace[indexPath.row]
        let cellViewModel = PlaceTableViewCellViewModel(fsqID: item.fsqID, indexPath: String(indexPath.row + 1), title: item.name, subtitle: item.categories.first?.name ?? "", distance: Double(item.distance), locality: item.location.locality ?? "", desc: "", imgURL: item.imgURLString)
        cell.updateWith(cellViewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = resultPlace[indexPath.row]
        let vc = DetailPlaceInfoViewController()
        vc.infoDetailPlace = PlaceDetailViewMode(id: item.fsqID, name: item.name, address: item.location.formattedAddress, category: item.categories.first?.name ?? "", latidute: item.geocodes.main.latitude, longitude: item.geocodes.main.longitude)
        self.navigationController?.pushViewController(vc, animated: true)
    }


}

extension ListSearchViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("mylocation: \(location.coordinate)")
            manager.stopUpdatingLocation()
//            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//            let region = MKCoordinateRegion(center: location.coordinate, span: span)
//            mapView.showsUserLocation = true
//            mapView.setRegion(region, animated: true)
        }
    }
}
//MARK: -Extension ListSearchViewController
extension ListSearchViewController {
    //MARK: -func fetchNearByPlaces()
    func fetchNearByPlaces(latitude: String, longitude: String){
        let parameters = ["ll" : "\(latitude),\(longitude)"] //Lat, Long of Da Nang
        let headers: HTTPHeaders = [.authorization("fsq3bLyHTk3rptYmDCK2UC6COiqhyPlEkIqotgeQnebJB48="),
                                    .accept("application/json")]

        AF.request("https://api.foursquare.com/v3/places/nearby",parameters: parameters,headers: headers)
            .validate() // added validation
            .responseDecodable(of: Place.self) { response in
                debugPrint(response)
                guard let place = response.value else { return }
                self.resultPlace = place.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
    }
}
