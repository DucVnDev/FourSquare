//
//  PlaceTableViewCell.swift
//  FOURSQUARE
//
//  Created by Van Ngoc Duc on 02/03/2022.
//

import UIKit
import Alamofire
import SDWebImage

struct PlaceTableViewCellViewModel {
    var fsqID: String
    var indexPath: String
    var title: String
    var subtitle: String
    var distance: Double
    var locality: String
    var desc: String
    var point: String
    var imgURL: String
}

class PlaceTableViewCell: UITableViewCell {


    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!

    var placePhoto: [PlacePhotoElement] = []
    var placeTip: [PlaceTipElement] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func commonInit(){
        placeImageView.layer.cornerRadius = 8
    }
    func updateWith(_ viewModel:PlaceTableViewCellViewModel) {

        fetchPlacePhoto(fsqID: viewModel.fsqID, titlePlace: viewModel.title)
        fetchPlaceTip(fsqID: viewModel.fsqID, titlePlace: viewModel.title)

        titleLabel.text = "\(viewModel.indexPath). \(viewModel.title)"
        subTitleLabel.text = viewModel.subtitle
        distanceLabel.text = "\(viewModel.distance)m  \(viewModel.locality)"
        pointLabel.text = viewModel.point
    }


    func fetchPlacePhoto(fsqID: String, titlePlace: String){

        let urlString: String = "https://api.foursquare.com/v3/places/\(fsqID)/photos"
        let headers: HTTPHeaders = [.authorization("fsq3bLyHTk3rptYmDCK2UC6COiqhyPlEkIqotgeQnebJB48="),
                                    .accept("application/json")]
        AF.request(urlString,
                   method: .get,
                   headers: headers)
            .validate()
            .responseDecodable(of: [PlacePhotoElement].self) { responseData in
                guard let data = responseData.value else { return }
                DispatchQueue.main.async {
                    self.placePhoto = data
                    let prefix: String? = data.first?.placePhotoPrefix
                    let suffix: String? = data.first?.suffix
                    if prefix != nil && suffix != nil {
                        AF.request( "\(prefix!)120x120\(suffix!)",method: .get)
                            .response{ response in
                                switch response.result {
                                    case .success(let responseData):
                                        self.placeImageView.image = UIImage(data: responseData!, scale: 1)
                                    case .failure(let error):
                                        print("error--->",error)
                                        print(" No link Image Place with: \(fsqID) - \(titlePlace)")
                                }
                            }
                    } else  {
                        print("No link ImagePlace: \(fsqID) - \(titlePlace), ImagePlace use Local Image Defaut")
                        self.placeImageView.image = UIImage(named: "Banner2.jpeg")
                    }
                }
            }
    }

    func fetchPlaceTip(fsqID: String, titlePlace: String){

        let urlString: String = "https://api.foursquare.com/v3/places/\(fsqID)/tips"
        let headers: HTTPHeaders = [.authorization("fsq3bLyHTk3rptYmDCK2UC6COiqhyPlEkIqotgeQnebJB48="),
                                    .accept("application/json")]
        AF.request(urlString,
                   method: .get,
                   headers: headers)
            .validate()
            .responseDecodable(of: [PlaceTipElement].self) { (responseData) in
                guard let data = responseData.value else { return }
                DispatchQueue.main.async {
                    self.placeTip = data
                    if data.first?.text != nil {
                        self.descLabel.text = data.first?.text
                        //print("Have Place Tips with: \(fsqID)")
                    } else {
                        self.descLabel.text  = ""
                        print("No Place Tips with: \(fsqID) - \(titlePlace)")
                        return
                    }
                }
            }
    }

}
