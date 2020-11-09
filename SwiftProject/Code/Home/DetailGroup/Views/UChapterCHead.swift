//
//  UChapterCHead.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/9.
//

import UIKit

typealias sortButtonAction = (_ button: UIButton) -> Void

class UChapterCHead: UBaseCollectionReusableView {

    var buttonAction: sortButtonAction!
    
    private lazy var chapterLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    private lazy var sortButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("倒序", for: .normal)
        btn.setTitleColor(.gray, for: .normal)
        btn.titleLabel?.font = .systemFont(ofSize: 13)
        btn.addTarget(self, action: #selector(sortAction(button:)), for: .touchUpInside)
        return btn
    }()
    
    override func configUI() {
        addSubview(chapterLabel)
        addSubview(sortButton)
        sortButton.snp.makeConstraints{
            $0.right.top.bottom.equalToSuperview()
            $0.width.equalTo(44)
        }
        chapterLabel.snp.makeConstraints{
            $0.left.equalTo(10)
            $0.right.equalTo(sortButton.snp.left).offset(20)
            $0.top.bottom.equalToSuperview()
        }
    }
    
    var model: DetailStaticModel?{
        didSet{
            guard let model = model else {
                return
            }
            
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd"
            chapterLabel.text = "目录\(format.string(from: Date(timeIntervalSince1970: model.comic?.last_update_time ?? 0))) 更新\(model.chapter_list?.last?.name ?? "")"
        }
    }
    
    
    
    @objc private func sortAction(button:UIButton) {
        if buttonAction != nil {
            buttonAction(button)
        }
    }
}
