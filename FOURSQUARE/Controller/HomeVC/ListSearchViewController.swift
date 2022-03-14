//
//  ListSearchViewController.swift
//  FOURSQUARE
//
//  Created by Van Ngoc Duc on 02/03/2022.
//

import UIKit
import Alamofire //1

class ListSearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var resultPlace : [Result] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "PlaceTableViewCell", bundle: .main), forCellReuseIdentifier: "PlaceTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
        fetchNearByPlaces()
    }
}
//MARK: -ListSearchViewController: UITableViewDelegate, UITableViewDataSource
extension ListSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultPlace.count
    }

//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceTableViewCell", for: indexPath) as! PlaceTableViewCell
        let item = resultPlace[indexPath.row]
        let cellViewModel = PlaceTableViewCellViewModel(fsqID: item.fsqID, indexPath: String(indexPath.row + 1), title: item.name, subtitle: item.categories.first?.name ?? "", distance: Double(item.distance), locality: item.location.locality ?? "", desc: "", point: "9", imgURL: item.imgURLString)
        cell.updateWith(cellViewModel)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let vc = DetailPlaceInfoViewController()

        self.navigationController?.pushViewController(vc, animated: true)
    }


}

//MARK: -Extension ListSearchViewController
extension ListSearchViewController {
    //MARK: -func fetchNearByPlaces()
    func fetchNearByPlaces(){
        let parameters = ["ll" : "16.0470,108.2062"] //Lat, Long of Da Nang
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

//    func fetchPlaceTip(fsqID: String, titlePlace: String){
//
//        let urlString: String = "https://api.foursquare.com/v3/places/\(fsqID)/tips"
//        let headers: HTTPHeaders = [.authorization("fsq3bLyHTk3rptYmDCK2UC6COiqhyPlEkIqotgeQnebJB48="),
//                                    .accept("application/json")]
//        AF.request(urlString,
//                   method: .get,
//                   headers: headers)
//            .validate()
//            .responseDecodable(of: [PlaceTipElement].self) { (responseData) in
//                guard let data = responseData.value else { return }
//                self.placeTip = data
//                DispatchQueue.main.async {
//                    if data.first?.text != nil {
//                        self.descLabel.text = data.first?.text
//                    } else {
//                        self.descLabel.text  = ""
//                        print("No Place Tips with: \(fsqID) - \(titlePlace)")
//                    }
//                }
//            }
//    }
}


