//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Denis Haritonenko on 14.06.25.
//

import SwiftUI
import Combine

final class NewsViewModel: ObservableObject {
    
    enum FilterOption: Int, CaseIterable {
        case all
        case favorites
        case blocked
        
        var title: String {
            switch self {
            case .all: return "All"
            case .favorites: return "Favorites"
            case .blocked: return "Blocked"
            }
        }
    }
    
    enum AlertError: String {
        case somethingWentWrong = "Something went wrong"
        case noInternetConnection = "No internet connection"
        
        static func fromAPIError(_ error: Error) -> AlertError {
            if let apiError = error as? APIServiceError {
                switch apiError {
                case .networkError(let urlError):
                    switch urlError.code {
                    case .notConnectedToInternet, .networkConnectionLost:
                        return .noInternetConnection
                    default:
                        return .somethingWentWrong
                    }
                default:
                    return .somethingWentWrong
                }
            }
            return .somethingWentWrong
        }
    }
    
    let apiService = ArticleAPIService.shared
    let supplementaryAPIService = SupplementaryBlockAPIService.shared
    
    @Published private(set) var articles: [Article] = []
    @Published private(set) var filteredArticles: [Article] = []
    @Published private(set) var supplementaryItems: [SupplementaryBlock] = []
    
    @Published var selectedOption: FilterOption = .all {
        didSet {
            applyFilter()
        }
    }
    
    @Published var isLoading = true
    
    @Published var errorMessage: String?
    @Published var isShowingCellAlert = false
    
    @Published var showNetworkAlert = false
    @Published var networkAlertMessage = ""
    
    @Published var showBlockAlert = false
    @Published var blockAlertTitle = ""
    @Published var blockAlertMessage = ""
    @Published var blockAlertButtonTitle = ""
    @Published var blockAlertAction: (() -> Void)?
    
    var shouldShowBlur: Bool {
        isLoading || showNetworkAlert || showBlockAlert
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        loadNews()
    }
    
    func loadNews() {
        isLoading = true
        loadSupplementaryBlocks()
        loadArticles(period: 7)
    }
    
    func presentBlockAlert(for article: Article) {
        if article.isBlocked {
            blockAlertTitle = "Do you want to unblock?"
            blockAlertMessage = "Confirm to unblock this news source"
            blockAlertButtonTitle = "Unblock"
        } else {
            blockAlertTitle = "Do you want to block?"
            blockAlertMessage = "Confirm to hide this news source"
            blockAlertButtonTitle = "Block"
        }
        
        blockAlertAction = { [weak self] in
            self?.toggleBlock(for: article.id)
        }
        
        showBlockAlert = true
    }
    
    func loadArticles(period: Int) {
        errorMessage = nil
        
        apiService.fetchArticles(period: period)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    let alertError = AlertError.fromAPIError(error)
                    self?.networkAlertMessage = alertError.rawValue
                    self?.showNetworkAlert = true
                case .finished:
                    break
                }
            } receiveValue: { [weak self] articles in
                self?.articles = articles.sorted { $0.date > $1.date }
                self?.applyFilter()
            }
            .store(in: &cancellables)
    }
    
    func loadSupplementaryBlocks() {
        supplementaryAPIService.fetchSupplementaryItems()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    let alertError = AlertError.fromAPIError(error)
                    self?.networkAlertMessage = alertError.rawValue
                    self?.showNetworkAlert = true
                }
            } receiveValue: { [weak self] items in
                self?.supplementaryItems = items
            }
            .store(in: &cancellables)
    }
    
    private func applyFilter() {
        switch selectedOption {
        case .all:
            filteredArticles = articles.filter { !$0.isBlocked }
        case .favorites:
            filteredArticles = articles.filter { $0.isFavorite && !$0.isBlocked }
        case .blocked:
            filteredArticles = articles.filter { $0.isBlocked }
        }
    }
    
    func toggleFavorite(for articleId: String) {
        if let index = articles.firstIndex(where: { $0.id == articleId }) {
            articles[index].isFavorite.toggle()
            applyFilter()
        }
    }
    
    func toggleBlock(for articleId: String) {
        if let index = articles.firstIndex(where: { $0.id == articleId }) {
            articles[index].isBlocked.toggle()
            applyFilter()
        }
    }
}
