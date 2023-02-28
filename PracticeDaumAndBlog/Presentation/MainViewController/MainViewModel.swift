//
//  MainViewModel.swift
//  PracticeDaumAndBlog
//
//  Created by 서승우 on 2023/02/12.
//

import Foundation
import RxSwift
import RxCocoa

struct MainViewModel {
    let disposeBag = DisposeBag()
    
    let searchBarViewModel = SearchBarViewModel()
    let blogListViewModel = BlogListViewModel()
    
    let alertActionTapped = PublishRelay<MainViewController.AlertAction>()
    let shouldPresentAlert: Signal<MainViewController.Alert>
    
    init(model: MainModel = MainModel()) {
        let blogResult = searchBarViewModel.shouldLoadResult
            .flatMapLatest(model.searchBlog)
            .share()
        
        let blogValue = blogResult
            .compactMap(model.getBlogValue)
        
        let blogError = blogResult
            .compactMap(model.getBlogError)
        
        // 검색하고 검색 결과가 오든 에러가 오든 뭐가 왔음
        // 온 검색 데이터들 왔으면 cellData로 변환
        let cellData = blogValue
            .map(model.getBlogListCellData)
        
        let sortedType = alertActionTapped
            .filter {
                switch $0 {
                case .title, .datetime:
                    return true
                default:
                    return false
                }
            }
            .startWith(.title)
        
        
        Observable
            .combineLatest(
                sortedType,
                cellData,
                resultSelector: model.sort
            )
            .bind(to: blogListViewModel.blogCellData)
            .disposed(by: disposeBag)
        
        let alertSheetForSorting = blogListViewModel.filterViewModel.sortButtonTapped
            .map { _ -> MainViewController.Alert in
                return (title: nil, message: nil, actions: [.title, .datetime, .cancel], style: .actionSheet)
            }
        
        let alertForErrorMessage = blogError
            .map { message -> MainViewController.Alert in
                return (title: "앗!", message: "예상치 못한 오류가 발생 \(message)", actions: [.confirm], style: .alert)
            }
        
        self.shouldPresentAlert = Observable
            .merge(
                alertSheetForSorting,
                alertForErrorMessage
            )
            .asSignal(onErrorSignalWith: .empty())
    }
}
