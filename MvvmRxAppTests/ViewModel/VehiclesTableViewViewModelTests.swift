//
//  VehiclesTableViewViewModelTests.swift
//  MvvmRxAppTests
//
//  Created by MacBook Pro on 29/3/2022.
//

import XCTest
import RxSwift

class VehiclesTableViewViewModelTests: XCTestCase {
    // MARK: - getVehicles
    func testNormalFriendCells() {
        let disposeBag = DisposeBag()
        let appServerClient = MockAppServerClient()
        appServerClient.getVehiclesResult = .success(payload: VehicleList.with())

        let viewModel = VehiclesTableViewViewModel(appServerClient: appServerClient)
        viewModel.getvehicless(p1Lat: 53.72548422210761, p1Long: 9.746518145241026, p2Lat: 53.63377789444483, p2Long: 9.837097876047977)

        let expectNormalFriendCellCreated = expectation(description: "VehicleCells contains a normal cell")

        viewModel.vehicleCells.subscribe(
            onNext: {
                let firstCellIsNormal: Bool

                if case.some(.normal(_)) = $0.first {
                    firstCellIsNormal = true
                } else {
                    firstCellIsNormal = false
                }

                XCTAssertTrue(firstCellIsNormal)
                expectNormalFriendCellCreated.fulfill()
            }
        ).disposed(by: disposeBag)
        
        wait(for: [expectNormalFriendCellCreated], timeout: 0.1)
    }
    
    
    func testEmptyVehicleCells() {
        let disposeBag = DisposeBag()
        let appServerClient = MockAppServerClient()
        appServerClient.getVehiclesResult = .success(payload: VehicleList.with())

        let viewModel = VehiclesTableViewViewModel(appServerClient: appServerClient)
        viewModel.getvehicless(p1Lat: 0.0, p1Long: 0.0, p2Lat: 0.0, p2Long: 0.0)

        let expectEmptyVehicleCellCreated = expectation(description: "VehicleCells contains an empty cell")

        viewModel.vehicleCells.subscribe(
            onNext: {
                let firstCellIsEmpty: Bool

                if case.some(.empty) = $0.first {
                    firstCellIsEmpty = true
                } else {
                    firstCellIsEmpty = false
                }

                XCTAssertTrue(firstCellIsEmpty)
                expectEmptyVehicleCellCreated.fulfill()
            }
        ).disposed(by: disposeBag)

        wait(for: [expectEmptyVehicleCellCreated],timeout: 0.1)
    }
    
    func testErrorVehiclesCells() {
        let disposeBag = DisposeBag()
        let appServerClient = MockAppServerClient()
        appServerClient.getVehiclesResult = .failure(AppServerClient.GetFailureReason.notFound)

        let viewModel = VehiclesTableViewViewModel(appServerClient: appServerClient)
        viewModel.getvehicless(p1Lat: 0.0, p1Long: 0.0, p2Lat: 0.0, p2Long: 0.0)

        let expectErrorVehicleCellCreated = expectation(description: "VehicleCells contains an error cell")

        viewModel.vehicleCells.subscribe(
            onNext: {
                let firstCellIsError: Bool

                if case.some(.error) = $0.first {
                    firstCellIsError = true
                } else {
                    firstCellIsError = false
                }

                XCTAssertTrue(firstCellIsError)
                expectErrorVehicleCellCreated.fulfill()
            }
        ).disposed(by: disposeBag)

        wait(for: [expectErrorVehicleCellCreated],timeout: 0.1)
    }
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
private final class MockAppServerClient: AppServerClient {
    var getVehiclesResult: Result<VehicleList, AppServerClient.GetFailureReason>?

    override func getVehicles(p1Lat:Double,p1Long:Double,p2Lat:Double,p2Long:Double) -> Observable<VehicleList> {
        return Observable.create { observer in
            switch self.getVehiclesResult {
            case .success(let friends)?:
                observer.onNext(friends)
            case .failure(let error)?:
                observer.onError(error!)
            case .none:
                observer.onError(AppServerClient.GetFailureReason.notFound)
            }

            return Disposables.create()
        }
    }

    
}
