//
//  VehicleListTests.swift
//  MvvmRxAppTests
//
//  Created by MacBook Pro on 29/3/2022.
//

import XCTest

class VehicleListTests: XCTestCase {

    func testSuccessfulInit() {
      
        let testSuccessfulJSON: JSON = ["poiList": [
                
                  "id": -307141520,
                  "coordinate": [
                    "latitude": 53.644565281451996,
                    "longitude": 9.79638621211052
                  ],
                  "state": "ACTIVE",
                  "type": "TAXI",
                  "heading": 341.3671875
                ]]

            XCTAssertNotNil(VehicleList(json: testSuccessfulJSON))
        }
    
}
// Mark: - extension Friend
private extension VehicleList {
    init?(json: JSON) {
        guard let poiList = json["poiList"] as? [JSON],
              let id = poiList.first?["id"] ,
              let coordinate = poiList.first?["coordinate"] as? JSON,
              let latitude = coordinate["latitude"],
              let longitude = coordinate["longitude"],
              let state = poiList.first?["state"],
              let type = poiList.first?["type"],
              let heading = poiList.first?["heading"] else {
                return nil
        }
        self.poiList = [PoiList(coordinate:Coordinate(latitude: latitude as? Double, longitude: longitude as? Double) , heading: heading as? Float, id: id as? Int, state: state as? String, type: type as? String)]
      
    }
    
}
