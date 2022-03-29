//
//  VehiclesTableViewViewModel.swift
//  MvvmRxApp
//
//  Created by MacBook Pro on 20/3/2022.
//

import RxSwift
import RxCocoa

enum VehiclesTableViewCellType {
    case normal(cellViewModel: VehiclesCellViewModel)
    case error(message: String)
    case empty
}

class VehiclesTableViewViewModel {
    let getVehicleResponse : PublishSubject<VehicleList> = PublishSubject()

    var vehicleCells: Observable<[VehiclesTableViewCellType]> {
        return cells.asObservable()
    }
    var onShowLoadingHud: Observable<Bool> {
        return loadInProgress
            .asObservable()
            .distinctUntilChanged()
    }

    let onShowError = PublishSubject<SingleButtonAlert>()
    let appServerClient: AppServerClient
    let disposeBag = DisposeBag()

    private let loadInProgress = BehaviorRelay(value: false)
    private let cells = BehaviorRelay<[VehiclesTableViewCellType]>(value: [])

    init(appServerClient: AppServerClient = AppServerClient()) {
        self.appServerClient = appServerClient
    }

    // MARK: Call APi
    
    func getvehicless(p1Lat:Double,p1Long:Double,p2Lat:Double,p2Long:Double) {
        loadInProgress.accept(true)

        appServerClient
            .getVehicles(p1Lat:p1Lat,p1Long:p1Long,p2Lat:p2Lat,p2Long:p2Long)
            .subscribe(
                onNext: { [weak self] vehicles in
                    self?.loadInProgress.accept(false)
                    self?.getVehicleResponse.onNext(vehicles)
                    guard vehicles.poiList!.count > 0 else {
                        self?.cells.accept([.empty])
                        return
                    }

                    self?.cells.accept((vehicles.poiList?.compactMap { .normal(cellViewModel: VehiclesCellViewModel(vehicle: $0 )) })!)
                },
                onError: { [weak self] error in
                    self?.loadInProgress.accept(false)
                    self?.cells.accept([
                        .error(
                            message: (error as? AppServerClient.GetFailureReason)?.getErrorMessage() ?? "Loading failed, check network connection"
                        )
                    ])
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



