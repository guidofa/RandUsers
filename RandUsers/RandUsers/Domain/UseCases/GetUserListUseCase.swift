//
//  Untitled.swift
//  RandUsers
//
//  Created by Guido Fabio on 7/3/25.
//

import Foundation

struct GetUserListUseCase: UseCase {

    // MARK: - Typealias

    typealias Params = Void
    typealias Response = [UserModel]

    private let networkManager: NetworkManager

    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }

    // MARK: - Implementation

    func execute(with params: Params) -> Response {
        return []
    }
}
