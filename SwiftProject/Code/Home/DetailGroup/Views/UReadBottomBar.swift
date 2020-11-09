//
//  UReadBottomBar.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/9.
//

import UIKit

class UReadBottomBar: UIView {

    lazy var menuSlider: UISlider = {
        let ms = UISlider()
        ms.thumbTintColor = UIColor.theme
        ms.minimumTrackTintColor = UIColor.theme
        return ms
    }()
    
    lazy var deviceDirectionButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "readerMenu_changeScreen_horizontal")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    
    lazy var lightButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "readerMenu_luminance")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    
    lazy var chapterButton: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "readerMenu_catalog")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI(){
        addSubview(menuSlider)
        addSubview(deviceDirectionButton)
        addSubview(lightButton)
        addSubview(chapterButton)
        
        menuSlider.snp.makeConstraints{
            $0.left.top.right.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 40, bottom: 10, right: 40))
            $0.height.equalTo(30)
        }
        
        let buttonArray = [deviceDirectionButton,lightButton,chapterButton]
        buttonArray.snp.distributeViewsAlong(axisType: .horizontal,fixedItemLength: 60,leadSpacing: 40,tailSpacing: 40)
        buttonArray.snp.makeConstraints{
            $0.top.equalTo(menuSlider.snp.bottom).offset(10)
            $0.bottom.equalToSuperview()
        }
        
    }

}
