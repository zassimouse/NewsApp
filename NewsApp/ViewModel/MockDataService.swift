//
//  MockDataService.swift
//  NewsApp
//
//  Created by Denis Haritonenko on 14.06.25.
//

import SwiftUI

class MockDataService {
    static let shared = MockDataService()
    
    private init() {}
    
    func getMockArticles() -> [Article] {
        return [
            Article(
                id: "1",
                title: "Bike season begins",
                description: "City bike shares are now open for the summer season",
                category: "City",
                date: "Apr 17, 2025",
                imageURLString: "https://static01.nyt.com/images/2025/04/18/multimedia/18biz-harvard-letter-bmwz/18biz-harvard-letter-bmwz-mediumThreeByTwo210.jpg",
                URLString: "https://www.nytimes.com/2025/04/14/us/harvard-trump-reject-demands.html",
                isFavorite: true,
                isBlocked: false
            ),
            Article(
                id: "2",
                title: "New park opening",
                description: "The city council announces a new central park",
                category: "City",
                date: "Apr 15, 2025",
                imageURLString: "https://static01.nyt.com/images/2025/04/18/multimedia/18biz-harvard-letter-bmwz/18biz-harvard-letter-bmwz-mediumThreeByTwo210.jpg",
                URLString: "https://example.com/news/2",
                isFavorite: false,
                isBlocked: false
            ),
            Article(
                id: "3",
                title: "Tech conference 2025",
                description: "Annual developer conference starts next week",
                category: "Tech",
                date: "Apr 10, 2025",
                imageURLString: "https://static01.nyt.com/images/2025/04/18/multimedia/18biz-harvard-letter-bmwz/18biz-harvard-letter-bmwz-mediumThreeByTwo210.jpg",
                URLString: "https://example.com/news/3",
                isFavorite: false,
                isBlocked: true
            ),
            Article(
                id: "4",
                title: "Weather alert",
                description: "Heavy rains expected this weekend",
                category: "Weather",
                date: "Apr 8, 2025",
                imageURLString: "https://static01.nyt.com/images/2025/04/18/multimedia/18biz-harvard-letter-bmwz/18biz-harvard-letter-bmwz-mediumThreeByTwo210.jpg",
                URLString: "https://example.com/news/4",
                isFavorite: true,
                isBlocked: false
            ),
            Article(
                id: "5",
                title: "Transportation strike",
                description: "Public transport workers announce strike",
                category: "Transport",
                date: "Apr 5, 2025",
                imageURLString: "https://static01.nyt.com/images/2025/04/18/multimedia/18biz-harvard-letter-bmwz/18biz-harvard-letter-bmwz-mediumThreeByTwo210.jpg",
                URLString: "https://example.com/news/5",
                isFavorite: false,
                isBlocked: false
            ),
            Article(
                id: "6",
                title: "Bike season begins",
                description: "City bike shares are now open for the summer season",
                category: "City",
                date: "Apr 17, 2025",
                imageURLString: "https://static01.nyt.com/images/2025/04/18/multimedia/18biz-harvard-letter-bmwz/18biz-harvard-letter-bmwz-mediumThreeByTwo210.jpg",
                URLString: "https://example.com/news/1",
                isFavorite: true,
                isBlocked: false
            ),
            Article(
                id: "8",
                title: "New park opening",
                description: "The city council announces a new central park",
                category: "City",
                date: "Apr 15, 2025",
                imageURLString: "https://static01.nyt.com/images/2025/04/18/multimedia/18biz-harvard-letter-bmwz/18biz-harvard-letter-bmwz-mediumThreeByTwo210.jpg",
                URLString: "https://example.com/news/2",
                isFavorite: false,
                isBlocked: false
            ),
            Article(
                id: "10",
                title: "Tech conference 2025",
                description: "Annual developer conference starts next week",
                category: "Tech",
                date: "Apr 10, 2025",
                imageURLString: "https://static01.nyt.com/images/2025/04/18/multimedia/18biz-harvard-letter-bmwz/18biz-harvard-letter-bmwz-mediumThreeByTwo210.jpg",
                URLString: "https://example.com/news/3",
                isFavorite: false,
                isBlocked: true
            ),
            Article(
                id: "11",
                title: "Weather alert",
                description: "Heavy rains expected this weekend",
                category: "Weather",
                date: "Apr 8, 2025",
                imageURLString: "https://static01.nyt.com/images/2025/04/18/multimedia/18biz-harvard-letter-bmwz/18biz-harvard-letter-bmwz-mediumThreeByTwo210.jpg",
                URLString: "https://example.com/news/4",
                isFavorite: true,
                isBlocked: false
            ),
            Article(
                id: "13",
                title: "Transportation strike",
                description: "Public transport workers announce strike",
                category: "Transport",
                date: "Apr 5, 2025",
                imageURLString: "https://static01.nyt.com/images/2025/04/18/multimedia/18biz-harvard-letter-bmwz/18biz-harvard-letter-bmwz-mediumThreeByTwo210.jpg",
                URLString: "https://example.com/news/5",
                isFavorite: false,
                isBlocked: false
            )
        ]
    }
}
