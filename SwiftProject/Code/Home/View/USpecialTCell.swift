//
//  USpecialTCell.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/4.
//

import UIKit

class USpecialTCell: UBaseTableViewCell {

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private lazy var coverImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    private lazy var deslabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        label.font = .systemFont(ofSize: 12)
        label.textColor = .white
        return label
    }()
    
    override func configUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(coverImageView)
        coverImageView.addSubview(deslabel)
        
        titleLabel.snp.makeConstraints{
            $0.left.right.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
            $0.height.equalTo(40)
            $0.top.equalToSuperview()
        }
        coverImageView.snp.makeConstraints{
            $0.left.right.bottom.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 10, bottom: 20, right: 10))
            $0.top.equalTo(titleLabel.snp.bottom)
        }
        deslabel.snp.makeConstraints{
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(20)
        }
        
        let line = UIView().then{
            $0.backgroundColor = UIColor.customBackgroudColor
        }
        contentView.addSubview(line)
        line.snp.makeConstraints{
            $0.left.bottom.right.equalToSuperview()
            $0.height.equalTo(10)
        }
        
    }
    
    var model:ComicModel? {
        didSet{
            guard let model = model else {
                return
            }
            coverImageView.setImageView(urlString: model.cover!, placeHorderImage: nil)
            titleLabel.text = model.title
            deslabel.text = model.subTitle ?? ""
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
