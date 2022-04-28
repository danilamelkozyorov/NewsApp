//
//  Constants.swift
//  TestTaskNews
//
//  Created by Мелкозеров Данила on 26.04.2022.
//

import Foundation

struct Constants {
    
    struct URL {
        static let url = "https://newsapi.org/v2/everything?q=android&from=2019-04-00&sortBy=publishedAt&apiKey=8e5f1094fb44479abc4a772cfaa81272&page="
    }

    struct Settings {
        static let itemsForPage = 20
        static let prefetchingMargin = 5
        static let maxPagesCount = 5
    }
}
