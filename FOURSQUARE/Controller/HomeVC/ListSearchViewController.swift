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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "List Places Near Me"

        //tableView
        tableView.register(UINib(nibName: "PlaceTableViewCell", bundle: .main), forCellReuseIdentifier: "PlaceTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension

        //Get my Location
        guard let sourceCoordinate = manager.location?.coordinate else { return }
        print(sourceCoordinate.latitude, sourceCoordinate.longitude)

        //Load API nearby Place
        fetchNearByPlaces(latitude: String(sourceCoordinate.latitude), longitude: String(sourceCoordinate.longitude))
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
                guard let place = response.value else { return }
                self.resultPlace = place.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
    }
}
