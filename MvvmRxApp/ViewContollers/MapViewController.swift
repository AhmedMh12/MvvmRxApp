//
//  MapViewController.swift
//  MvvmRxApp
//
//  Created by MacBook Pro on 22/3/2022.
//

import Foundation
import UIKit
import MapKit
import RxSwift
import RxSwiftExt
import RxCocoa

public class MapViewController: UIViewController , MKMapViewDelegate {
    @IBOutlet private var mapView: MKMapView?
    // Set initial location in Honolulu
    let initialLocation = CLLocation(latitude: 53.694865, longitude: 9.757589)
    var viewModel: MapViewModel?
    private var mapChangedFromUserInteraction = false

    private func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        let view = self.mapView?.subviews[0]
        //  Look through gesture recognizers to determine whether this region change is from user interaction
        if let gestureRecognizers = view?.gestureRecognizers {
            for recognizer in gestureRecognizers {
                if( recognizer.state == UIGestureRecognizer.State.began || recognizer.state == UIGestureRecognizer.State.ended ) {
                    return true
                }
            }
        }
        return false
    }
    public override func viewDidLoad() {
        super.viewDidLoad()
        initView()
       
      

    }
    func initView() {
        guard let viewModel = viewModel else {
            return
        }
       
       
        mapView?.centerToLocation(initialLocation)
      
        let region = MKCoordinateRegion(
          center: initialLocation.coordinate,
          latitudinalMeters: 50000,
          longitudinalMeters: 60000)
        mapView?.setCameraBoundary(
          MKMapView.CameraBoundary(coordinateRegion: region),
          animated: true)
        
        let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
        mapView?.setCameraZoomRange(zoomRange, animated: true)
        let marker = MyAnnotation(title: "" , subtitle: "" , coordinate: CLLocationCoordinate2D(latitude: initialLocation.coordinate.latitude, longitude: initialLocation.coordinate.longitude))
        self.mapView?.addAnnotations([marker])
        
    }
    public func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        mapChangedFromUserInteraction = mapViewRegionDidChangeFromUserInteraction()
        if (mapChangedFromUserInteraction) {
            print(mapChangedFromUserInteraction)
            
        }
    }

    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if (mapChangedFromUserInteraction) {
            let bounds = mapView.region.boundingBoxCoordinates
                  print("TopLeft: \(bounds[0])\nTopRight: \(bounds[1])\nBottomRight: \(bounds[2])\nBottomLeft: \(bounds[3])")
                 
        }
    }
}
private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 1000
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
