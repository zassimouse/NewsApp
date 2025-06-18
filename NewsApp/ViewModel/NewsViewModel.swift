//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Denis Haritonenko on 14.06.25.
//

import SwiftUI
import Combine

enum AlertError: String {
    case somethingWentWrong = "Something went wrong"
    case noInternetConnection = "No internet connection"
    
    static func fromAPIError(_ error: Error) -> AlertError {
        if let apiError = error as? NewsAPIService.APIErrorType {
            switch apiError {
            case .networkError(let urlError) where urlError.code == .notConnectedToInternet:
                return .noInternetConnection
            default:
                return .somethingWentWrong
            }
        } else if let apiError = error as? SupplementaryAPIService.APIError {
            switch apiError {
            case .networkError(let urlError) where urlError.code == .notConnectedToInternet:
                return .noInternetConnection
            default:
                return .somethingWentWrong
            }
        }
        return .somethingWentWrong
    }
}

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
    
    let apiService = NewsAPIService.shared
    let supplementaryAPIService = SupplementaryAPIService.shared
    
    @Published private(set) var articles: [Article] = []
    @Published private(set) var filteredArticles: [Article] = []
    @Published private(set) var supplementaryItems: [SupplementaryBlock] = []
    
    @Published var selectedOption: FilterOption = .all {
        didSet {
            applyFilter()
        }
    }
    
    @Published var isLoadingNews = true
    @Published var isLoadingSupplementary = false
    
    @Published var errorMessage: String?
    @Published var isShowingCellAlert = false
    
    @Published var showAlert = false
    @Published var alertMessage = ""
    
    @Published var showBlockAlert = false
    @Published var blockAlertTitle = ""
    @Published var blockAlertMessage = ""
    @Published var blockAlertButtonTitle = ""
    @Published var blockAlertAction: (() -> Void)?
    
    var shouldShowBlur: Bool {
        isLoadingNews || showAlert || showBlockAlert
    }
    
    private var cancellables = Set<AnyCancellable>()

    init() {
        loadNews()
    }
    
    func loadNews() {
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
        isLoadingNews = true
        errorMessage = nil
        
        apiService.fetchArticles(period: period)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoadingNews = false
                switch completion {
                case .failure(let error):
                    let alertError = AlertError.fromAPIError(error)
                    self?.alertMessage = alertError.rawValue
                    self?.showAlert = true
                case .finished:
                    break
                }
            } receiveValue: { [weak self] articles in
                self?.articles = articles
                self?.applyFilter()
            }
            .store(in: &cancellables)
    }
    
    func loadSupplementaryBlocks() {
        isLoadingSupplementary = true
        
        supplementaryAPIService.fetchSupplementaryItems()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoadingSupplementary = false
                if case .failure(let error) = completion {
                    let alertError = AlertError.fromAPIError(error)
                    self?.alertMessage = alertError.rawValue
                    self?.showAlert = true
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
