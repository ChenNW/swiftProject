//
//  UDescriptionTCell.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/6.
//

import UIKit

class UDescriptionTCell: UBaseTableViewCell {
    
    private lazy var textView: UITextView = {
        let tw = UITextView()
        tw.textColor = .gray
        tw.font = .systemFont(ofSize: 15)
        return tw
    }()
    
    override func configUI() {
        
        let titleLable = UILabel().then{
            $0.text = " 作品介绍"
        }
        contentView.addSubview(titleLable)
        titleLable.snp.makeConstraints{
            $0.top.left.right.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
            $0.height.equalTo(20)
        }
        
        
        contentView.addSubview(textView)
        textView.snp.makeConstraints{
            $0.top.equalTo(titleLable.snp.bottom)
            $0.left.right.bottom.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
        }
    }
    
    
    var model:DetailStaticModel? {
        didSet{
            guard let model = model else {return}
            textView.text = "【\(model.comic?.cate_id ?? "") \(model.comic?.description ?? "")】"
        }
    }
    
    class func height(for detailStatic:DetailStaticModel?) -> CGFloat {
        
        var height:CGFloat = 50
        guard let model = detailStatic else {
            return 50
        }
        let textView = UITextView().then{
            $0.font = .systemFont(ofSize: 15)
        }
        textView.text = "【\(model.comic?.cate_id ?? "") \(model.comic?.description ?? "")】"
        height += textView.sizeThatFits(CGSize(width: screenWidth - 30, height: CGFloat.infinity)).height
        return height
        
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
