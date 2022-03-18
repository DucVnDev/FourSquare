//
//  MapingViewController.swift
//  FOURSQUARE
//
//  Created by Van Ngoc Duc on 15/03/2022.
//

import UIKit
import CoreLocation
import MapKit

class MapingViewController: UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var currentLocationBtn: UIButton!

    let manager = CLLocationManager()

    var locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Mapping"

        mapView.delegate = self

        let destination = CLLocationCoordinate2D(latitude: 16.071763, longitude: 108.223963)
        addPin(coordinate: destination, title: "Point 01", subTitle: "Test Demo")
        mapThis(_destinationCoordinate: destination)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        manager.desiredAccuracy = kCLLocationAccuracyBest //Battery
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()

    }

    @IBAction func currentLocationBtnDidTap(_ sender: Any) {
        manager.startUpdatingLocation()
    }

    //MARK: -  Annotation
    func addAnnotation(_ latitude: Double, _ longitude: Double) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        annotation.title = "Point 001"
        //annotation.subtitle = "Subtitle 001"
        mapView.addAnnotation(annotation)
    }

    func addPin( coordinate: CLLocationCoordinate2D, title: String, subTitle: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        annotation.subtitle = subTitle
        mapView.addAnnotation(annotation)

    }
    func mapThis(_destinationCoordinate: CLLocationCoordinate2D) {
        guard let sourceCoordinate = manager.location?.coordinate else { return }

        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: sourceCoordinate))
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: _destinationCoordinate))
        request.transportType = .automobile
        request.requestsAlternateRoutes = true

        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let error = error {
                print(error.localizedDescription)
            }
            guard let mapRouter = response?.routes.first else {
                return }
            self.mapView.addOverlay(mapRouter.polyline)
            self.mapView.setVisibleMapRect(mapRouter.polyline.boundingMapRect, edgePadding: UIEdgeInsets(top: 0, left: 50, bottom: 50, right: 50), animated: true)
        }
    }
}


extension MapingViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            manager.stopUpdatingLocation()
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.showsUserLocation = true
            mapView.setRegion(region, animated: true)
        }
    }
}

extension MapingViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let render = MKPolylineRenderer(overlay: overlay)
        render.strokeColor = .systemBlue
        render.lineWidth = 5
        return render
    }
}

