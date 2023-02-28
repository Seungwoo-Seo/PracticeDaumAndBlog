//
//  BlogListViewCell.swift
//  PracticeDaumAndBlog
//
//  Created by 서승우 on 2023/02/11.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit
import Kingfisher

class BlogListViewCell: UITableViewCell {
    let thumbnailImageView = UIImageView()
    let nameLabel = UILabel()
    let titleLabel = UILabel()
    let datetimeLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        thumbnailImageView.contentMode = .scaleAspectFit
        
        nameLabel.font = .systemFont(ofSize: 18, weight: .bold)
        
        titleLabel.font = .systemFont(ofSize: 14)
        titleLabel.numberOfLines = 2
        
        datetimeLabel.font = .systemFont(ofSize: 12, weight: .light)
        
        [thumbnailImageView, nameLabel, titleLabel, datetimeLabel].forEach { contentView.addSubview($0) }
        
        nameLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(8)
            make.trailing.lessThanOrEqualTo(thumbnailImageView.snp.leading).offset(-8)
        }
        
        thumbnailImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.top.trailing.bottom.equalToSuperview().inset(8)
            make.width.height.equalTo(80)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.equalTo(nameLabel)
            make.trailing.equalTo(thumbnailImageView.snp.leading).offset(-8)
        }
        
        datetimeLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(8)
            make.leading.equalTo(nameLabel)
            make.trailing.equalTo(titleLabel)
            make.bottom.equalTo(thumbnailImageView)
        }
    }
    
    func setData(_ data: BlogListViewCellData) {
        thumbnailImageView.kf.setImage(with: data.thumbnailURL, placeholder: UIImage(systemName: "photo"))
        nameLabel.text = data.name
        titleLabel.text = data.title
        
        var datetime: String {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy년 MM월 dd일"
            let contentDate = data.datetime ?? Date()
            
            return dateFormatter.string(from: contentDate)
        }
        
        datetimeLabel.text = datetime
    }
}
