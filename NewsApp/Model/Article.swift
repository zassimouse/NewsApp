//
//  Article.swift
//  NewsApp
//
//  Created by Denis Haritonenko on 16.06.25.
//

import Foundation

struct Article: Identifiable {
    let id: String
    let title: String
    let description: String
    let category: String
    let date: Date
    let imageURLString: String
    let URLString: String
    var isFavorite: Bool
    var isBlocked: Bool
}
