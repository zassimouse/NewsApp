//
//  Date+Extensions.swift
//  NewsApp
//
//  Created by Denis Haritonenko on 18.06.25.
//

import Foundation

extension Date {
    func toDisplayString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
}
