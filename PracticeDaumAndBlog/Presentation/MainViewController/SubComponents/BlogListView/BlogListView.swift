//
//  BlogListView.swift
//  PracticeDaumAndBlog
//
//  Created by 서승우 on 2023/02/11.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class BlogListView: UITableView {
    let disposeBag = DisposeBag()
    
    let headerView = FilterView(frame: CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 50)))
    
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)

        attribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    func bind(_ viewModel: BlogListViewModel) {
        headerView.bind(viewModel.filterViewModel)
    
        viewModel.cellData
            .drive(self.rx.items) { tableView, row, data in
                let indexPath = IndexPath(row: row, section: 0)
                let cell = tableView.dequeueReusableCell(withIdentifier: "BlogListViewCell", for: indexPath) as! BlogListViewCell
                cell.setData(data)

                return cell
            }
            .disposed(by: disposeBag)
    }
    
    private func attribute() {
        self.backgroundColor = .white
        self.register(BlogListViewCell.self, forCellReuseIdentifier: "BlogListViewCell")
        self.separatorStyle = .singleLine
        self.rowHeight = 100
        self.tableHeaderView = headerView
    }
    
}
