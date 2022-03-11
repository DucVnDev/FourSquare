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

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    func updateWith(_ viewModel:PlaceTableViewCellViewModel) {
        titleLabel.text = viewModel.title
        //placeImageView.sd_setImage(with: URL(string: viewModel.imgURL))
        subTitleLabel.text = viewModel.subtitle
        distanceLabel.text = "\(viewModel.distance)m  \(viewModel.locality)"
        descLabel.text = viewModel.desc
        pointLabel.text = viewModel.point
        print(viewModel.fsqID)
    }

//    func fetchPlacePhoto(placeId: String) -> String {
//
//        let urlString: String = "https://api.foursquare.com/v3/places/\(placeId)/photos"
//        var urlImagePlaceString: String = ""
//        AF.request(urlString,
//                   method: .get,
//                   headers: self.headers)
//            .validate()
//            .response {  (responseData) in
//                guard let data = responseData.data else { return }
//                do {
//                    let placePhoto = try JSONDecoder().decode([PlacePhotoElement].self, from: data)
//                    DispatchQueue.main.async {
//                        let prefix: String? = placePhoto.first?.placePhotoPrefix
//                        let suffix: String? = placePhoto.first?.suffix
//                        if prefix != nil && suffix != nil {
//                        urlImagePlaceString: String = "\(prefix!)60x60\(suffix!)"
//                            //placeTableViewCell.placeImageView.sd_setImage(with: URL(string: urlImagePlaceString))
//                            print(urlImagePlaceString)
//                        } else  {
//                            //placeTableViewCell.placeImageView.sd_setImage(with: URL(string: urlImagePlaceString))
//                            print("No link Image Place")
//                        }
//
//                        // urlImagePlaceString = "\(prefix!)60x60\(suffix!)"
//                        self.tableView.reloadData()
//                    }
//                } catch {
//                    print("Error")
//                }
//            }
//        return urlImagePlaceString
//    }
}
