//
//  MainModel.swift
//  PracticeDaumAndBlog
//
//  Created by 서승우 on 2023/02/12.
//

import RxSwift
import Foundation

struct MainModel {
    let network = SearchBlogNetwork()
    
    func searchBlog(_ query: String) -> Single<Result<DKBlog, SearchNetworkError>> {
        return network.searchBlog(query: query)
    }
    
    func getBlogValue(_ result: Result<DKBlog, SearchNetworkError>) -> DKBlog? {
        guard case .success(let value) = result else {return nil}
        
        return value
    }
    
    func getBlogError(_ result: Result<DKBlog, SearchNetworkError>) -> String? {
        guard case .failure(let error) = result else {return nil}
        
        return error.localizedDescription
    }
    
    func getBlogListCellData(_ value: DKBlog) -> [BlogListViewCellData] {
        return value.documents
            .map { document in
                let thumbnailURL = URL(string: document.thumbnail ?? "")
                return BlogListViewCellData(thumbnailURL: thumbnailURL, name: document.name, title: document.title, datetime: document.datetime)
            }
    }
    
    func sort(by type: MainViewController.AlertAction, of data: [BlogListViewCellData]) -> [BlogListViewCellData] {
        switch type {
        case .title:
            return data.sorted { $0.title ?? "" < $1.title ?? "" }
        case .datetime:
            return data.sorted { $0.datetime ?? Date() > $1.datetime ?? Date() }
        default:
            return data
        }
    }
    
}
