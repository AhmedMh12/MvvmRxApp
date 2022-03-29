//
//  VehiclesTableViewController.swift
//  MvvmRxApp
//
//  Created by MacBook Pro on 22/3/2022.
//

import Foundation
import UIKit
import PKHUD
import RxSwift
import RxDataSources

public class VehiclesTableViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    let viewModel: VehiclesTableViewViewModel = VehiclesTableViewViewModel()

    private let disposeBag = DisposeBag()

    private var selectFriendPayload = ReadOnce<VehiclesCellViewModel>(nil)

    public override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib(nibName: "VehiclesTableViewCell", bundle: nil), forCellReuseIdentifier: "VehiclesTableViewCell")
        bindViewModel()
        setupCellTapHandling()

        viewModel.getvehicless(p1Lat:53.694865,p1Long:9.757589,p2Lat:53.394655,p2Long:10.099891)
    }

    // MARK: bindViewModel
    
    func bindViewModel() {
        viewModel.vehicleCells.bind(to: self.tableView.rx.items) { tableView, index, element in
            let indexPath = IndexPath(item: index, section: 0)
            switch element {
            case .normal(let viewModel):
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "VehiclesTableViewCell", for: indexPath) as? VehiclesTableViewCell else {
                    return UITableViewCell()
                }
                cell.viewModel = viewModel
                return cell
            case .error(let message):
                let cell = UITableViewCell()
                cell.isUserInteractionEnabled = false
                cell.textLabel?.text = message
                return cell
            case .empty:
                let cell = UITableViewCell()
                cell.isUserInteractionEnabled = false
                cell.textLabel?.text = "No data available"
                return cell
            }
        }.disposed(by: disposeBag)

        viewModel
            .onShowError
            .map { [weak self] in self?.presentSingleButtonDialog(alert: $0)}
            .subscribe()
            .disposed(by: disposeBag)

        viewModel
            .onShowLoadingHud
            .map { [weak self] in self?.setLoadingHud(visible: $0) }
            .subscribe()
            .disposed(by: disposeBag)
    }

    // MARK: setLoadingHud
    
    private func setLoadingHud(visible: Bool) {
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        visible ? PKHUD.sharedHUD.show(onView: view) : PKHUD.sharedHUD.hide()
    }
    
    // MARK: setupCellTapHandling
    
    private func setupCellTapHandling() {
        tableView
            .rx
            .modelSelected(VehiclesTableViewCellType.self)
            .subscribe(
                onNext: { [weak self] vehicleCellType in
                    if case let .normal(viewModel) = vehicleCellType {
                        // cell selection Action
                    }
                    if let selectedRowIndexPath = self?.tableView.indexPathForSelectedRow {
                        self?.tableView?.deselectRow(at: selectedRowIndexPath, animated: true)
                    }
                }
            )
            .disposed(by: disposeBag)
    }



  

}
// MARK: - SingleButtonDialogPresenter
extension VehiclesTableViewController: SingleButtonDialogPresenter { }
