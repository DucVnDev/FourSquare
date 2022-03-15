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
    
    override func awakeFromNib() {
        super.awakeFromNib()

        setProperties()
    }

    func setProperties() {
        //Gradien View
        //someView.applyGradient(isVertical: true, colorArray: [.green, .blue])
    }
    
}

extension UIView {
    func applyGradient(isVertical: Bool, colorArray: [UIColor]) {
        layer.sublayers?.filter({ $0 is CAGradientLayer }).forEach({ $0.removeFromSuperlayer() })

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colorArray.map({ $0.cgColor })
        if isVertical {
            //top to bottom
            gradientLayer.locations = [0.0, 1.0]
        } else {
            //left to right
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        }

        backgroundColor = .clear
        gradientLayer.frame = bounds
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

extension PlaceDetailCollectionReusableView {
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
                    let imgURLString = "\(prefix)1200x1200\(suffix)"
                    //self.imgURLBannerString = imgURLString
                    self.imageView.sd_setImage(with: URL(string: imgURLString))
                }
            }
    }
}
