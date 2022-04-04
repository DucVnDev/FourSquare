import UIKit
import Alamofire
import CoreLocation

class SearchViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    let searchController: UISearchController = UISearchController(searchResultsController: nil)
    var resultPlace : [Result] = []
    var filterPlaces : [Result] = []

    var manager = CLLocationManager()
    var networkingApi = NetworkingAPI()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"

        //searchController
        setupSearchController()

        //tableView
        setupTableView()
    }

    //Configure searchController
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        searchController.searchBar.delegate = self
    }

    //Configure tableView
    private func setupTableView() {
        tableView.register(UINib(nibName: "PlaceTableViewCell", bundle: .main), forCellReuseIdentifier: "PlaceTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
    }


    private func navBarItemConfig() {
        navigationController?.navigationBar.backgroundColor = .white
        let rightButton = UIBarButtonItem(image: UIImage.init(systemName: "map"), style: .plain, target: self, action: #selector(rightAction))
        navigationItem.rightBarButtonItem = rightButton
    }

    @objc func rightAction() {
        print("Did tap")
    }

    func filterContentForSearchText(_ searchText: String) {
        filterPlaces = resultPlace.filter({ result in
            return result.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}
//MARK: -ListSearchViewController: UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive && searchController.searchBar.text != nil {
            return filterPlaces.count
        } else {
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceTableViewCell", for: indexPath) as! PlaceTableViewCell

        if searchController.isActive && searchController.searchBar.text != nil {
            let item = filterPlaces[indexPath.row]
            let cellViewModel = PlaceTableViewCellViewModel(fsqID: item.fsqID, indexPath: String(indexPath.row + 1), title: item.name, subtitle: item.categories.first?.name ?? "", distance: Double(item.distance), locality: item.location.locality ?? "", desc: "", imgURL: item.imgURLString)
            cell.updateCellWith(cellViewModel)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchController.isActive && searchController.searchBar.text != "" {
            let item = filterPlaces[indexPath.row]
            let vc = DetailPlaceInfoViewController()
            vc.infoDetailPlace = PlaceDetailViewMode(id: item.fsqID, name: item.name, address: item.location.formattedAddress, category: item.categories.first?.name ?? "", latidute: item.geocodes.main.latitude, longitude: item.geocodes.main.longitude)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

//MARK: - SearchViewController: UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
        //Get my Location
        guard let sourceCoordinate = manager.location?.coordinate else { return }

        //Load API nearby Place
        fetchNearByPlace(latitude: sourceCoordinate.latitude, longitude: sourceCoordinate.longitude)
    }
}

//MARK: - SearchViewController: UISearchBarDelegate
extension SearchViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchController.searchBar.text = nil
        searchController.searchBar.resignFirstResponder()
        tableView.reloadData()
    }
}

//MARK: -SearchViewController: Load API
extension SearchViewController {
    func fetchNearByPlace(latitude: Double, longitude: Double) {
        networkingApi.fetchNearByPlaces(latitude: latitude, longitude: longitude) { data in
            self.resultPlace = data
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}



