//
//  MockVehicle.swift
//  MvvmRxAppTests
//
//  Created by MacBook Pro on 29/3/2022.
//

import Foundation
extension Coordinate {
    static func with(latitude:Double = 53.644565281451996,longitude:Double = 9.79638621211052) -> Coordinate {
        return Coordinate ( latitude : latitude,longitude : longitude)
    }
}

extension PoiList {
    static func with(coordinate:Coordinate = Coordinate(latitude: 53.644565281451996, longitude: 9.79638621211052),heading :Float = 341.3671875,id : Int = -307141520,state : String = "ACTIVE",type : String = "TAXI" ) -> PoiList {
        return PoiList (coordinate: coordinate, heading: heading, id: id, state: state, type: type)
    }
}
extension VehicleList {
    static func with(poilist:PoiList = PoiList(coordinate:Coordinate(latitude: 53.644565281451996, longitude: 9.79638621211052),heading : 341.3671875,id : -307141520,state : "ACTIVE",type : "TAXI" ) ) -> VehicleList
    {
        return VehicleList(poiList: [poilist])
    }
}
