//
//  SearchNetworkError.swift
//  PracticeDaumAndBlog
//
//  Created by 서승우 on 2023/02/11.
//

import Foundation

enum SearchNetworkError: Error {
    case invalidURL
    case invalidJSON
    case networkError
}
