//
//  StringExtensions.swift
//  RandUsers
//
//  Created by Guido Fabio on 7/3/25.
//

import Foundation

extension String {
    static var empty: String {
        return ""
    }

    func toDate() -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.date(from: self)
    }
}
