//
//  URankCCell.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/4.
//

import UIKit

class URankCCell: UBaseCollectionViewCell {
    
    private lazy var coverImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    override func configUI() {
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.cgColor
        layer.masksToBounds = true
        
        contentView.addSubview(coverImage)
        contentView.addSubview(titleLabel)
        
        coverImage.snp.makeConstraints{
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(contentView.snp.width).multipliedBy(0.75)
        }
        titleLabel.snp.makeConstraints{
            $0.left.right.bottom.equalToSuperview()
            $0.top.equalTo(coverImage.snp.bottom)
        }
           
    }
    
    var model:RankingModel?{
        didSet{
            guard let model = model else {
                return
            }
            coverImage.setImageView(urlString: model.cover!, placeHorderImage: nil)
            titleLabel.text = model.sortName
            
        }
    }
    
    
}
