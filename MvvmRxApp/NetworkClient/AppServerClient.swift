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

    func getVehicles() -> Observable<[PoiList]> {
        return Observable.create { observer -> Disposable in
            Alamofire.request("https://poi-api.mytaxi.com/PoiService/poi/v1?p2Lat=53.394655&p1Lon=9.757589&p1Lat=53.694865&p2Lon=10.099891")
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
                            let vehicles = try JSONDecoder().decode([PoiList].self, from: data)
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
