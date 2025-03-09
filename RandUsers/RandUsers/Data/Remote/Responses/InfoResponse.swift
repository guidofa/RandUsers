//
//  InfoResponse.swift
//  RandUsers
//
//  Created by Guido Fabio on 7/3/25.
//

import Foundation

struct InfoResponse: Codable {
    let page: Int?
    let results: Int?
    let seed: String?
    let version: String?
}
