//
//  NewsViewController.swift
//  TestTaskNews
//
//  Created by Мелкозеров Данила on 21.04.2022.
//

import UIKit

class ViewController: UIViewController {
    
    let startButton = UIButton()
    let startImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        configureStartImageView()
        setStartImageViewConstraints()
        
        configureStartButton()
        setStartButtonConstraints()
    }
  
    @objc private func buttonAction() {
        let tableViewNew = NewsTableViewController()
        tableViewNew.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(tableViewNew, animated: true)
    }
    
    private func configureView() {
        title = "Main Screen"
        view.backgroundColor = .secondarySystemBackground
    }
    
    private func configureStartImageView() {
        view.addSubview(startImageView)
        startImageView.translatesAutoresizingMaskIntoConstraints = false
        startImageView.image = UIImage(named: "startImage")
        startImageView.contentMode = .scaleAspectFill
    }
    
    private func setStartImageViewConstraints() {
        NSLayoutConstraint.activate([
            startImageView.topAnchor.constraint(equalTo: view.topAnchor),
            startImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            startImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            startImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func configureStartButton() {
        view.addSubview(startButton)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        startButton.backgroundColor = .darkGray
        startButton.setTitle("Show News", for: .normal)
        startButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    private func setStartButtonConstraints() {
        NSLayoutConstraint.activate([
            startButton.centerXAnchor.constraint(equalTo: startImageView.safeAreaLayoutGuide.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: startImageView.safeAreaLayoutGuide.centerYAnchor),
            startButton.heightAnchor.constraint(equalToConstant: 50),
            startButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
}




