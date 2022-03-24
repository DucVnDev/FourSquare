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
    var imgURL: String?
}

class PlaceTableViewCell: UITableViewCell {

    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var pointLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        placeImageView.image = UIImage(named: "placeholder")
        titleLabel.text = ""
        subTitleLabel.text = ""
        distanceLabel.text = ""
        descLabel.text = ""
    }

    func commonInit() {
        placeImageView.image = UIImage(named: "placeholder")
        placeImageView.layer.cornerRadius = 8
    }

    func updateWith(_ viewModel: PlaceTableViewCellViewModel) {
        descLabel.text = ""
        titleLabel.text = "\(viewModel.indexPath). \(viewModel.title)"
        subTitleLabel.text = viewModel.subtitle
        distanceLabel.text = "\(viewModel.distance)m  \(viewModel.locality)"
        fetchPhotoWith(fsqID: viewModel.fsqID)
    }

    //FavouriteVC
    func updateWithId(id: String, indexPath: Int) {
        fetchNDetailPlace(fsqID: id, indexPath: indexPath)
        fetchPhotoWith(fsqID: id)
    }

    func fetchPhotoWith(fsqID: String) {
        let urlString: String = "https://api.foursquare.com/v3/places/\(fsqID)/photos"
        let headers: HTTPHeaders = [.authorization("fsq3bLyHTk3rptYmDCK2UC6COiqhyPlEkIqotgeQnebJB48="),
                                    .accept("application/json")]
        AF.request(urlString,
                   method: .get,
                   headers: headers)
        .validate()
        .responseDecodable(of: [PlacePhotoElement].self) { responseData in
            guard let data = responseData.value else { return }
            if let prefix = data.first?.placePhotoPrefix, let suffix = data.first?.suffix {
                let imgURLString = "\(prefix)120x120\(suffix)"
                self.placeImageView.sd_setImage(with: URL(string: imgURLString))
            }
        }
    }

    func fetchNDetailPlace(fsqID: String, indexPath: Int ) {
        let headers: HTTPHeaders = [.authorization("fsq3bLyHTk3rptYmDCK2UC6COiqhyPlEkIqotgeQnebJB48="),
                                    .accept("application/json")]
        AF.request("https://api.foursquare.com/v3/places/\(fsqID)",headers: headers)
            .validate() // added validation
            .responseDecodable(of: DetailPlace.self) { response in
                guard let place = response.value else { return }
                let name = place.name
                let categories = place.categories.first?.name ?? ""
                let locality = place.location.locality ?? ""
                let address = place.location.formattedAddress ?? ""
                self.titleLabel.text = "\(indexPath+1). \(name)"
                self.subTitleLabel.text = "\(categories)"
                self.distanceLabel.text = "\(address)"
                self.descLabel.text = ""
            }
    }
}
