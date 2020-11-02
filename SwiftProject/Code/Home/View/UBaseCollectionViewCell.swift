//
//  UBaseCollectionViewCell.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/2.
//

import UIKit
import Reusable
class UBaseCollectionViewCell: UICollectionViewCell,Reusable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configUI() {
        
    }
}
