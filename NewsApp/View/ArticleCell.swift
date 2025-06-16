//
//  ArticleCell.swift
//  NewsApp
//
//  Created by Denis Haritonenko on 16.06.25.
//

import SwiftUI
import Kingfisher

struct ArticleCell: View {
    @State private var showBlockAlert = false
    @State private var blockAction: (() -> Void)?
    
    let article: Article
    @ObservedObject var viewModel: NewsViewModel
    
    var body: some View {
        HStack(alignment: .top) {
            KFImage(URL(string: article.imageURLString))
                .resizable()
                .clipped()
                .scaledToFill()
                .frame(width: 94, height: 72)
                .clipShape(RoundedRectangle(cornerRadius: 4))
            VStack(alignment: .leading) {
                Text(article.title)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.labelPrimary)
                Spacer()
                Text(article.description)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.labelSecondary)
                Spacer()
                Text("\(article.category) • \(article.date)")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.labelSecondary)
            }
            Spacer()
            Menu {
                switch viewModel.selectedOption {
                case 0: // All
                    Button {
                        viewModel.toggleFavorite(for: article.id)
                    } label: {
                        Label(
                            article.isFavorite ? "Remove from Favorites" : "Add to Favorites",
                            systemImage: article.isFavorite ? "heart.slash" : "heart"
                        )
                    }
                    
                    Button(role: .destructive) {
                        blockAction = {
                            viewModel.toggleBlock(for: article.id)
                        }
                        showBlockAlert = true
                    } label: {
                        Label("Block", systemImage: "nosign")
                    }
                    
                case 1: // Favorites
                    Button {
                        viewModel.toggleFavorite(for: article.id)
                    } label: {
                        Label("Remove from Favorites", systemImage: "heart.slash")
                    }
                    
                    Button(role: .destructive) {
                        blockAction = {
                            viewModel.toggleBlock(for: article.id)
                        }
                        showBlockAlert = true
                    } label: {
                        Label("Block", systemImage: "nosign")
                    }
                    
                case 2: // Blocked
                    Button {
                        blockAction = {
                            viewModel.toggleBlock(for: article.id)
                        }
                        viewModel.isLoading = true
                        showBlockAlert = true
                    } label: {
                        Label("Unblock", systemImage: "lock.open")
                    }
                    
                default:
                    EmptyView()
                }
            } label: {
                Image(systemName: "ellipsis.circle")
                    .font(.system(size: 24))
                    .foregroundStyle(.labelSecondary)
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .frame(height: 96)
        .background(.backgroundSecondary)
        .cornerRadius(16)
        .alert(isPresented: $showBlockAlert) {
             Alert(
                 title: Text(article.isBlocked ? "Unblock Article" : "Block Article"),
                 message: Text(article.isBlocked ? "Are you sure you want to unblock this article?" : "Are you sure you want to block this article?"),
                 primaryButton: .destructive(Text(article.isBlocked ? "Unblock" : "Block")) {
                     blockAction?()
                 },
                 secondaryButton: .cancel()
             )
         }
    }
}

//#Preview {
//    ArticleCell()
//}

struct ArticleCell_Previews: PreviewProvider {
    static var previews: some View {
        let mockArticle = Article(
            id: "1",
            title: "Bike season begins",
            description: "City bike shares are now open for the summer season",
            category: "City",
            date: "Apr 17, 2025",
            imageURLString: "https://static01.nyt.com/images/2025/04/18/multimedia/18biz-harvard-letter-bmwz/18biz-harvard-letter-bmwz-mediumThreeByTwo210.jpg",
            URLString: "",
            isFavorite: false,
            isBlocked: false
        )
        
        return ArticleCell(
            article: mockArticle,
            viewModel: NewsViewModel()
        )
    }
}


