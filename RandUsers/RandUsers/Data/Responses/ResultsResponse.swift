//
//  ResultsResponse.swift
//  RandUsers
//
//  Created by Guido Fabio on 7/3/25.
//

import Foundation

struct Results: Codable {
    let info: InfoResponse
    let results: [UserResponse]?
}
