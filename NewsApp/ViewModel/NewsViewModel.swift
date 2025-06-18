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
        } else {
            blockAlertTitle = "Do you want to block?"
            blockAlertMessage = "Confirm to hide this news source"
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
                    self?.alertMessage = error.localizedDescription
                    self?.showAlert = true
                    self?.applyFilter()
                case .finished:
                    break
                }
            } receiveValue: { [weak self] articles in
                self?.articles = articles
                self?.applyFilter()
                
                // Print name and image URL for each article
                for article in articles {
                    print("Article Name: \(article.title)")
                    print("Image URL: \(article.imageURLString)")
                    print("------")
                }
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
                    print("Supplementary items loading failed: \(error.localizedDescription)")
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
        
        filteredArticles.sort { $0.date > $1.date }
    }
    
    private func dateFromString(_ dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy"
        return dateFormatter.date(from: dateString)
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
