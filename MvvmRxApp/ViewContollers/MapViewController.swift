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
 
    let viewModel: MapViewModel = MapViewModel()
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
     var getVehicleResponse = PublishSubject<VehicleList>()
    private let disposeBag = DisposeBag()
    public override func viewDidLoad() {
        super.viewDidLoad()
        initView()
       
        createCallbacks ()

    }
    func initView() {
       
        viewModel.getvehicless(p1Lat: 54.02525603757394, p1Long: 8.891518406181133, p2Lat: 49.55909302528771, p2Long: 13.850246871254468)
       
       // mapView?.centerToLocation(initialLocation)
       
                let center = CLLocationCoordinate2D(latitude: initialLocation.coordinate.latitude, longitude: initialLocation.coordinate.longitude)
        var region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        region.center = initialLocation.coordinate
        mapView?.setRegion(region, animated: true)

        let marker = MyAnnotation(title: "" , subtitle: "" , coordinate: CLLocationCoordinate2D(latitude: initialLocation.coordinate.latitude, longitude: initialLocation.coordinate.longitude))
        self.mapView?.addAnnotations([marker])
        
    }
    
    
    func createCallbacks (){
      
      viewModel.getVehicleResponse.subscribe(onNext: { [self] data in
          print("data.poiList === > \(data.poiList)")
          addAnnotations(cars :data.poiList ?? [])
          if data.poiList!.count > 0  {
             
        }else{
        }
      }).disposed(by: disposeBag)
      
      
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
                 // print("TopLeft: \(bounds[0])\nTopRight: \(bounds[1])\nBottomRight: \(bounds[2])\nBottomLeft: \(bounds[3])")
            viewModel.getvehicless(p1Lat:bounds[0].latitude, p1Long: bounds[0].longitude, p2Lat: bounds[2].latitude, p2Long: bounds[2].longitude)
        }
    }
    func addAnnotations(cars :[PoiList])  {
        let annotations = mapView!.annotations.filter({ !($0 is MKUserLocation) })
        mapView?.removeAnnotations(annotations)
        for veh in cars {
            let marker = MyAnnotation(title: "" , subtitle: "" , coordinate: CLLocationCoordinate2D(latitude: veh.coordinate?.latitude ?? 0.0, longitude: veh.coordinate?.longitude ?? 0.0))
            self.mapView?.addAnnotations([marker])
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
