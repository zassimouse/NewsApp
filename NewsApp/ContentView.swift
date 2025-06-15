//
//  ContentView.swift
//  NewsApp
//
//  Created by Denis Haritonenko on 13.06.25.
//

import SwiftUI

struct ContentView: View {
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.labelPrimary]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.labelPrimary]
    }
    
    @StateObject private var viewModel = NewsViewModel()
    
    @State private var selectedOption = 0
    private let options = ["All", "Favorites", "Blocked"]
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                Picker("Options", selection: $viewModel.selectedOption) {
                    ForEach(0..<viewModel.options.count, id: \.self) { index in
                        Text(viewModel.options[index])
                            .tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())

                ForEach(Array(viewModel.filteredArticles.enumerated()), id: \.element.id) { index, article in
                    VStack(spacing: 10) {
                        ArticleCell(article: article, viewModel: viewModel)
                            .onTapGesture {
                                if let url = URL(string: article.URLString) {
                                    UIApplication.shared.open(url)
                                }
                            }
                        
                        if viewModel.selectedOption == 0 && (index + 1) % 2 == 0 && index != viewModel.filteredArticles.count - 1 {
                            SupplementaryCell()
                        }
                    }
                }
                
                
            }
            .padding(.horizontal)
        }
        .background(.backgroundPrimary)
        .navigationBarTitle("News", displayMode: .large)
    }
}

#Preview {
    NavigationView {
        ContentView()
    }
}
