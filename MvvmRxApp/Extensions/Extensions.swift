//
//  Extensions.swift
//  MvvmRxApp
//
//  Created by MacBook Pro on 28/3/2022.
//

import Foundation
import UIKit
import MapKit

extension MKCoordinateRegion {

    var boundingBoxCoordinates: [CLLocationCoordinate2D] {
        let halfLatDelta = self.span.latitudeDelta / 2
        let halfLngDelta = self.span.longitudeDelta / 2

        let topLeftCoord = CLLocationCoordinate2D(
            latitude: self.center.latitude + halfLatDelta,
            longitude: self.center.longitude - halfLngDelta
        )
        let bottomRightCoord = CLLocationCoordinate2D(
            latitude: self.center.latitude - halfLatDelta,
            longitude: self.center.longitude + halfLngDelta
        )
        let bottomLeftCoord = CLLocationCoordinate2D(
            latitude: self.center.latitude - halfLatDelta,
            longitude: self.center.longitude - halfLngDelta
        )
        let topRightCoord = CLLocationCoordinate2D(
            latitude: self.center.latitude + halfLatDelta,
            longitude: self.center.longitude + halfLngDelta
        )

        return [topLeftCoord, topRightCoord, bottomRightCoord, bottomLeftCoord]
    }

}
