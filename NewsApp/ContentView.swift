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
            NavigationStack {
                articleList
                    .navigationBarTitle("News", displayMode: .large)
                    .background(.backgroundPrimary)
                
                    .alert("Error", isPresented: $viewModel.showNetworkAlert) {
                        Button("OK", role: .cancel) { }
                    } message: {
                        Text(viewModel.networkAlertMessage)
                    }
                    .alert(viewModel.blockAlertTitle, isPresented: $viewModel.showBlockAlert) {
                        Button(viewModel.blockAlertButtonTitle,
                               role: .destructive) {
                            viewModel.blockAlertAction?()
                        }
                        Button("Cancel", role: .cancel) { }
                    } message: {
                        Text(viewModel.blockAlertMessage)
                    }
            }

            blurOverlay
            
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
            case .all:
                emptyStateContent(icon: "exclamationmark.circle.fill", text: "No News Available", showButton: true)
            case .favorites:
                emptyStateContent(icon: "heart.circle.fill", text: "No Favorite News", showButton: false)
            case .blocked:
                emptyStateContent(icon: "nosign", text: "No Blocked News", showButton: false)
            }
        }
    }
    
    @ViewBuilder
    private func emptyStateContent(icon: String, text: String, showButton: Bool) -> some View {
        VStack(spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 40, weight: .light))
                .foregroundColor(.accentPrimary)
            
            Text(text)
                .font(.headline)
                .foregroundColor(.labelPrimary)
                .multilineTextAlignment(.center)
            
            if showButton {
                PrimaryButton(
                    title: "Refresh",
                    symbolName: "arrow.clockwise",
                    action: { viewModel.loadNews() }
                )
            }
            
            Spacer()
        }
        .padding(.top, 80)
    }
    
    private var articleList: some View {
        ScrollView {
            VStack {
                Picker("Options", selection: $viewModel.selectedOption) {
                    ForEach(NewsViewModel.FilterOption.allCases, id: \.self) { option in
                        Text(option.title)
                            .tag(option)
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
                            
                            if viewModel.selectedOption == .all && (index + 1) % 2 == 0 && index != viewModel.filteredArticles.count - 1 {
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
            viewModel.loadNews()
        }
    }
    
}

#Preview {
    NavigationStack {
        ContentView()
    }
}
