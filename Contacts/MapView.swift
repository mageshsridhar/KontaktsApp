//
//  MapView.swift
//  Contacts
//
//  Created by Magesh Sridhar on 3/23/21.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    let locationManager = CLLocationManager()
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ view: MKMapView, context: Context) {
        locationManager.requestWhenInUseAuthorization()
        if locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse{
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
            let location: CLLocationCoordinate2D = locationManager.location!.coordinate
            print(location.latitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.01 , longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: location, span: span)
            view.setRegion(region, animated: true)
//            let userLocation = LocationAnnotation(coordinate: location, title: "user")
//            view.addAnnotation(userLocation)
//            view.showAnnotations(view.annotations, animated: true)
            
            
        }
    }
    
}
class LocationAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
    }
}
