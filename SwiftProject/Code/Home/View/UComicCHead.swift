//
//  UComicCHead.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/2.
//

import UIKit

typealias buttonClickBlock = (_ button: UIButton) -> Void

class UComicCHead: UBaseCollectionReusableView {
    
    var callBlock: buttonClickBlock?
    
    
    lazy var iconImage:UIImageView = {
        return UIImageView()
    }()
    
    lazy var titleLabel:UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .black
        return label
    }()
    
    lazy var moreButton:UIButton = {
       let btn = UIButton()
        btn.setTitle("•••", for: .normal)
        btn.setTitleColor(.lightGray, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 12)
        btn.addTarget(self, action: #selector(buttonClick), for: .touchUpInside)
        return btn
    }()
    
    override func configUI() {
        addSubview(iconImage)
        addSubview(titleLabel)
        addSubview(moreButton)
        
        iconImage.snp.makeConstraints{
            $0.left.equalToSuperview().offset(5)
            $0.size.equalTo(CGSize(width: 40, height: 40))
            $0.centerY.equalToSuperview()
        }
        titleLabel.snp.makeConstraints{
            $0.left.equalTo(iconImage.snp.right).offset(5)
            $0.centerY.equalTo(iconImage.snp.centerY)
            $0.width.equalTo(200)
        }
        moreButton.snp.makeConstraints{
            $0.right.top.bottom.equalToSuperview()
            $0.width.equalTo(40)
        }
    }
    
    @objc func buttonClick(button:UIButton){
        if callBlock != nil {
            callBlock!(button)
        }
    }
}
