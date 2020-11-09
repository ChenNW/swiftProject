//
//  UChapterCCell.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/9.
//

import UIKit

class UChapterCCell: UBaseCollectionViewCell {
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    override func configUI() {
        contentView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        }
        
        layer.cornerRadius = 5
        layer.borderWidth = 1
        layer.borderColor = UIColor.lightGray.withAlphaComponent(0.5).cgColor
        layer.masksToBounds = true
        
    }
    
    var model:ChapterStaticModel?{
        didSet{
            guard let model = model else {
                return
            }
            nameLabel.text = model.name
            
        }
    }
    
    
    
}
