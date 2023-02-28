//
//  SearchBarViewModel.swift
//  PracticeDaumAndBlog
//
//  Created by 서승우 on 2023/02/11.
//

import RxSwift
import RxCocoa

struct SearchBarViewModel {
    let disposeBag = DisposeBag()
    
    let queryText = PublishRelay<String?>()
    let searchButtonTapped = PublishRelay<Void>()
    let shouldLoadResult: Observable<String>
    
    init() {
        self.shouldLoadResult = searchButtonTapped
            .withLatestFrom(queryText) { $1 ?? "" }
            .filter { !$0.isEmpty }
            .distinctUntilChanged()
    }
    
}
