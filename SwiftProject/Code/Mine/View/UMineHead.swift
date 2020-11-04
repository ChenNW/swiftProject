//
//  UMineHead.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/4.
//

import UIKit

class UMineHead: UIView {
   
    private lazy var bgImageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "mine_bg_for_boy")
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() -> Void {
        addSubview(bgImageView)
        bgImageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        NotificationCenter.default.addObserver(self, selector: #selector(sexTypeChanged), name: .USexTypeDidChange, object: nil)
    }
    
    @objc func sexTypeChanged (){
        let sexType = UserDefaults.standard.object(forKey: String.sexTypeKey)
        if sexType as! Int == 1 {
            bgImageView.image = UIImage(named: "mine_bg_for_boy")
        }else{
            bgImageView.image = UIImage(named: "mine_bg_for_girl")
        }
    }
    
}
