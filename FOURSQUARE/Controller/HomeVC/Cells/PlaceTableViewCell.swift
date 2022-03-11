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
    var imgURLString: String = ""

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    //    override func prepareForReuse() {
    //        super.prepareForReuse()
    //    }

    func updateWith(_ viewModel:PlaceTableViewCellViewModel) {
        titleLabel.text = viewModel.title
        //placeImageView.sd_setImage(with: URL(string: urlImagePlaceString))
        subTitleLabel.text = viewModel.subtitle
        distanceLabel.text = "\(viewModel.distance)m  \(viewModel.locality)"
        descLabel.text = viewModel.desc
        pointLabel.text = viewModel.point

        fetchPlacePhoto(placeId: viewModel.fsqID)
        placeImageView.sd_setImage(with: URL(string: imgURLString))
    }

    func fetchPlacePhoto(placeId: String){

        let urlString: String = "https://api.foursquare.com/v3/places/\(placeId)/photos"
        let headers: HTTPHeaders = [.authorization("fsq3bLyHTk3rptYmDCK2UC6COiqhyPlEkIqotgeQnebJB48="),
                                    .accept("application/json")]

        AF.request(urlString,
                   method: .get,
                   headers: headers)
            .validate()
            .responseDecodable(of: [PlacePhotoElement].self) { (responseData) in
                guard let data = responseData.value else { return }
                DispatchQueue.main.async {
                    //self.placePhoto = data
                    let prefix: String? = data.first?.placePhotoPrefix
                    let suffix: String? = data.first?.suffix

                    if prefix != nil && suffix != nil {
                        self.imgURLString = "\(prefix!)120x120\(suffix!)"
                        print("Link Image Place with: \(placeId)")
                        print(self.imgURLString)
                    } else  {
                        self.imgURLString = "https://static5.depositphotos.com/1020804/405/i/950/depositphotos_4058882-stock-photo-ripe-red-apple-with-a.jpg"
                        print("No link Image Place with: \(placeId)")
                    }
                }
            }
    }

}
