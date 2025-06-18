//
//  SupplementaryItem.swift
//  NewsApp
//
//  Created by Denis Haritonenko on 17.06.25.
//

import Foundation

struct SupplementaryBlock: Codable, Identifiable {
    let id: Int
    let title: String
    let subtitle: String?
    let title_symbol: String?
    let button_title: String
    let button_symbol: String?
}
