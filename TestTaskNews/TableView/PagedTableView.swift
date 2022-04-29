//
//  PagedTableView.swift
//  TestTaskNews
//
//  Created by Мелкозеров Данила on 27.04.2022.
//  Честно взято отсюда: https://github.com/rootstrap/PagedLists
//

import Foundation
import UIKit

public protocol PagedTableViewDelegate: class {
    // Required - Should not call this method directly or you will need to take care of
    // page update and flags status. Call loadContentIfNeeded instead
    func tableView(
        _ tableView: PagedTableView,
        needsDataForPage page: Int,
        completion: @escaping (_ elementsAdded: Int, _ error: NSError?) -> Void
    )
    func tableView(_ tableView: PagedTableView, didSelectRowAt indexPath: IndexPath)
}

public enum PagingDirectionType {
    case atBottom
    case atTop
}

open class PagedTableView: UITableView {
    
    public var currentPage = 1
    public var isLoading = false
    //  This will be handled automatically taking into account newElements of updateDelegate completion
    //  call and elementsPerPage. If your uploadDelegate provides pagination data, you can take control
    //  over this flag to avoid unnecesary calls to your delegate.
    public var hasMore = true
    public var elementsPerPage = 10
    // Responsible for loading the content and call the completion with newElements count.
    public weak var updateDelegate: PagedTableViewDelegate!
    // Tells when pagination calls occurs. Options are when the tableView reaches bottom(.AtBottom) or top(.AtTop)
    public var direction: PagingDirectionType = .atBottom
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        commonInit()
    }
    
    private func commonInit() {
        delegate = self
    }
    
    public func loadContentIfNeeded() {
        guard hasMore && !isLoading else {
            return
        }
        isLoading = true
        updateDelegate.tableView(
            self,
            needsDataForPage: currentPage,
            completion: { (newElements, error) in
                self.isLoading = false
                guard error == nil else {
                    return
                }
                self.currentPage += 1
                self.hasMore = newElements == self.elementsPerPage
            })
    }
    
    public func reset() {
        currentPage = 1
        hasMore = true
        isLoading = false
    }
    
    func didScrollBeyondTop() -> Bool {
        return contentOffset.y < 0
    }
    
    func didScrollBeyondBottom() -> Bool {
        return contentOffset.y >= (contentSize.height - bounds.size.height)
    }
}

extension PagedTableView: UITableViewDelegate, UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if direction == .atBottom {
            if didScrollBeyondTop() {
                return
            } else if didScrollBeyondBottom() {
                loadContentIfNeeded()
            }
        } else {
            if didScrollBeyondTop() {
                loadContentIfNeeded()
            }
        }
    }
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let pagedTableView = tableView as? PagedTableView {
            updateDelegate.tableView(pagedTableView, didSelectRowAt: indexPath)
        }
    }
}

