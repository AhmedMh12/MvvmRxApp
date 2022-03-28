//
//  VehicleList.swift
//  MvvmRxApp
//
//  Created by MacBook Pro on 18/3/2022.
//

import Foundation

struct VehicleList : Codable {

    let poiList : [PoiList]?


    enum CodingKeys: String, CodingKey {
        case poiList = "poiList"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        poiList = try values.decodeIfPresent([PoiList].self, forKey: .poiList)
    }


}
