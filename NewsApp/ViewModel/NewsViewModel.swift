//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Denis Haritonenko on 14.06.25.
//

import SwiftUI
import Combine

class NewsViewModel: ObservableObject {
    @Published private(set) var articles: [Article] = []
    @Published private(set) var filteredArticles: [Article] = []
    @Published private(set) var supplementaryItems: [SupplementaryItem] = []

    @Published var selectedOption: Int = 0 {
        didSet {
            applyFilter()
        }
    }
    @Published var isLoading = true
    @Published var isLoadingSupplementary = false
    
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    let options = ["All", "Favorites", "Blocked"]
    let apiService = NewsAPIService.shared
    let supplementaryAPIService = SupplementaryAPIService.shared

    
    init() {
        loadSupplementaryItems()
        loadArticles(period: 7)
    }
    
    func loadArticles(period: Int) {
        isLoading = true
        errorMessage = nil
        
        apiService.fetchArticles(period: period)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                switch completion {
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    self?.applyFilter()
                case .finished:
                    break
                }
            } receiveValue: { [weak self] articles in
                self?.articles = articles
                self?.applyFilter()
            }
            .store(in: &cancellables)
    }
    
    func loadSupplementaryItems() {
        isLoadingSupplementary = true
        
        supplementaryAPIService.fetchSupplementaryItems()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoadingSupplementary = false
                if case .failure(let error) = completion {
                    print("Supplementary items loading failed: \(error.localizedDescription)")
                    // You can add mock supplementary items here if needed
                }
            } receiveValue: { [weak self] items in
                self?.supplementaryItems = items
            }
            .store(in: &cancellables)
    }
    
    private func applyFilter() {
        switch selectedOption {
        case 1: // Favorites
            filteredArticles = articles.filter { $0.isFavorite && !$0.isBlocked }
        case 2: // Blocked
            filteredArticles = articles.filter { $0.isBlocked }
        default: // All
            filteredArticles = articles.filter { !$0.isBlocked }
        }
    }
    
    func toggleFavorite(for articleId: String) {
        if let index = articles.firstIndex(where: { $0.id == articleId }) {
            articles[index].isFavorite.toggle()
            applyFilter() // Re-filter after change
        }
    }
    
    func toggleBlock(for articleId: String) {
        if let index = articles.firstIndex(where: { $0.id == articleId }) {
            articles[index].isBlocked.toggle()
            applyFilter() // Re-filter after change
        }
    }
}
