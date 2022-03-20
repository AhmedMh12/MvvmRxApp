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
}
extension VehiclesCellViewModel {
    init(vehicle: PoiList) {
        self.type = vehicle.type
        self.state = vehicle.state
        self.heading = vehicle.heading
    }
}
