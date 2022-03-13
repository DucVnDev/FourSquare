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

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PlaceTableViewCell", bundle: .main), forCellReuseIdentifier: "PlaceTableViewCell")

        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 145

        commonInit()
        fetchNearByPlaces()
    }

    override func viewDidAppear(_ animated: Bool) {
        self.tableView.reloadData()

        }
}
//MARK: -ListSearchViewController: UITableViewDelegate, UITableViewDataSource
extension ListSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultPlace.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let placeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PlaceTableViewCell", for: indexPath) as! PlaceTableViewCell

        let item = resultPlace[indexPath.row]

        let cellViewModel = PlaceTableViewCellViewModel(fsqID: item.fsqID, indexPath: String(indexPath.row + 1), title: item.name, subtitle: item.categories.first?.name ?? "", distance: Double(item.distance), locality: item.location.locality ?? "", desc: "", point: "9", imgURL: "")

        placeTableViewCell.updateWith(cellViewModel)

        return placeTableViewCell


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
                DispatchQueue.main.async {
                    self.resultPlace = place.results
                    self.tableView.reloadData()
                }
            }
    }
}
