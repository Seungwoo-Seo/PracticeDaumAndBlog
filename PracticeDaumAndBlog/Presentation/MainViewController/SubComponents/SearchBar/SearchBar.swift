//
//  SearchBar.swift
//  PracticeDaumAndBlog
//
//  Created by 서승우 on 2023/02/11.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class SearchBar: UISearchBar {
    let disposeBag = DisposeBag()
    let searchButton = UIButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: SearchBarViewModel) {
        // 서치바 텍스트 바로바로 다른 흐름으로 보냄
        self.rx.text
            .bind(to: viewModel.queryText)
            .disposed(by: disposeBag)
        
        // 검색 버튼 클릭, 키보드 리턴 버튼 클릭
        // 두 클릭을 하나의 흐름으로 보냄
        Observable
            .merge(
                self.rx.searchButtonClicked.asObservable(),
                searchButton.rx.tap.asObservable()
            )
            .bind(to: viewModel.searchButtonTapped)
            .disposed(by: disposeBag)
        
        // 두 클릭 중 아무거나 들어오면
        // 커서 깜박이는거 없앰
        viewModel.searchButtonTapped
            .asSignal()
            .emit(to: self.rx.endEditing)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        searchButton.setTitle("검색", for: .normal)
        searchButton.setTitleColor(.black, for: .normal)
    }
    
    private func layout() {
        [searchButton].forEach { self.addSubview($0) }
        
        searchTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.trailing.equalTo(searchButton.snp.leading).offset(-12)
            make.centerY.equalToSuperview()
        }
        
        searchButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(12)
        }
    }
    
}

extension Reactive where Base: SearchBar {
    var endEditing: Binder<Void> {
        return Binder(base) { base, _ in
            base.endEditing(true)
        }
    }
    
}
