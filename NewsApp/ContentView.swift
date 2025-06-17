//
//  ContentView.swift
//  NewsApp
//
//  Created by Denis Haritonenko on 13.06.25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = NewsViewModel()
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.labelPrimary]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.labelPrimary]
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                articleList
                    .navigationBarTitle("News", displayMode: .large)
                    .background(.backgroundPrimary)
            }
            
            blurOverlay
            
            if viewModel.showAlert {
                Color.clear
                    .alert("Error", isPresented: $viewModel.showAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text(viewModel.alertMessage)
                    }
            }
            
            if viewModel.isLoading {
                ProgressView()
                    .scaleEffect(1.5)
            }
        }
    }
    
    @ViewBuilder
    private var blurOverlay: some View {
        if viewModel.shouldShowBlur {
            Color.clear
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
        }
    }
    
    private var emptyStateView: some View {
        Group {
            switch viewModel.selectedOption {
            case 1:
                emptyStateContent(icon: "heart.circle.fill", text: "No Favorite News", showButton: false)
            case 2:
                emptyStateContent(icon: "nosign", text: "No Blocked News", showButton: false)
            default:
                emptyStateContent(icon: "exclamationmark.circle.fill", text: "No News Available", showButton: true)
            }
        }
    }
    
    @ViewBuilder
    private func emptyStateContent(icon: String, text: String, showButton: Bool) -> some View {
        VStack {
            Spacer()
            VStack {
                Image(systemName: icon)
                    .font(.system(size: 40, weight: .light))
                    .foregroundStyle(.accentPrimary)
                Spacer()
                Text(text)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.labelPrimary)
                if showButton {
                    Spacer()
                    PrimaryButton(title: "Refresh", symbolName: "arrow.left", action: {
                        viewModel.loadArticles(period: 7)
                    })
                }
            }
            .frame(height: showButton ? 120 : 76)
            Spacer()
        }
    }
    
    private var articleList: some View {
        ScrollView {
            VStack {
                Picker("Options", selection: $viewModel.selectedOption) {
                    ForEach(0..<viewModel.options.count, id: \.self) { index in
                        Text(viewModel.options[index])
                            .tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.bottom, 8)
                
                if viewModel.filteredArticles.isEmpty {
                    emptyStateView
                        .frame(minHeight: 400)
                } else {
                    LazyVStack(spacing: 10) {
                        ForEach(Array(viewModel.filteredArticles.enumerated()), id: \.element.id) { index, article in
                            ArticleCell(article: article, viewModel: viewModel)
                                .onTapGesture {
                                    if let url = URL(string: article.URLString) {
                                        UIApplication.shared.open(url)
                                    }
                                }
                            
                            if viewModel.selectedOption == 0 && (index + 1) % 2 == 0 && index != viewModel.filteredArticles.count - 1 {
                                if !viewModel.supplementaryItems.isEmpty {
                                    let supplementaryIndex = (index / 2) % viewModel.supplementaryItems.count
                                    SupplementaryCell(item: viewModel.supplementaryItems[supplementaryIndex])
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
        }
        .refreshable {
        }
    }
    
}

#Preview {
    NavigationView {
        ContentView()
    }
}
