//
//  MapViewModel.swift
//  MvvmRxApp
//
//  Created by MacBook Pro on 22/3/2022.
//

import Foundation
import RxSwift
import RxCocoa

class MapViewModel{
    let getVehicleResponse : PublishSubject<VehicleList> = PublishSubject()

    var onShowLoadingHud: Observable<Bool> {
        return loadInProgress
            .asObservable()
            .distinctUntilChanged()
    }

    let onShowError = PublishSubject<SingleButtonAlert>()
    let appServerClient: AppServerClient
    let disposeBag = DisposeBag()

    private let loadInProgress = BehaviorRelay(value: false)

    init(appServerClient: AppServerClient = AppServerClient()) {
        self.appServerClient = appServerClient
    }

    func getvehicless(p1Lat:Double,p1Long:Double,p2Lat:Double,p2Long:Double) {
        loadInProgress.accept(true)

        appServerClient
            .getVehicles(p1Lat:p1Lat,p1Long:p1Long,p2Lat:p2Lat,p2Long:p2Long)
            .subscribe(
                onNext: { [weak self] vehicles in
                    self?.loadInProgress.accept(false)
                    self?.getVehicleResponse.onNext(vehicles)
                },
                onError: { [weak self] error in
                    self?.loadInProgress.accept(false)
            
                   
                }
            )
            .disposed(by: disposeBag)
    }

    
}

// MARK: - AppServerClient.GetFailureReason
fileprivate extension AppServerClient.GetFailureReason {
    func getErrorMessage() -> String? {
        switch self {
        case .unAuthorized:
            return "Please login to load your vehicless."
        case .notFound:
            return "Could not complete request, please try again."
        }
    }
}
