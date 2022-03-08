//
//  ListSearchViewController.swift
//  FOURSQUARE
//
//  Created by Van Ngoc Duc on 02/03/2022.
//

import UIKit
import Alamofire //1
import SDWebImage

class ListSearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let headers: HTTPHeaders = [.authorization("fsq3bOAjcSkpf3+5mEK/ag/WHuAgcic+NgiBisCFfamsc40="),
                                .accept("application/json")]

    var resultPlace : [Result] = []
    var items: [Displayable] = []
    var placePhotos: [PlacePhotoElement] = []


    override func viewDidLoad() {
        super.viewDidLoad()

        fetchNearByPlaces()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "PlaceTableViewCell", bundle: .main), forCellReuseIdentifier: "PlaceTableViewCell")
    }
}
//MARK: -ListSearchViewController: UITableViewDelegate, UITableViewDataSource
extension ListSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count //6
        //return 1
        //return place.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let placeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "PlaceTableViewCell", for: indexPath) as! PlaceTableViewCell
        
        let item = items[indexPath.row]
        let resultPlaceItem = resultPlace[indexPath.row] //De lay fsqID cua Place

        let placefsqID = resultPlaceItem.fsqID
        print("Title Place tableView: \(item.titleLabelText)")
        print("ID place tableView: \(placefsqID)")
        fetchPlacePhoto(placeId: placefsqID)

        let urlImagePlaceString : String = "\(self.placePhotos[0].placePhotoPrefix)120x120\(self.placePhotos[0].suffix)"
        print(urlImagePlaceString)


        placeTableViewCell.titleLabel.text = item.titleLabelText
        placeTableViewCell.placeImageView.sd_setImage(with: URL(string: urlImagePlaceString))
        placeTableViewCell.subTitleLabel.text = item.categoryNameLabelText.first?.name
        placeTableViewCell.distanceLabel.text = "\(item.distanceLabelText)m  \(item.locationLabelText)"
        placeTableViewCell.descLabel.text = "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit er elit lame"
        placeTableViewCell.pointLabel.text = "7.8"
        
        return placeTableViewCell
    }
}

//2
//MARK: -Extension ListSearchViewController
extension ListSearchViewController {

    //MARK: -func fetchNearByPlaces()
    func fetchNearByPlaces(){
        let parameters = ["ll" : "16.047079,108.206230"] //Lat, Long of Da Nang

        AF.request("https://api.foursquare.com/v3/places/nearby",parameters: parameters,headers: self.headers)
            .validate() // added validation
            .responseDecodable(of: Place.self) { response in
                guard let place = response.value else { return }
                self.items = place.results
                self.resultPlace = place.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
    }

    //MARK: -fetchPlacePhoto(placeId: String)
    func fetchPlacePhoto(placeId: String) {

        let urlString: String = "https://api.foursquare.com/v3/places/\(placeId)/photos"
        AF.request(urlString,
                   method: .get,
                   headers: self.headers)
            .validate()
            .response {  (responseData) in
                guard let data = responseData.data else { return }
                do {
                    let placePhoto = try JSONDecoder().decode([PlacePhotoElement].self, from: data)
                    self.placePhotos = placePhoto
                } catch {
                    print("Error")
                }
            }
    }
}
