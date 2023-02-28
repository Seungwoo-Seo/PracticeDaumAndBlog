//
//  SearchBlogNetwork.swift
//  PracticeDaumAndBlog
//
//  Created by 서승우 on 2023/02/11.
//

import Foundation
import RxSwift

class SearchBlogNetwork {
    private let session: URLSession
    let api = SearchBlogAPI()
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func searchBlog(query: String) -> Single<Result<DKBlog, SearchNetworkError>> {
        guard let url = api.searchBlog(query: query).url else {return Single.just(.failure(.invalidURL))}
        
        let request = NSMutableURLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("KakaoAK ade6b5da60b47dd561d533ba09210251", forHTTPHeaderField: "Authorization")
        
        return session.rx.data(request: request as URLRequest)
            .map { data -> Result<DKBlog, SearchNetworkError> in
                do {
                    let blogData = try JSONDecoder().decode(DKBlog.self, from: data)
                    return .success(blogData)
                } catch {
                    return .failure(.invalidJSON)
                }
            }
            .catch { _ in
                Observable.just(.failure(.networkError))
            }
            .asSingle()
    }
}
