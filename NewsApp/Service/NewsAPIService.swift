//
//  NewsAPIService.swift
//  NewsApp
//
//  Created by Denis Haritonenko on 15.06.25.
//

import Foundation
import Combine

final class NewsAPIService {
    static let shared = NewsAPIService()
    private let baseURL = "https://us-central1-server-side-functions.cloudfunctions.net/nytimes"
    
    private init() { }
    
    var debugMode: Bool = false
    var forceErrorType: APIServiceError = .networkError(URLError(.notConnectedToInternet))
    
    func fetchArticles(period: Int) -> AnyPublisher<[Article], APIServiceError> {
        if debugMode {
            switch forceErrorType {
            case .invalidURL:
                return Fail(error: .invalidURL).eraseToAnyPublisher()
            case .unauthorized:
                return Fail(error: .unauthorized)
                    .delay(for: .seconds(3), scheduler: DispatchQueue.main)
                    .eraseToAnyPublisher()
            case .serverError:
                return Fail(error: .serverError(statusCode: 500)).eraseToAnyPublisher()
            case .decodingError:
                return Fail(error: .decodingError(description: "Debug decoding error")).eraseToAnyPublisher()
            case .networkError:
                return Fail(error: .networkError(URLError(.notConnectedToInternet))).eraseToAnyPublisher()
            case .unknownError:
                return Fail(error: .unknownError).eraseToAnyPublisher()
            }
        }
        
        guard let url = URL(string: baseURL) else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.addValue("denis-haritonenko", forHTTPHeaderField: "authorization")
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.queryItems = [URLQueryItem(name: "period", value: "\(period)")]
        
        guard let finalURL = components?.url else {
            return Fail(error: .invalidURL).eraseToAnyPublisher()
        }
        
        request.url = finalURL
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .mapError { error -> APIServiceError in
                return .networkError(error)
            }
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw APIServiceError.unknownError
                }
                
                switch httpResponse.statusCode {
                case 200...299:
                    return data
                case 401:
                    throw APIServiceError.unauthorized
                case 400...499:
                    throw APIServiceError.serverError(statusCode: httpResponse.statusCode)
                case 500...599:
                    throw APIServiceError.serverError(statusCode: httpResponse.statusCode)
                default:
                    throw APIServiceError.unknownError
                }
            }
            .decode(type: NYTimesResponse.self, decoder: JSONDecoder())
            .mapError { error -> APIServiceError in
                switch error {
                case let apiError as APIServiceError:
                    return apiError
                case let decodingError as DecodingError:
                    return .decodingError(description: decodingError.localizedDescription)
                default:
                    return .unknownError
                }
            }
            .map { response in
                response.results.map { result in
                    Article(
                        id: String(result.id),
                        title: result.title,
                        description: result.abstract,
                        category: result.section,
                        date: result.published_date.toDate(),
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
