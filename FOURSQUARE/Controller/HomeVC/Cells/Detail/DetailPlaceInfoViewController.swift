//
//  DetailPlaceInfoViewController.swift
//  FOURSQUARE
//
//  Created by Van Ngoc Duc on 02/03/2022.
//

import UIKit

class DetailPlaceInfoViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var infoDetailPlace: [InfoDummyData] = InfoDummyData.getDummyData()
    var photoDetailPlace: [String] = ["placeholder", "placeholder", "placeholder", "placeholder", "placeholder", "placeholder"]
    var tipDetailPlace: [String] = ["Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit er elit lame", "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit er elit lame", "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit er elit lame", "Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.Lorem ipsum dolor sit er elit lame"]


    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detail VC"

        collectionView.delegate = self
        collectionView.dataSource = self

        //register Cell
        collectionView.register(UINib(nibName: "InfoPlaceCell", bundle: .main), forCellWithReuseIdentifier: "InfoPlaceCell")
        collectionView.register(UINib(nibName: "PhotoPlaceCell", bundle: .main), forCellWithReuseIdentifier: "PhotoPlaceCell")
        collectionView.register(UINib(nibName: "TipPlaceCell", bundle: .main), forCellWithReuseIdentifier: "TipPlaceCell")

        //register Header
        collectionView.register(UINib(nibName: "PlaceDetailCollectionReusableView", bundle: .main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PlaceDetailCollectionReusableView")
    }
}

extension DetailPlaceInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            case 0:
                return 1 //InfoPlaceCell
            case 1:
                return photoDetailPlace.count //PhotoPlaceCell
            case 2:
                return tipDetailPlace.count //TipPlaceCell
            default: return 1
        }
    }


    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
    case 0:
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoPlaceCell", for: indexPath) as! InfoPlaceCell

        let item = infoDetailPlace[indexPath.item]
        cell.addressLabel.text = item.address
        cell.categoryLabel.text = item.category
        return cell

    case 1:
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoPlaceCell", for: indexPath) as! PhotoPlaceCell

        let item = photoDetailPlace[indexPath.item]
                cell.imageView.image = UIImage(named: item)
        return cell

    case 2:
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TipPlaceCell", for: indexPath) as! TipPlaceCell

        let item = tipDetailPlace[indexPath.item]
                cell.tipTitleLabel.text = item
        return cell
            default:
                fatalError("Error Section CollectView")
        }
    }
}
//MARK: -CoursePageViewController: UICollectionViewDelegateFlowLayout
extension DetailPlaceInfoViewController: UICollectionViewDelegateFlowLayout {
    //HEADER
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
            return CGSize(width: collectionView.frame.width, height: 350)
        }

        func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            switch kind {
                case UICollectionView.elementKindSectionHeader:
                    let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PlaceDetailCollectionReusableView", for: indexPath) as! PlaceDetailCollectionReusableView

                    headerView.frame = CGRect(x: 0 , y: 0, width: self.view.frame.width, height: 350)

                    headerView.titleLabel.text = "Bánh cuốn trảng bàng"
                    headerView.subTitleLabel.text = "Vietnamese Restaurent"
                    headerView.imageView.image = UIImage(named: "banner")
                    return headerView
                default:
                    fatalError("Unexpected element kind")
            }
        }
    //CELL
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20 , bottom: 10, right: 20)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
            case 0:
                let screenWidth = UIScreen.main.bounds.width - 20 - 20
                return CGSize(width: screenWidth, height: screenWidth*0.64)
            case 1:
                let screenWidth = UIScreen.main.bounds.width - 20 - 20 - 10
                return CGSize(width: screenWidth/2, height: screenWidth/2)
            case 2:
                let screenWidth = UIScreen.main.bounds.width - 20 - 20
                return CGSize(width: screenWidth, height: screenWidth*0.26)
            default:
                let screenWidth = UIScreen.main.bounds.width - 20 - 20
                return CGSize(width: screenWidth, height: screenWidth*0.37)
        }
    }

}


//DUMMY DAT
class InfoDummyData {
    var name: String
    var category: String
    var address: String

    init(name: String,category: String, address: String ) {
        self.name = name
        self.category = category
        self.address = name
    }

    static func getDummyData() -> [InfoDummyData] {
        var infoPlace: [InfoDummyData] = []
        for i in 1...3 {
            let myInfoPlace = InfoDummyData(name: "Name \(i)", category: "category \(i)", address: "address \(i)")
            infoPlace.append(myInfoPlace)
        }
        return infoPlace
    }
}

//DUMMY DAT
//class PhotoDummyData {
//    var imagePlace: String
//
//    init(imagePlace: String) {
//        self.imagePlace = imagePlace
//    }
//
//    static func getDummyData() -> [PhotoDummyData] {
//        var photoPlace: [PhotoDummyData] = []
//        for i in 1...10 {
//            let myPhotoPlace = PhotoDummyData(imagePlace: "imagePlace \(i)")
//            photoPlace.append(myPhotoPlace)
//        }
//        return photoPlace
//    }
//}

