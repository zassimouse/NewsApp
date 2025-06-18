//
//  String+Extensions.swift
//  NewsApp
//
//  Created by Denis Haritonenko on 15.06.25.
//

import Foundation

extension String {
    func toDate() -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        return formatter.date(from: self) ?? Date()
    }
}
