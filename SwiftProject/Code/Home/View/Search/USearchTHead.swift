//
//  USearchTHead.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/10.
//

import UIKit

typealias ButtonAction = (_ button: UIButton) -> Void

class USearchTHead: UBaseTableViewHeaderFooterView {

    var moreButtonAction: ButtonAction?
    
     lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 14)
        lb.textColor = .gray
        return lb
    }()
    
    lazy var moreButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(.lightGray, for: .normal)
        btn.addTarget(self, action: #selector(moreAction(button:)), for: .touchUpInside)
        return btn
    }()
    
    @objc private func moreAction(button: UIButton) {
        if moreButtonAction != nil {
            moreButtonAction!(button)
        }
    }

    override func configUI() {
        contentView.backgroundColor = .white
        contentView.addSubview(titleLabel)
        contentView.addSubview(moreButton)
        
        titleLabel.snp.makeConstraints{
            $0.left.equalToSuperview().offset(10)
            $0.top.bottom.equalToSuperview()
            $0.width.equalTo(200)
        }
        moreButton.snp.makeConstraints{
            $0.top.right.bottom.equalToSuperview()
            $0.width.equalTo(40)
        }
        let line = UIView().then{
            $0.backgroundColor = UIColor.customBackgroudColor
        }
        contentView.addSubview(line)
        line.snp.makeConstraints{
            $0.left.right.bottom.equalToSuperview()
            $0.height.equalTo(1)
        }
        
    }
}
