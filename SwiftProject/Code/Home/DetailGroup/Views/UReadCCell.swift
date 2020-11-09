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
    
    lazy var placeHolder: UIImageView = {
        let pr = UIImageView(image: UIImage(named: "yaofan"))
        pr.contentMode = .center
        return pr
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
//            imageView.setImageView(urlString: model.location!, placeHorderImage: placeHolder)
//            imageView.setImageView(urlString: model.location, placeHorderImage: placeHolder)
//            imageView.kf.setImage(with: URL(string: model.location!))
            imageView.setImageView(urlString: model.location, placeHorderImage: nil)
        }
    }
    
    
}
