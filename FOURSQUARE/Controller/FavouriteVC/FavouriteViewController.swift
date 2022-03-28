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
    var rightButton = UIBarButtonItem()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favourite"
        //navigationBar
        rightButton = UIBarButtonItem(title: "Delete All", style: .plain, target: self, action: #selector(rightAction))

        if realm.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
            navigationItem.rightBarButtonItem = rightButton
        }

        //TableView
        tableView.register(UINib(nibName: "PlaceTableViewCell", bundle: .main), forCellReuseIdentifier: "PlaceTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self

        //Realm
        let path = realm.configuration.fileURL!.path
        //print("Path: \(String(describing: path))")
    }

    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        if realm.isEmpty {
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
            navigationItem.rightBarButtonItem = rightButton
        }
    }

    @objc func rightAction() {
        //Realm Delete All Data
        do {
            try! realm.write({
                realm.deleteAll()
                self.tableView.reloadData()
            })
        } catch {
            print("Error Delete All Data")
        }
        navigationItem.rightBarButtonItem?.isEnabled = false
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
        let vc = DetailPlaceInfoViewController()
        vc.infoDetailPlace = PlaceDetailViewMode(id: place[indexPath.row].id, name: place[indexPath.row].name ?? "", address: place[indexPath.row].address ?? "", category: place[indexPath.row].category ?? "", latidute: place[indexPath.row].latitude ?? 0, longitude: place[indexPath.row].longitude ?? 0)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
