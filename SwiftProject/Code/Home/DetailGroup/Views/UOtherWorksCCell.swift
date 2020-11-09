//
//  UOtherWorksCCell.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/9.
//

import UIKit

class UOtherWorksCCell: UBaseCollectionViewCell {

    
    private lazy var coverImage: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    private lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 14)
        return lb
    }()
    
    private lazy var desLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 12)
        lb.textColor = .gray
        return lb
    }()
    
    override func configUI() {
        contentView.addSubview(coverImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(desLabel)
        desLabel.snp.makeConstraints{
            $0.left.right.bottom.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            $0.height.equalTo(20)
        }
        titleLabel.snp.makeConstraints{
            $0.left.right.equalTo(desLabel)
            $0.bottom.equalTo(desLabel.snp.top)
            $0.height.equalTo(25)
        }
        coverImage.snp.makeConstraints{
            $0.top.left.right.equalToSuperview()
            $0.bottom.equalTo(titleLabel.snp.top)
        }
    }
    
    
    var model:OtherWorkModel?{
        didSet{
            guard let model = model else {
                return
            }
            coverImage.setImageView(urlString: model.coverUrl!, placeHorderImage: nil)
            titleLabel.text = model.name
            desLabel.text = "更新至\(model.passChapterNum)话"
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


}
