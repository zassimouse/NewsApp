//
//  NewsViewModel.swift
//  NewsApp
//
//  Created by Denis Haritonenko on 14.06.25.
//

import SwiftUI

class NewsViewModel: ObservableObject {
    @Published private(set) var articles: [Article] = []
    @Published private(set) var filteredArticles: [Article] = []
    @Published var selectedOption: Int = 0 {
        didSet {
            print(selectedOption)
            applyFilter()
        }
    }
    
    let options = ["All", "Favorites", "Blocked"]
    
    init() {
        loadArticles()
    }
    
//    private func loadArticles() {
//        articles = MockDataService.shared.getMockArticles()
//        filterArticles()
//    }
//    
//    private func filterArticles() {
//        switch selectedOption {
//        case 1:
//            filteredArticles = articles.filter { $0.isFavorite && !$0.isBlocked }
//        case 2:
//            filteredArticles = articles.filter { $0.isBlocked }
//        default:
//            filteredArticles = articles.filter { !$0.isBlocked }
//        }
//    }
    
    private func loadArticles() {
        articles = MockDataService.shared.getMockArticles()
        applyFilter()
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
