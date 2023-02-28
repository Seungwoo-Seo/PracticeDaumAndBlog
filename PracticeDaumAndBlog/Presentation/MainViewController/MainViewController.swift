//
//  MainViewController.swift
//  PracticeDaumAndBlog
//
//  Created by 서승우 on 2023/02/11.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class MainViewController: UIViewController {
    let disposeBag = DisposeBag()
    
    let searchBar = SearchBar()
    let blogListView = BlogListView()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        attribute()
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bind(_ viewModel: MainViewModel) {
        searchBar.bind(viewModel.searchBarViewModel)
        blogListView.bind(viewModel.blogListViewModel)
        
        viewModel.shouldPresentAlert
            .flatMap { alert -> Signal<AlertAction> in
                let alertController = UIAlertController(title: alert.title, message: alert.message, preferredStyle: alert.style)
                return self.presentAlertController(alertController, actions: alert.actions)
            }
            .emit(to: viewModel.alertActionTapped)
            .disposed(by: disposeBag)
           
    }
    
    private func attribute() {
        title = "다음 블로그 검색"
        view.backgroundColor = .white
    }
    
    private func layout() {
        [searchBar, blogListView].forEach { self.view.addSubview($0) }
        
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }
        
        blogListView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
}


extension MainViewController {
    typealias Alert = (title: String?, message: String?, actions: [AlertAction], style: UIAlertController.Style)
    
    enum AlertAction: AlertActionConvertible {
        case title
        case datetime
        case cancel
        case confirm
        
        var title: String {
            switch self {
            case .title:
                return "Title"
            case .datetime:
                return "Datetime"
            case .cancel:
                return "취소"
            case .confirm:
                return "확인"
            }
        }
        
        var style: UIAlertAction.Style {
            switch self {
            case .title, .datetime:
                return .default
            case .cancel, .confirm:
                return .cancel
            }
        }
    }
    
    func presentAlertController<Action: AlertActionConvertible>(_ alertController: UIAlertController, actions: [Action]) -> Signal<Action> {
        if actions.isEmpty { return .empty() }
        
        return Observable.create { [weak self] observer in
            guard let self = self else {return Disposables.create()}
            for action in actions {
                alertController.addAction(UIAlertAction(title: action.title, style: action.style) { _ in
                    observer.onNext(action)
                    observer.onCompleted()
                })
            }
            self.present(alertController, animated: true)
            
            return Disposables.create {
                alertController.dismiss(animated: true)
            }
        }
        .asSignal(onErrorSignalWith: .empty())
    }
    
}
