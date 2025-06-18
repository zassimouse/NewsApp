//
//  SupplementaryAPIService.swift
//  NewsApp
//
//  Created by Denis Haritonenko on 16.06.25.
//

import Foundation
import Combine

final class SupplementaryAPIService {
    static let shared = SupplementaryAPIService()
    private let baseURL = "https://us-central1-server-side-functions.cloudfunctions.net/supplementary"
    
    private init() { }
    
    func fetchSupplementaryItems() -> AnyPublisher<[SupplementaryBlock], Error> {
        guard let url = URL(string: baseURL) else {
            return Fail(error: APIError(message: "Invalid URL")).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.addValue("denis-haritonenko", forHTTPHeaderField: "authorization")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIError(message: "Invalid response")
                }
                
                if httpResponse.statusCode == 401 {
                    throw APIError(message: "Unauthorized")
                }
                
                if !(200...299).contains(httpResponse.statusCode) {
                    throw APIError(message: "Server error: \(httpResponse.statusCode)")
                }
                
                return data
            }
            .decode(type: SupplementaryResponse.self, decoder: JSONDecoder())
            .map { $0.results }
            .eraseToAnyPublisher()
    }
}

struct SupplementaryResponse: Codable {
    let results: [SupplementaryBlock]
}
