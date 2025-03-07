//
//  BaseUseCase.swift
//  RandUsers
//
//  Created by Guido Fabio on 7/3/25.
//

protocol UseCase {
    associatedtype Params: Any
    associatedtype Response: Any
    func execute(with params: Params) -> Response
}
