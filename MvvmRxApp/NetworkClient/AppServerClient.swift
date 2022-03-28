//
//  AppServerClient.swift
//  MvvmRxApp
//
//  Created by MacBook Pro on 20/3/2022.
//

import Foundation
import Alamofire
import RxSwift

// MARK: - AppServerClient
class AppServerClient {
    // MARK: - Vehicles
    enum GetFailureReason: Int, Error {
        case unAuthorized = 401
        case notFound = 404
    }

    func getVehicles(p1Lat:Double,p1Long:Double,p2Lat:Double,p2Long:Double) -> Observable<VehicleList> {
        return Observable.create { observer -> Disposable in
            print("url ==> https://poi-api.mytaxi.com/PoiService/poi/v1?p2Lat=\(p2Lat)&p1Lon=\(p1Long)&p1Lat=\(p1Lat)&p2Lon=\(p2Long)")
            Alamofire.request("https://poi-api.mytaxi.com/PoiService/poi/v1?p2Lat=\(p2Lat)&p1Lon=\(p1Long)&p1Lat=\(p1Lat)&p2Lon=\(p2Long)")
                .validate()
                .responseJSON { response in
                    switch response.result {
                    case .success:
                        guard let data = response.data else {
                            // if no error provided by alamofire return .notFound error instead.
                            // .notFound should never happen here?
                            observer.onError(response.error ?? GetFailureReason.notFound)
                            return
                        }
                        do {
                            let vehicles = try JSONDecoder().decode(VehicleList.self, from: data)
                            observer.onNext(vehicles)
                        } catch {
                            observer.onError(error)
                        }
                    case .failure(let error):
                        if let statusCode = response.response?.statusCode,
                            let reason = GetFailureReason(rawValue: statusCode)
                        {
                            observer.onError(reason)
                        }
                        observer.onError(error)
                    }
            }

            return Disposables.create()
        }
    }
}
