//
//  InfoPlaceCell.swift
//  FOURSQUARE
//
//  Created by Van Ngoc Duc on 14/03/2022.
//

import UIKit

protocol InfoPlaceCellDelegate: AnyObject {
    func InfoPlaceCellDelegate( viewController: UIViewController)

}

class InfoPlaceCell: UICollectionViewCell {


    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var directionBtn: UIButton!

    weak var delegate : InfoPlaceCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        directionBtn.layer.cornerRadius = 10
    }

    
    @IBAction func directionDidTap(_ sender: UIButton) {
        let mapVC = MapingViewController()
        delegate?.InfoPlaceCellDelegate(viewController: mapVC)


    }
}
