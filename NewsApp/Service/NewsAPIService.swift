//
//  NewsAPIService.swift
//  NewsApp
//
//  Created by Denis Haritonenko on 15.06.25.
//

import Foundation
import Combine

struct APIError: Error {
    let message: String
}

final class NewsAPIService {
    static let shared = NewsAPIService()
    private let baseURL = "https://us-central1-server-side-functions.cloudfunctions.net/nytimes"
    
    private init() { }
    
    func fetchArticles(period: Int) -> AnyPublisher<[Article], Error> {
        guard let url = URL(string: baseURL) else {
            return Fail(error: APIError(message: "Invalid URL")).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.addValue("denis-haritonenko", forHTTPHeaderField: "authorization")
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "period", value: "\(period)")]
        
        guard let finalURL = components?.url else {
            return Fail(error: APIError(message: "Invalid URL components")).eraseToAnyPublisher()
        }
        
        request.url = finalURL
        
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
            .decode(type: NYTimesResponse.self, decoder: JSONDecoder())
            .map { response in
                response.results.map { result in
                    Article(
                        id: String(result.id),
                        title: result.title,
                        description: result.abstract,
                        category: result.section,
                        date: result.published_date.formattedDate() ?? result.published_date,
                        imageURLString: result.media.first?.mediaMetadata.first?.url ?? "",
                        URLString: result.url,
                        isFavorite: false,
                        isBlocked: false
                    )
                }
            }
            .eraseToAnyPublisher()
    }
}

struct NYTimesResponse: Codable {
    let status: String
    let results: [NYTimesArticle]
}

struct NYTimesArticle: Codable {
    let id: Int
    let title: String
    let abstract: String
    let section: String
    let published_date: String
    let url: String
    let media: [Media]
    
    struct Media: Codable {
        let mediaMetadata: [MediaMetadata]
        
        enum CodingKeys: String, CodingKey {
            case mediaMetadata = "media-metadata"
        }
    }
    
    struct MediaMetadata: Codable {
        let url: String
    }
}
