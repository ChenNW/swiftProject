//
//  URankTCell.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/4.
//

import UIKit

class URankTCell: UBaseTableViewCell {

    private lazy var coverImage: UIImageView = {
        let imageV = UIImageView()
        imageV.contentMode = .scaleAspectFill
        imageV.clipsToBounds = true
        return imageV
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    private lazy var desLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    override func configUI() {
        contentView.addSubview(coverImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(desLabel)
        
        let line = UIView().then{
            $0.backgroundColor = UIColor.customBackgroudColor
        }
        contentView.addSubview(line)
        line.snp.makeConstraints{
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(10)
        }
        coverImage.snp.makeConstraints{
            $0.left.top.equalToSuperview().offset(10)
            $0.bottom.equalTo(line.snp.top).offset(-10)
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(coverImage).offset(20)
            $0.left.equalTo(coverImage.snp.right).offset(10)
            $0.right.equalToSuperview().offset(-10)
            $0.height.equalTo(30)
        }
        desLabel.snp.makeConstraints{
            $0.left.right.equalTo(titleLabel)
            $0.bottom.equalTo(coverImage)
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
    }
    
    var model:RankingModel?{
        didSet{
            guard let model = model else {
                return
            }
            
            coverImage.setImageView(urlString: model.cover!, placeHorderImage: nil)
            titleLabel.text = "\(model.title ?? "")榜"
            desLabel.text = model.subTitle
            
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
