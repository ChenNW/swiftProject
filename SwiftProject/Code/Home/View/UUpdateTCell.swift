//
//  UUpdateTCell.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/3.
//

import UIKit

class UUpdateTCell: UBaseTableViewCell {
    
    private lazy var coverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        label.textColor = .white
        return label
    }()
    
    override func configUI() {
        contentView.addSubview(coverImageView)
        coverImageView.addSubview(tipLabel)
        
        coverImageView.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10))
        }
        tipLabel.snp.makeConstraints{
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(20)
        }
        let line = UIView().then{
            $0.backgroundColor = UIColor.customBackgroudColor
        }
        contentView .addSubview(line)
        line.snp.makeConstraints{
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(10)
        }
        
    }
    
    
    var model:ComicModel?{
        didSet{
            guard let model = model else {
                return
            }
            coverImageView.setImageView(urlString: model.cover!, placeHorderImage: nil)
            tipLabel.text = "\(model.description ?? "")"
            
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
