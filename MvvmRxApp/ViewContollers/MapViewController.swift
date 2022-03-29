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
    
    // MARK: initView
    
    func initView() {
       
        let center = CLLocationCoordinate2D(latitude: 53.694865, longitude: 9.757589)
        var region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1))
        region.center = CLLocationCoordinate2D(latitude: 53.694865, longitude: 9.757589)
        mapView?.setRegion(region, animated: true)
        let bounds = mapView?.region.boundingBoxCoordinates
        viewModel.getvehicless(p1Lat:bounds?[0].latitude ?? 0.0, p1Long: bounds?[0].longitude ?? 0.0, p2Lat: bounds?[2].latitude ?? 0.0, p2Long: bounds?[2].longitude ?? 0.0)
        
    }
    
    // MARK: createCallbacks
    
    func createCallbacks (){
        
        viewModel.getVehicleResponse.subscribe(onNext: { [self] data in
            if let cars = data.poiList {
                addAnnotations(cars :cars)
            }
            
        }).disposed(by: disposeBag)
        
        
    }
    
    // MARK: MapView Methods 
    
    public func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        mapChangedFromUserInteraction = mapViewRegionDidChangeFromUserInteraction()
        if (mapChangedFromUserInteraction) {
            print(mapChangedFromUserInteraction)
            
        }
    }
    
    public func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if (mapChangedFromUserInteraction) {
            let bounds = mapView.region.boundingBoxCoordinates
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
