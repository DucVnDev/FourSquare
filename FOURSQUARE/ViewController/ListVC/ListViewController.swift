//
//  ListSearchViewController.swift
//  FOURSQUARE
//
//  Created by Van Ngoc Duc on 02/03/2022.
//

import UIKit
import Alamofire
import CoreLocation

class ListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var resultPlace : [Result] = []

    var manager = CLLocationManager()
    var latitude: Double?
    var longitude: Double?

    var networkingApi = NetworkingAPI()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List Places"
        //Get Current Location
        getCurrentLocation()
        //Fetch Place Near Me
        fetchPlaceNearMe()
        //SetupTableView
        setupTableView()
    }


    // MARK: - Private Methods
    private func getCurrentLocation() {
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
    }

    private func fetchPlaceNearMe() {
        networkingApi.fetchNearByPlaces(latitude: self.latitude ?? 0, longitude: self.longitude ?? 0) { [weak self] result in
            self?.resultPlace = result
            DispatchQueue.main.async { // Change UI
                self?.tableView.reloadData()
            }
        }
    }

    private func setupTableView() {
        //Register Xib
        tableView.register(UINib(nibName: "PlaceTableViewCell", bundle: .main), forCellReuseIdentifier: "PlaceTableViewCell")

        //Delegate & DataSource
        tableView.delegate = self
        tableView.dataSource = self

        //Estimate Row Height
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
}

//MARK: -ListSearchViewController: UITableViewDelegate, UITableViewDataSource
extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultPlace.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceTableViewCell", for: indexPath) as! PlaceTableViewCell
        let item = resultPlace[indexPath.row]
        let cellViewModel = PlaceTableViewCellViewModel(fsqID: item.fsqID, indexPath: String(indexPath.row + 1), title: item.name, subtitle: item.categories.first?.name ?? "", distance: Double(item.distance), locality: item.location.locality ?? "", desc: "", imgURL: item.imgURLString)
        cell.updateCellWith(cellViewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = resultPlace[indexPath.row]
        let vc = DetailPlaceInfoViewController()
        vc.infoDetailPlace = PlaceDetailViewMode(id: item.fsqID, name: item.name, address: item.location.formattedAddress, category: item.categories.first?.name ?? "", latidute: item.geocodes.main.latitude, longitude: item.geocodes.main.longitude)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: -ListSearchViewController: CLLocationManagerDelegate
extension ListViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print("mylocation: \(location.coordinate)")
            manager.stopUpdatingLocation()
        }
    }
}
