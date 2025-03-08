//
//  InfoResponse.swift
//  RandUsers
//
//  Created by Guido Fabio on 7/3/25.
//

import Foundation

struct InfoResponse: Codable {
    let seed: String?
    let results: Int?
    let page: Int?
    let version: String?
}
