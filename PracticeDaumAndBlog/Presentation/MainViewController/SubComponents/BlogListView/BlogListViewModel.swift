//
//  BlogListViewModel.swift
//  PracticeDaumAndBlog
//
//  Created by 서승우 on 2023/02/11.
//

import RxSwift
import RxCocoa

struct BlogListViewModel {
    
    let filterViewModel = FilterViewModel()
    
    // MainViewController -> BlogListView
    let blogCellData = PublishRelay<[BlogListViewCellData]>()
    let cellData: Driver<[BlogListViewCellData]>
    
    
    init() {
        self.cellData = blogCellData
            .asDriver(onErrorJustReturn: [])
    }
    
}
