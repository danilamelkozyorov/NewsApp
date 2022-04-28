//
//  NewsTableViewCell.swift
//  TestTaskNews
//
//  Created by Мелкозеров Данила on 21.04.2022.
//

import UIKit
import Kingfisher

class NewsTableViewCell: UITableViewCell {

    let newsImageView = UIImageView()
    let newsTitle = UILabel()
    let newsDescription = UILabel()
    let newsDatePublished = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(newsImageView)
        configureImageNews()
        setImageNewsConstraints()

        addSubview(newsTitle)
        configureTitleNews()
        setTitleNewsConstraints()

        addSubview(newsDescription)
        configureDescriptionNews()
        setDescriptionNewsConstraints()

        addSubview(newsDatePublished)
        configureDatePublishedNews()
        setDatePublishedNewsConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsImageView.image = nil
        newsTitle.text = nil
        newsDescription.text = nil
        newsDatePublished.text = nil
    }
    
//MARK: - Configuring UIObjects
    private func configureImageNews() {
        newsImageView.translatesAutoresizingMaskIntoConstraints = false
        newsImageView.layer.cornerRadius = 5
        newsImageView.contentMode = .scaleAspectFill
        newsImageView.clipsToBounds = true
    }
    
    private func configureTitleNews() {
        newsTitle.translatesAutoresizingMaskIntoConstraints = false
        newsTitle.numberOfLines = 0
        newsTitle.font = UIFont.systemFont(ofSize: 20)
    }

    private func configureDescriptionNews() {
        newsDescription.translatesAutoresizingMaskIntoConstraints = false
        newsDescription.numberOfLines = 0
        newsDescription.font = UIFont.systemFont(ofSize: 17)
        newsDescription.textColor = .darkGray
    }
    
    private func configureDatePublishedNews() {
        newsDatePublished.translatesAutoresizingMaskIntoConstraints = false
        newsDatePublished.textColor = .darkText
        newsDatePublished.textAlignment = .right
        newsDatePublished.font = UIFont.systemFont(ofSize: 13)
    }
 
//MARK: - Set constraints for UIObjects
    private func setImageNewsConstraints() {
        NSLayoutConstraint.activate([
            newsImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            newsImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            newsImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            newsImageView.widthAnchor.constraint(equalTo: newsImageView.heightAnchor, multiplier: 17/9)
            
        ])
    }
    
    private func setTitleNewsConstraints() {
        NSLayoutConstraint.activate([
            newsTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            newsTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            newsTitle.topAnchor.constraint(equalTo: newsImageView.bottomAnchor, constant: 5)
        ])
    }
 
    private func setDescriptionNewsConstraints() {
        NSLayoutConstraint.activate([
            newsDescription.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            newsDescription.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -5),
            newsDescription.topAnchor.constraint(equalTo: newsTitle.bottomAnchor, constant: 5)
        ])
    }
    
    private func setDatePublishedNewsConstraints() {
        NSLayoutConstraint.activate([
            newsDatePublished.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            newsDatePublished.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            newsDatePublished.topAnchor.constraint(equalTo: newsDescription.bottomAnchor, constant: 5),
            newsDatePublished.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }
    
    func setCell(new: Article) {
        newsTitle.text = new.title
        newsDescription.text = new.articleDescription
        var refactPublishedAt = new.publishedAt.replacingOccurrences(of: "T", with: " ")
        refactPublishedAt = String(refactPublishedAt.prefix(16))
        newsDatePublished.text = refactPublishedAt
        guard let imageURL = URL(string: new.urlToImage ?? "") else { return }
        newsImageView.kf.setImage(with: imageURL)
    }
}

