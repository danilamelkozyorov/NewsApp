//
//  TableViewController.swift
//  TestTaskNews
//
//  Created by Мелкозеров Данила on 22.04.2022.
//

import UIKit
import RealmSwift
import Alamofire

class NewsTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private let cellIdentifier = "NewCellId"
    private let tableView = PagedTableView(frame: .zero)
    lazy var realm = try? Realm()
    
    private var isLoading = false
    
    let request = AlamofireRequest()
    
    var news = [Article]()
    
    override func viewDidLoad() {
     
        super.viewDidLoad()
        configureView()
        configureTableView()
        setTableViewConstraints()
    }

    private func configureView() {
        title = "News"
        view.backgroundColor = .secondarySystemBackground
    }
    
    //MARK: - configuring TableView
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let tableViewLostConnectionCellNib = UINib(nibName: "LostConnectionCell", bundle: nil)
        self.tableView.register(tableViewLostConnectionCellNib, forCellReuseIdentifier: "LostConnectionCellId")
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NewsTableViewCell.self , forCellReuseIdentifier: cellIdentifier)
        tableView.elementsPerPage = 20
        
        tableView.dataSource = self
        tableView.updateDelegate = self
    }
    
    private func setTableViewConstraints() {
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
//MARK: - configuring footerView
    // News over
    private func newsOverFooter() -> UIView {
        let newsOverViewFooter = UIView()
        let newsOverLabelFooter = UILabel()
        
        newsOverViewFooter.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        newsOverViewFooter.backgroundColor = .lightGray
        newsOverViewFooter.addSubview(newsOverLabelFooter)
        newsOverLabelFooter.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        newsOverLabelFooter.text = "Fresh news over"
        newsOverLabelFooter.textAlignment = .center
        return newsOverViewFooter
    }
    
    // News loading
    private func newsLoadingFooter() -> UIView {
        let newsLoadingViewFooter = UIView()
        let newsLoadingIndicatorFooter = UIActivityIndicatorView()
        
        newsLoadingViewFooter.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        newsLoadingViewFooter.backgroundColor = .lightGray
        newsLoadingViewFooter.addSubview(newsLoadingIndicatorFooter)
        newsLoadingIndicatorFooter.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        newsLoadingIndicatorFooter.startAnimating()
        return newsLoadingViewFooter
    }
    
    // Lost Connection
    private func newsLostConnectionFooter() -> UIView {
        let newsLostConnectViewFooter = UIView()
        let newsLostConnectLabelFooter = UILabel()
        let newsLostConnectButtonFooter = UIButton()
        
        newsLostConnectViewFooter.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 75)
        newsLostConnectViewFooter.backgroundColor = .lightGray
        newsLostConnectViewFooter.addSubview(newsLostConnectLabelFooter)
        newsLostConnectViewFooter.addSubview(newsLostConnectButtonFooter)
        
        newsLostConnectLabelFooter.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 25)
        newsLostConnectLabelFooter.text = "Connection lost..."
        newsLostConnectLabelFooter.textAlignment = .center
        
        newsLostConnectButtonFooter.frame = CGRect(x: 0, y: 25, width: view.frame.width, height: 50)
        newsLostConnectButtonFooter.setTitle("Try again", for: .normal)
        newsLostConnectButtonFooter.addTarget(self, action: #selector(lostConnectionButtonAction), for: .touchUpInside)
        return newsLostConnectViewFooter
    }
    
    @objc private func lostConnectionButtonAction() {
        request.fetchNews(for: PagedTableView().currentPage) { [weak self] news in
            guard let strongSelf = self else { return }
            strongSelf.news += news
            strongSelf.tableView.isLoading = false
            DispatchQueue.main.async {
                strongSelf.tableView.reloadData()
                for article in strongSelf.news {
                    strongSelf.saveToStorage(object: article)
                }
            }
        }
    }
    
//MARK: - save to RealmStorage
    func saveToStorage(object: Article) {
        do {
            try realm?.write {
                realm?.add(object, update: .modified)
            }
        } catch {
            print("Error saving object to Realm: \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! NewsTableViewCell
        let new = news[indexPath.row]
        cell.setCell(new: new)
        return cell
    }
}

extension NewsTableViewController: PagedTableViewDelegate {
    func tableView(_ tableView: PagedTableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let webViewNew = NewsWebView()
        webViewNew.newURL = news[indexPath.row].url
        webViewNew.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(webViewNew, animated: true)
    }
    
    func tableView(_ tableView: PagedTableView, needsDataForPage page: Int, completion: @escaping (Int, NSError?) -> Void) {
        let isConnected = NetworkReachabilityManager()?.isReachable ?? false
        if page <= 5 {
            tableView.tableFooterView = nil
            if isConnected {
                tableView.tableFooterView = nil
                if !tableView.isLoading {
                    tableView.tableFooterView = nil
                } else {
                    tableView.tableFooterView = newsLoadingFooter()
                }
                request.fetchNews(for: page, completion: { [weak self] news in
                    guard let strongSelf = self else { return }
                    strongSelf.news += news
                    strongSelf.tableView.isLoading = false
                    completion(news.count, nil)
                    DispatchQueue.main.async {
                        strongSelf.tableView.reloadData()
                        for article in strongSelf.news {
                            strongSelf.saveToStorage(object: article)
                        }
                    }
                })
            } else {
                tableView.tableFooterView = newsLostConnectionFooter()
            }
        } else {
            tableView.hasMore = false
            tableView.tableFooterView = newsOverFooter()
        }
    }
}

