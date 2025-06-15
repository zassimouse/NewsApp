//
//  ArticleCell.swift
//  NewsApp
//
//  Created by Denis Haritonenko on 14.06.25.
//

import SwiftUI
import Kingfisher

struct ArticleCell: View {
    let article: Article
    @ObservedObject var viewModel: NewsViewModel
    
    var body: some View {
        HStack(alignment: .top) {
            
//            article.image
//                .resizable()
//                .clipped()
//                .scaledToFill()
//                .frame(width: 94, height: 72)
//                .clipShape(RoundedRectangle(cornerRadius: 4))
            KFImage(URL(string: article.imageURLString)) // Assuming article.image is a URL string
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
                Button {
                    viewModel.toggleFavorite(for: article.id)
                } label: {
                    Label(
                        article.isFavorite ? "Remove from Favorites" : "Add to Favorites",
                        systemImage: article.isFavorite ? "heart.fill" : "heart"
                    )
                }
                
                Button(role: .destructive) {
                    viewModel.toggleBlock(for: article.id)
                } label: {
                    Label(
                        article.isBlocked ? "Unblock" : "Block",
                        systemImage: article.isBlocked ? "eye.slash.fill" : "eye.slash"
                    )
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
