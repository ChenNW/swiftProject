//
//  UReadTopBar.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/9.
//

import UIKit

typealias buttonAction = () -> Void

class UReadTopBar: UIView {
    
    var buttonClick: buttonAction!
    
    lazy var backButton:UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "nav_back_black"), for: .normal)
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        return btn
    }()
    
    lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.font = .boldSystemFont(ofSize: 18)
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    @objc private func btnAction(){
        if buttonClick != nil {
            buttonClick()
        }
    }
    
    func configUI() {
        addSubview(backButton)
        backButton.snp.makeConstraints{
            $0.width.height.equalTo(40)
            $0.left.centerY.equalToSuperview()
        }
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 50))
        }
    }
    
    
    

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
