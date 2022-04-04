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

    var networkingApi = NetworkingAPI()

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

    //ListVC
    func updateCellWith(_ viewModel: PlaceTableViewCellViewModel) {
        descLabel.text = ""
        titleLabel.text = "\(viewModel.indexPath). \(viewModel.title)"
        subTitleLabel.text = viewModel.subtitle
        distanceLabel.text = "\(viewModel.distance)m  \(viewModel.locality)"
        fetchPhotoID(fsqID: viewModel.fsqID)
    }

    //FavouriteVC
    func updateWith(id: String, indexPath: Int) {
        fetchDetailPlaceWith(fsqID: id, indexPath: indexPath)
        fetchPhotoID(fsqID: id)
    }

    private func fetchPhotoID(fsqID: String) {
        networkingApi.fetchPhotoWith(fsqID: fsqID) { [weak self] data in
            if let prefix = data.first?.placePhotoPrefix, let suffix = data.first?.suffix {
                let imgURLString = "\(prefix)120x120\(suffix)"
                self?.placeImageView.sd_setImage(with: URL(string: imgURLString))
            }
        }
    }

    private func fetchDetailPlaceWith(fsqID: String, indexPath: Int) {
        networkingApi.fetchDetailPlaceWith(fsqID: fsqID) { data in
            let name = data.name
            let categories = data.categories.first?.name ?? ""
            let address = data.location.formattedAddress
            self.titleLabel.text = "\(indexPath+1). \(name)"
            self.subTitleLabel.text = "\(categories)"
            self.distanceLabel.text = "\(address)"
            self.descLabel.text = ""
    }
}
}
