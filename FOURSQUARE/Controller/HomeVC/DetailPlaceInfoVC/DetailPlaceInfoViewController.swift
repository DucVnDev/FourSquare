//
//  DetailPlaceInfoViewController.swift
//  FOURSQUARE
//
//  Created by Van Ngoc Duc on 02/03/2022.
//

import UIKit
import Alamofire
import SDWebImage
import RealmSwift

struct PlaceDetailViewMode {
    var id: String
    var name: String
    var address: String
    var category: String
    var latidute: Double
    var longitude: Double
}

class DetailPlaceInfoViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    var infoDetailPlace = PlaceDetailViewMode(id: "", name: "", address: "", category: "", latidute: 0, longitude: 0)
    var urlPhotosPlaceString: [String] = []
    var tipDetailPlace: [String] = []

    var favouriteButton = UIBarButtonItem()

    var realm = try! Realm()
    var place = try! Realm().objects(FavoritePlacesItem.self)
    var isLike: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Detail Place"

        //Collectionview
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "InfoPlaceCell", bundle: .main), forCellWithReuseIdentifier: "InfoPlaceCell")
        collectionView.register(UINib(nibName: "PhotoPlaceCell", bundle: .main), forCellWithReuseIdentifier: "PhotoPlaceCell")
        collectionView.register(UINib(nibName: "TipPlaceCell", bundle: .main), forCellWithReuseIdentifier: "TipPlaceCell")

        //register Header
        collectionView.register(UINib(nibName: "PlaceDetailCollectionReusableView", bundle: .main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PlaceDetailCollectionReusableView")
        collectionView.register(UINib(nibName: "HeaderSectionPlaceDetailCell", bundle: .main), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderSectionPlaceDetailCell")

        //Realm
        let path = realm.configuration.fileURL!.path
        //print("Path: \(String(describing: path))")

        //NagivationBar Configure
        navBarItemConfig()

        //Load API
        fetchPhotoWith(fsqID: self.infoDetailPlace.id)
        fetchTipsWith(fsqID: self.infoDetailPlace.id)
    }

    func navBarItemConfig() {
        if place.isEmpty {
            favouriteButton = UIBarButtonItem(image: UIImage.init(systemName: "heart"), style: .plain, target: self, action: #selector(favouriteAction))
            navigationItem.rightBarButtonItem = favouriteButton
        } else {
            //var hasId: Bool = false
            for i in 0...(place.count-1) {
                if place[i].id == infoDetailPlace.id {
                    isLike = !isLike
                }
            }
            if isLike {
                favouriteButton = UIBarButtonItem(image: UIImage.init(systemName: "heart.fill"), style: .plain, target: self, action: #selector(favouriteAction))
                navigationItem.rightBarButtonItem = favouriteButton
            } else {
                favouriteButton = UIBarButtonItem(image: UIImage.init(systemName: "heart"), style: .plain, target: self, action: #selector(favouriteAction))
                navigationItem.rightBarButtonItem = favouriteButton
            }
        }

    }

    @objc func favouriteAction() {
        if isLike {
            var indexDel = 0
            for i in 0...(place.count-1) {
                if place[i].id == infoDetailPlace.id {
                    indexDel = i
                }
            }
            do {
                try! self.realm.write({
                    self.realm.delete(place[indexDel])
                })
            } catch {
                print("Error Delete Data")
            }
            favouriteButton.image = UIImage.init(systemName: "heart")
            isLike = !isLike
        } else {
            let newPlace = FavoritePlacesItem(id: infoDetailPlace.id, name: infoDetailPlace.name, address: infoDetailPlace.address, category: infoDetailPlace.category, latitude: infoDetailPlace.latidute, longitude: infoDetailPlace.longitude)
            do {
                try! self.realm.write({
                    self.realm.add(newPlace)
                })
            } catch {
                print("Error Add Data")
            }
            favouriteButton.image = UIImage.init(systemName: "heart.fill")
            isLike = !isLike
        }
    }
}

//MARK: -DetailPlaceInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource
extension DetailPlaceInfoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
            case 0:
                return .zero
            case 1:
                return 1 //InfoPlaceCell
            case 2:
                return urlPhotosPlaceString.count //PhotoPlaceCell
            case 3:
                return tipDetailPlace.count //TipPlaceCell
            default:
                fatalError("Error numberOfItemsInSection")
        }
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
            case 0:
                return UICollectionViewCell()
            case 1:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "InfoPlaceCell", for: indexPath) as! InfoPlaceCell
                let item = infoDetailPlace
                cell.addressLabel.text = item.address
                cell.categoryLabel.text = item.category
                cell.latitude = item.latidute
                cell.longitude = item.longitude
                cell.name = item.name
                cell.delegate = self
                return cell

            case 2:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoPlaceCell", for: indexPath) as! PhotoPlaceCell
                let item = urlPhotosPlaceString[indexPath.item]
                cell.imageView.sd_setImage(with: URL(string: item))
                return cell

            case 3:
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
        switch section {
            case 0:
                return CGSize(width: collectionView.frame.width, height: 277)
            default:
                return CGSize(width: collectionView.frame.width, height: 36)
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
            case 0:
                switch kind {
                    case UICollectionView.elementKindSectionHeader:
                        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "PlaceDetailCollectionReusableView", for: indexPath) as! PlaceDetailCollectionReusableView
                        headerView.titleLabel.text = self.infoDetailPlace.name
                        headerView.subTitleLabel.text = self.infoDetailPlace.category
                        headerView.fetchPhotoWith(fsqID: self.infoDetailPlace.id)
                        return headerView
                    default:
                        fatalError("Unexpected element kind")
                }
            case 1:
                switch kind {
                    case UICollectionView.elementKindSectionHeader:
                        let headerSetionView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderSectionPlaceDetailCell", for: indexPath) as! HeaderSectionPlaceDetailCell
                        headerSetionView.titleLabel.text = "Infomation"
                        return headerSetionView
                    default:
                        fatalError("Unexpected element kind")
                }
            case 2:
                switch kind {
                    case UICollectionView.elementKindSectionHeader:
                        let headerSetionView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderSectionPlaceDetailCell", for: indexPath) as! HeaderSectionPlaceDetailCell
                        headerSetionView.titleLabel.text = "Photos Place"
                        return headerSetionView
                    default:
                        fatalError("Unexpected element kind")
                }
            case 3:
                switch kind {
                    case UICollectionView.elementKindSectionHeader:
                        let headerSetionView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "HeaderSectionPlaceDetailCell", for: indexPath) as! HeaderSectionPlaceDetailCell
                        headerSetionView.titleLabel.text = "Tips Place"
                        return headerSetionView
                    default:
                        fatalError("Unexpected element kind")
                }
            default:
                fatalError("Unexpected section")
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
        switch section {
            case 0:
                return UIEdgeInsets(top: 0, left: 0 , bottom: 0, right: 0)
            case 1:
                return UIEdgeInsets(top: 0, left: 20 , bottom: 20, right: 20)
            case 2:
                return UIEdgeInsets(top: 10, left: 20 , bottom: 20, right: 20)
            case 3:
                return UIEdgeInsets(top: 10, left: 20 , bottom: 20, right: 20)
            default:
                return UIEdgeInsets(top: 10, left: 0 , bottom: 10, right: 0)
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
            case 0:
                return CGSize(width: 0, height: 0)
            case 1:
                let screenWidth = UIScreen.main.bounds.width - 20 - 20
                return CGSize(width: screenWidth, height: screenWidth*0.5)
            case 2:
                let screenWidth = UIScreen.main.bounds.width - 20 - 20 - 10
                return CGSize(width: screenWidth/2, height: screenWidth/2)
            case 3:
                let screenWidth = UIScreen.main.bounds.width - 20 - 20
                return CGSize(width: screenWidth, height: screenWidth*0.26)
            default:
                return CGSize(width: 0, height: 0)
        }
    }

}
//MARK: -LOAD API
extension DetailPlaceInfoViewController {
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
            if data.count != 0 {
                for i in 0...(data.count-1) {
                    let prefix = data[i].placePhotoPrefix
                    let suffix = data[i].suffix
                    let imgURLString = "\(prefix)600x600\(suffix)"
                    self.urlPhotosPlaceString.append(imgURLString)
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }

    func fetchTipsWith(fsqID: String) {
        let urlString: String = "https://api.foursquare.com/v3/places/\(fsqID)/tips"
        let headers: HTTPHeaders = [.authorization("fsq3bLyHTk3rptYmDCK2UC6COiqhyPlEkIqotgeQnebJB48="),
                                    .accept("application/json")]
        AF.request(urlString,
                   method: .get,
                   headers: headers)
        .validate()
        .responseDecodable(of: [PlaceTipElement].self) { responseData in
            guard let data = responseData.value else { return }
            if data.count != 0 {
                for i in 0...(data.count-1) {
                    let tip = data[i].text
                    self.tipDetailPlace.append(tip)
                }
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
}

extension DetailPlaceInfoViewController: InfoPlaceCellDelegate {
    func InfoPlaceCellDelegate(viewController: UIViewController) {
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
