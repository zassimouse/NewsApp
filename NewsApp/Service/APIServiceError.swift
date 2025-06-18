//
//  APIServiceError.swift
//  NewsApp
//
//  Created by Denis Haritonenko on 18.06.25.
//

import Foundation

enum APIServiceError: Error, Equatable {
    case invalidURL
    case unauthorized
    case serverError(statusCode: Int)
    case decodingError(description: String)
    case networkError(URLError)
    case unknownError
}
