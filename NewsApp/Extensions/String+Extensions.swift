//
//  String+Extensions.swift
//  NewsApp
//
//  Created by Denis Haritonenko on 15.06.25.
//

import Foundation

extension String {
    func formattedDate(
        from inputFormat: String = "yyyy-MM-dd",
        to outputFormat: String = "MMM d, yyyy",
        locale: Locale = .current
    ) -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
        outputFormatter.locale = locale
        
        guard let date = inputFormatter.date(from: self) else { return nil }
        return outputFormatter.string(from: date)
    }
}
