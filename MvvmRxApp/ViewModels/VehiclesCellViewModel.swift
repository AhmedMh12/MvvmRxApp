//
//  VehiclesCellViewModel.swift
//  MvvmRxApp
//
//  Created by MacBook Pro on 20/3/2022.
//

import Foundation

struct VehiclesCellViewModel {
    let type: String?
    let state: String?
    let heading: Float?
    let latitude: Double?
    let longitude: Double?
}
extension VehiclesCellViewModel {
    init(vehicle: PoiList) {
        self.type = vehicle.type
        self.state = vehicle.state
        self.heading = vehicle.heading
        self.latitude = vehicle.coordinate?.latitude
        self.longitude = vehicle.coordinate?.longitude
    }
}
