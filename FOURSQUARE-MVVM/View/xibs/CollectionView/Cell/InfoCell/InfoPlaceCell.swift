//
//  InfoPlaceCell.swift
//  FOURSQUARE
//
//  Created by Van Ngoc Duc on 14/03/2022.
//

import UIKit

protocol InfoPlaceCellDelegate: AnyObject {
    func InfoPlaceCellNavigateToMapVC(_ cell: InfoPlaceCell, viewModel: InfoPlaceCellViewModel)

}

class InfoPlaceCell: UICollectionViewCell {


    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var directionBtn: UIButton!

    weak var delegate : InfoPlaceCellDelegate?
    var viewModel: InfoPlaceCellViewModel? {
        didSet {
            self.updateCellViewModelWith(viewModel)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        directionBtn.layer.cornerRadius = 10
    }

    
    @IBAction func directionDidTap(_ sender: UIButton) {
        guard let viewModel = viewModel else {
            return
        }
        delegate?.InfoPlaceCellNavigateToMapVC(self, viewModel: viewModel)
    }

    func updateCellViewModelWith(_ viewModel: InfoPlaceCellViewModel?) {
        guard let viewModel = viewModel else {
            return
        }
        addressLabel.text = viewModel.address
        categoryLabel.text = viewModel.category
    }
}
