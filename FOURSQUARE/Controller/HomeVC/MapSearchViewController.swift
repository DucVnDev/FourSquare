//
//  MapSearchViewController.swift
//  FOURSQUARE
//
//  Created by Van Ngoc Duc on 15/03/2022.
//

import UIKit
import MapKit
class MapSearchViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
       let initialLocation = CLLocation(latitude: 16.048279, longitude: 108.209508)
        mapView.centerToLocation(initialLocation)
        // Show artwork on map
        let artwork = Artwork(
          title: "Mỳ quảng Đồng Quê-48 Nguyễn Hữu Thọ",
          locationName: "Da Nang",
          discipline: "Sculpture",
          coordinate: CLLocationCoordinate2D(latitude: 16.048279, longitude: 108.209508))
        mapView.addAnnotation(artwork)

    }
}

private extension MKMapView {
  func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 5000) {
    let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}

