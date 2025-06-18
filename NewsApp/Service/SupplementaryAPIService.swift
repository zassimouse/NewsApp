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
    
    var debugMode: Bool = false
    var forceErrorType: APIServiceError = .networkError(URLError(.notConnectedToInternet))
    
    func fetchSupplementaryItems() -> AnyPublisher<[SupplementaryBlock], APIServiceError> {
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
                case 400...499, 500...599:
                    throw APIServiceError.serverError(statusCode: httpResponse.statusCode)
                default:
                    throw APIServiceError.unknownError
                }
            }
            .decode(type: SupplementaryResponse.self, decoder: JSONDecoder())
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
            .map { $0.results }
            .eraseToAnyPublisher()
    }
}

struct SupplementaryResponse: Codable {
    let results: [SupplementaryBlock]
}
