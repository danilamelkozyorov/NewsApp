//
//  AlamofireRequest.swift
//  TestTaskNews
//
//  Created by Мелкозеров Данила on 26.04.2022.
//

import Foundation
import Alamofire


class AlamofireRequest {
    
    func fetchNews(for page: Int, completion: @escaping (_ news: [Article]) -> ()) {
        AF.request(getCompleteURL(for: page))
            .validate()
            .response { response in
            switch response.result {
            case .success(let data):
                guard let data = data else { return }
                do {
                    let decodingNews = try JSONDecoder()
                        .decode(News.self, from: data)
                    let news = decodingNews.articles ?? []
                    completion(news)
                } catch let error {
                    print("error serialization json, \(error)")
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

private func getCompleteURL(for page: Int) -> URL {
    let completeUrlString = Constants.URL.url + String(page)
    let completeUrl = URL(string: completeUrlString)
    return completeUrl!
}
