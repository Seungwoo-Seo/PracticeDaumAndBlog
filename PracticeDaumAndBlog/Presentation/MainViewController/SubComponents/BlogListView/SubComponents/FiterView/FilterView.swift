//
//  FilterView.swift
//  PracticeDaumAndBlog
//
//  Created by 서승우 on 2023/02/11.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class FilterView: UITableViewHeaderFooterView {
    let disposeBag = DisposeBag()
    
    let sortButton = UIButton()
    let bottomBorder = UIView()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: FilterViewModel) {
        sortButton.rx.tap
            .bind(to: viewModel.sortButtonTapped)
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        sortButton.setImage(UIImage(systemName: "list.bullet"), for: .normal)
        bottomBorder.backgroundColor = .lightGray
    }
    
    private func layout() {
        [sortButton, bottomBorder].forEach { self.addSubview($0) }
        
        sortButton.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.trailing.equalToSuperview().inset(12)
            make.width.height.equalTo(28)
        }
        
        bottomBorder.snp.makeConstraints { make in
            make.top.equalTo(sortButton.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
}
