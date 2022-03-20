//
//  Alert.swift
//  MvvmRxApp
//
//  Created by MacBook Pro on 20/3/2022.
//
import UIKit

struct AlertAction {
    let buttonTitle: String
    let handler: (() -> Void)?
}

struct SingleButtonAlert {
    let title: String
    let message: String?
    let action: AlertAction
}
