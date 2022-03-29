//
//  PoiList.swift
//  MvvmRxApp
//
//  Created by MacBook Pro on 18/3/2022.
//

import Foundation

struct PoiList : Codable {

    let coordinate : Coordinate?
    let heading : Float?
    let id : Int?
    let state : String?
    let type : String?


   /* enum CodingKeys: String, CodingKey {
        case coordinate = "coordinate"
        case heading = "heading"
        case id = "id"
        case state = "state"
        case type = "type"
    }
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        coordinate = try values.decodeIfPresent(Coordinate.self, forKey: .coordinate)
        heading = try values.decodeIfPresent(Float.self, forKey: .heading)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        state = try values.decodeIfPresent(String.self, forKey: .state)
        type = try values.decodeIfPresent(String.self, forKey: .type)
    }
*/

}
