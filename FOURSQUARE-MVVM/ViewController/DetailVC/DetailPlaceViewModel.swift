//
//  DetailPlaceViewModel.swift
//  FOURSQUARE-MVVM
//
//  Created by Van Ngoc Duc on 03/05/2022.
//

import Foundation
import RealmSwift

class DetailPlaceViewMode {
    var reloadCollectionView: (() -> Void)?

     var detailPlaceCellVM = DetailPlaceCellViewModel() {
        didSet {
            reloadCollectionView?()
        }
    }

    private var imgsUrlString : [String] = []
    private var tipsDetailPlace: [String] = []

    private var networkingAPI : NetworkingService

    init(networkingAPI: NetworkingService = NetworkingAPI()) {
        self.networkingAPI = networkingAPI
    }

    //MARK: - Public Method
    //Fetch Photo
    func fetchPhotoPlace(_ fsqID: String) {
        networkingAPI.fetchPhotoWith(fsqID: fsqID) { [weak self] data in
            if data.count != 0 {
                var imgsURLString : [String] = []
                for i in 0...(data.count-1) {
                    let prefix = data[i].placePhotoPrefix
                    let suffix = data[i].suffix
                    let imgURLString = "\(prefix)600x600\(suffix)"
                    imgsURLString.append(imgURLString)
                }
                self?.imgsUrlString = imgsURLString
            }
        }
    }

    func fetchTipPlace(_ fsqID: String) {
        networkingAPI.fetchTipsWith(fsqID: fsqID) { [weak self] data in
            if data.count != 0 {
                var tips: [String] = []
                for i in 0...(data.count-1) {
                    let tip = data[i].text
                    tips.append(tip)
                }
                self?.tipsDetailPlace = tips
            }
        }
    }
}
