//
//  UCommentTCell.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/9.
//

import UIKit

class UCommentTCell: UBaseTableViewCell {

    private lazy var iconImage: UIImageView = {
        let icon = UIImageView()
        icon.contentMode = .scaleAspectFill
        icon.layer.cornerRadius = 20
        icon.clipsToBounds = true
        return icon
    }()
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 0
        return label
    }()
    
    override func configUI() {
        contentView.addSubview(iconImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(contentLabel)
        
        iconImage.snp.makeConstraints{
            $0.left.top.equalToSuperview().offset(10)
            $0.width.height.equalTo(40)
        }
        nameLabel.snp.makeConstraints{
            $0.left.equalTo(iconImage.snp.right).offset(15)
            $0.right.equalToSuperview().offset(-15)
            $0.top.equalTo(iconImage)
            $0.height.equalTo(15)
        }
        contentLabel.snp.makeConstraints{
            $0.left.right.equalTo(nameLabel)
            $0.bottom.greaterThanOrEqualToSuperview().offset(-10)
            $0.top.equalTo(nameLabel.snp.bottom).offset(10)
        }
    }
    
    
    var viewModel:UCommentViewModel?{
        didSet{
            guard let viewModel = viewModel else {
                return
            }
            iconImage.setImageView(urlString: viewModel.model?.face, placeHorderImage: nil)
            nameLabel.text = viewModel.model?.nickname
            contentLabel.text = viewModel.model?.content_filter
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
class UCommentViewModel {
    var model: CommentModel?
    var height: CGFloat = 0
    
    convenience init(model: CommentModel) {
        self.init()
        self.model = model
        let tw = UITextView().then{
            $0.font = .systemFont(ofSize: 13)
        }
        tw.text = model.content_filter
        let height = tw.sizeThatFits(CGSize(width: screenWidth - 70, height: CGFloat.infinity)).height
        self.height = max(60, height + 45)
        
    }
    
    
    required init(){}
    
}
