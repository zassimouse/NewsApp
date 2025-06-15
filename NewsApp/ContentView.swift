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
    
    var body: some View {
        ZStack {
            NavigationView {
                articleList
                    .navigationBarTitle("News", displayMode: .large)
                    .background(.backgroundPrimary)

            }
            
            if viewModel.isLoading {
                ZStack {
                    Color.clear
                        .background(.ultraThinMaterial)
                    
                    ProgressView()
                        .scaleEffect(1.5)
                        .padding()
                }
            }
        }
    }
    
    
    private var articleList: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                Picker("Options", selection: $viewModel.selectedOption) {
                    ForEach(0..<viewModel.options.count, id: \.self) { index in
                        Text(viewModel.options[index])
                            .tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.bottom, 8)
                
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
    }
}

#Preview {
    NavigationView {
        ContentView()
    }
}
