//
//  MockNetworkManager.swift
//  RandUsers
//
//  Created by Guido Fabio on 11/3/25.
//

@testable import RandUsers
import Foundation

class MockNetworkManager: NetworkManager {
    var fetchDataCalled = false
    func fetchData(from url: URL) async throws -> (Data, URLResponse) {
        fetchDataCalled = true

        let data = """
        {
            "results": [],
            "info": {
                "page": 1,
                "seed": "default"
            }
        }
        """.data(using: .utf8)!

        let response = HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: ["Content-Type": "application/json"]
        )!
        
        return (data, response)
    }
}
