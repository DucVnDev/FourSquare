import UIKit
import Alamofire //1

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    var resultPlace : [Result] = []
    var filterPlaces : [Result] = []

    override func viewDidLoad() {
        super.viewDidLoad()


        //tableView
        tableView.register(UINib(nibName: "PlaceTableViewCell", bundle: .main), forCellReuseIdentifier: "PlaceTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension

        //searchController
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Places"
        navigationItem.searchController = searchController
        definesPresentationContext = true

        fetchNearByPlaces()
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
        filterPlaces = resultPlace.filter({ result in
            return result.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }


}
//MARK: -ListSearchViewController: UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != "" {
            return filterPlaces.count
        } else {
            return resultPlace.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceTableViewCell", for: indexPath) as! PlaceTableViewCell
        if searchController.isActive && searchController.searchBar.text != "" {
            let item = filterPlaces[indexPath.row]
            let cellViewModel = PlaceTableViewCellViewModel(fsqID: item.fsqID, indexPath: String(indexPath.row + 1), title: item.name, subtitle: item.categories.first?.name ?? "", distance: Double(item.distance), locality: item.location.locality ?? "", desc: "", imgURL: item.imgURLString)
            cell.updateWith(cellViewModel)
        } else {
            let item = resultPlace[indexPath.row]
            let cellViewModel = PlaceTableViewCellViewModel(fsqID: item.fsqID, indexPath: String(indexPath.row + 1), title: item.name, subtitle: item.categories.first?.name ?? "", distance: Double(item.distance), locality: item.location.locality ?? "", desc: "", imgURL: item.imgURLString)
            cell.updateWith(cellViewModel)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailPlaceInfoViewController()

        if searchController.isActive && searchController.searchBar.text != "" {
            let item = filterPlaces[indexPath.row]
            vc.infoDetailPlace = PlaceDetailViewMode(id: item.fsqID, name: item.name, address: item.location.formattedAddress, category: item.categories.first?.name ?? "", latidute: item.geocodes.main.latitude, longitude: item.geocodes.main.longitude)
        } else {
            let item = resultPlace[indexPath.row]
            vc.infoDetailPlace = PlaceDetailViewMode(id: item.fsqID, name: item.name, address: item.location.formattedAddress, category: item.categories.first?.name ?? "", latidute: item.geocodes.main.latitude, longitude: item.geocodes.main.longitude)
        }
      self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - extension SearchViewController: UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }

}

//MARK: -Extension ListSearchViewController
extension SearchViewController {
    //MARK: -func fetchNearByPlaces()
    func fetchNearByPlaces(){
        let parameters = ["ll" : "16.0470,108.2062"] //Lat, Long of Da Nang
        let headers: HTTPHeaders = [.authorization("fsq3bLyHTk3rptYmDCK2UC6COiqhyPlEkIqotgeQnebJB48="),
                                    .accept("application/json")]

        AF.request("https://api.foursquare.com/v3/places/nearby",parameters: parameters,headers: headers)
            .validate() // added validation
            .responseDecodable(of: Place.self) { response in
                guard let place = response.value else { return }
                self.resultPlace = place.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
    }
}



