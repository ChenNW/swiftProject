//
//  UReadCCell.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/9.
//

import UIKit

class UReadCCell: UBaseCollectionViewCell {
 
    lazy var imageView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        return img
    }()
    
    lazy var placeHolder: UIImage = {
        let pr = UIImage(named: "yaofan")
        return pr!
    }()
    
    override func configUI() {
        contentView.addSubview(imageView)
        imageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    var model:ImageModel? {
        didSet{
            guard let model = model else {
                return
            }
            imageView.image = nil
            imageView.setImageView(urlString: model.location, placeHorderImage: placeHolder)
        }
    }
    
    
}
