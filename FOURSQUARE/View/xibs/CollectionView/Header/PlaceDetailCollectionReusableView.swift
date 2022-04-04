//
//  PlaceDetailCollectionReusableView.swift
//  FOURSQUARE
//
//  Created by Van Ngoc Duc on 14/03/2022.
//

import UIKit
import Alamofire
import SDWebImage

class PlaceDetailCollectionReusableView: UICollectionReusableView {


    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!

    var networkingApi = NetworkingAPI()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = UIImage(named: "placeholder")
        titleLabel.text = ""
        subTitleLabel.text = ""
    }
}

//MARK: - Load API PhotoPlace and TipsPlace  {
extension PlaceDetailCollectionReusableView {
    func fetchPhotoWith(fsqID: String) {
        networkingApi.fetchPhotoWith(fsqID: fsqID) { data in
            if let prefix = data.first?.placePhotoPrefix, let suffix = data.first?.suffix {
                let imgURLString = "\(prefix)1200x1200\(suffix)"
                self.imageView.sd_setImage(with: URL(string: imgURLString))
            }
        }
    }
}
