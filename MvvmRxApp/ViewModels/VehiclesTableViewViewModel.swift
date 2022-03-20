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

    func getvehicless() {
        loadInProgress.accept(true)

        appServerClient
            .getVehicles()
            .subscribe(
                onNext: { [weak self] vehicles in
                    self?.loadInProgress.accept(false)
                    guard vehicles.count > 0 else {
                        self?.cells.accept([.empty])
                        return
                    }

                    self?.cells.accept(vehicles.compactMap { .normal(cellViewModel: VehiclesCellViewModel(vehicle: $0 )) })
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



