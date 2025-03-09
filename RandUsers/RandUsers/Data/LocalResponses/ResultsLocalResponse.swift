//
//  ResultsLocalResponse.swift
//  RandUsers
//
//  Created by Guido Fabio on 9/3/25.
//

import Foundation
import RealmSwift

class ResultLocalResponse: Object {
    @Persisted var page: Int?
    @Persisted var seed: String?
    @Persisted var users: List<UserLocalResponse>
}
