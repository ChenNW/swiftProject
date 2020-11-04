//
//  UComicCCell.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/2.
//

import UIKit

enum UComicCCellStyle {
    case none
    case withTitle
    case withTitleAndDesc
}

class UComicCCell: UBaseCollectionViewCell {
    
    private lazy var iconImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var titleLabel:UILabel = {
        let label = UILabel()
        label.textColor = .black
//        label.backgroundColor = .red
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var descLabel:UILabel = {
        let decLabel = UILabel()
        decLabel.font = .systemFont(ofSize: 12)
        decLabel.textColor = .gray
        return decLabel
    }()
    
    override func configUI() {
        clipsToBounds = true
        contentView.addSubview(iconImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descLabel)
    
        descLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            $0.height.equalTo(20)
            $0.bottom.equalToSuperview().offset(-5)
        }
        titleLabel.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            $0.height.equalTo(25)
            $0.bottom.equalTo(descLabel.snp.top)
        }
        
        iconImageView.snp.makeConstraints {
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.top)
        }
    }
    
    var style:UComicCCellStyle = .withTitle{
        
        didSet{
            switch style {
            case .none:
                iconImageView.snp.updateConstraints{
                    $0.bottom.equalToSuperview()
                }
                titleLabel.isHidden = true
                descLabel.isHidden = true
            case .withTitle:
                titleLabel.snp.updateConstraints{
                    $0.bottom.equalTo(descLabel.snp.top).offset(20)
                }
                titleLabel.isHidden = false
                descLabel.isHidden = true
            case .withTitleAndDesc:
//                titleLabel.snp.updateConstraints{
//                    $0.bottom.equalToSuperview().offset(-25)
//                }
                titleLabel.isHidden = false
                descLabel.isHidden = false
            }
            
        }
        
        
    }
    
    
    
    var model: ComicModel?{
        
        didSet{
            guard let model = model else {return}
            iconImageView.setImageView(urlString: model.cover!, placeHorderImage: nil)
            titleLabel.text = model.name ?? model.title
            descLabel.text = model.subTitle ?? "更新至\(model.content ?? "0")集"
        }
    }
    
    
}
