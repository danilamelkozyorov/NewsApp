//
//  NewsAPI.swift
//  TestTaskNews
//
//  Created by Мелкозеров Данила on 22.04.2022.
//

import Foundation
import RealmSwift

// MARK: - News
struct News: Codable {
    enum CodingKeys: String, CodingKey {
        case articles
    }
    let articles: [Article]?
}

// MARK: - Article
class Article: Object, Codable {

    enum CodingKeys: String, CodingKey {
        case title
        case articleDescription = "description"
        case url, urlToImage, publishedAt
    }
    
    @objc dynamic var url: String = ""
    @objc dynamic var publishedAt: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var articleDescription: String? = nil
    @objc dynamic var urlToImage: String? = nil
    
    convenience init(publishedAt: String, title: String, articleDescription: String? = nil, url: String, urlToImage: String? = nil) {
        self.init()
        self.publishedAt = publishedAt
        self.title = title
        self.articleDescription = articleDescription
        self.url = url
        self.urlToImage = urlToImage
    }
    
    override class func primaryKey() -> String? {
        return "url"
    }
}





