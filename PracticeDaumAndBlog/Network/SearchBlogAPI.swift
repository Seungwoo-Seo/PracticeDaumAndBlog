//
//  SearchBlogAPI.swift
//  PracticeDaumAndBlog
//
//  Created by 서승우 on 2023/02/11.
//

import Foundation

struct SearchBlogAPI {
    static let scheme = "https"
    static let host = "dapi.kakao.com"
    static let path = "/v2/search/"
    
    // 인코딩도 자동으로 해줌 URLComponents 쓰면
    // 띄어쓰기도 인코딩
    func searchBlog(query: String) -> URLComponents {
        var components = URLComponents()
        components.scheme = SearchBlogAPI.scheme
        components.host = SearchBlogAPI.host
        components.path = SearchBlogAPI.path + "blog"
        
        components.queryItems = [
            URLQueryItem(name: "query", value: query)
        ]
        
        return components
    }
    
}
