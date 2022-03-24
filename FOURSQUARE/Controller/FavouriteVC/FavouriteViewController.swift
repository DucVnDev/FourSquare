//
//  FavouriteViewController.swift
//  FOURSQUARE
//
//  Created by Van Ngoc Duc on 23/03/2022.
//
import UIKit
import Alamofire
import SDWebImage
import RealmSwift

class FavouriteViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    var detailPlace : [Result] = []

    var realm = try! Realm()
    var place = try! Realm().objects(FavoritePlacesItem.self)

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favourite Places"

        //TableView
        tableView.register(UINib(nibName: "PlaceTableViewCell", bundle: .main), forCellReuseIdentifier: "PlaceTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self

        //Realm
        let path = realm.configuration.fileURL!.path
        print("Path: \(String(describing: path))")
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
}
//MARK: -ListSearchViewController: UITableViewDelegate, UITableViewDataSource
extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return place.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceTableViewCell", for: indexPath) as! PlaceTableViewCell
        let idPlace = place[indexPath.row].id
        cell.updateWithId(id: idPlace, indexPath: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let idPlace = place[indexPath.row].id
        print("Row is Click: \(idPlace)")
        fetchNDetailPlace(fsqID: idPlace)
        let item = detailPlace.first!
        let vc = DetailPlaceInfoViewController()
        vc.infoDetailPlace = PlaceDetailViewMode(id: item.fsqID, name: item.name, address: item.location.formattedAddress, category: item.categories.first?.name ?? "", latidute: item.geocodes.main.latitude, longitude: item.geocodes.main.longitude)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}


extension FavouriteViewController {
    //MARK: Load API Detail Place
    func fetchNDetailPlace(fsqID: String) {
        let headers: HTTPHeaders = [.authorization("fsq3bLyHTk3rptYmDCK2UC6COiqhyPlEkIqotgeQnebJB48="),
                                    .accept("application/json")]
        AF.request("https://api.foursquare.com/v3/places/\(fsqID)",headers: headers)
            .validate() // added validation
            .responseDecodable(of: [Result].self) { response in
                guard let place = response.value else { return }
                self.detailPlace = place
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
    }
}

