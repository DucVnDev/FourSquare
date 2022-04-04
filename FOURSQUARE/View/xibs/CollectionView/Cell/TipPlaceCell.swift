//
//  TipPlaceCell.swift
//  FOURSQUARE
//
//  Created by Van Ngoc Duc on 15/03/2022.
//

import UIKit

class TipPlaceCell: UICollectionViewCell {

    @IBOutlet weak var view: UIView!
    @IBOutlet weak var tipTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        view.layer.cornerRadius = 12
    }
    override func prepareForReuse() {
        tipTitleLabel.text = ""
    }
}
