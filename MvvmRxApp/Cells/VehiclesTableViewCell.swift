//
//  VehiclesTableViewCell.swift
//  MvvmRxApp
//
//  Created by MacBook Pro on 22/3/2022.
//

import UIKit

class VehiclesTableViewCell: UITableViewCell {

    @IBOutlet weak var typeLbl: UILabel!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var headingLbl: UILabel!
    var viewModel: VehiclesCellViewModel? {
        didSet {
            bindViewModel()
        }
    }

    private func bindViewModel() {
        if let viewModel = viewModel {
            if let type = viewModel.type {
                typeLbl?.text = "type: \(type)"
            }
            if let state = viewModel.state {
                stateLbl?.text = "state: \(state)"
            }
            if let heading = viewModel.heading {
                headingLbl?.text = "heading: \(heading)"
            }
            
        }
    }
    
}
