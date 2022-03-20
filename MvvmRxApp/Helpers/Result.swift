//
//  Result.swift
//  MvvmRxApp
//
//  Created by MacBook Pro on 20/3/2022.
//

enum Result<T, U: Error> {
    case success(payload: T)
    case failure(U?)
}

enum EmptyResult<U: Error> {
    case success
    case failure(U?)
}
