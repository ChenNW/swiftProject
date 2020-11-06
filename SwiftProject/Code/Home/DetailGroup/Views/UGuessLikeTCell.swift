//
//  UGuessLikeTCell.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/6.
//

import UIKit

class UGuessLikeTCell: UBaseTableViewCell {

    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        let cw = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cw.backgroundColor = contentView.backgroundColor
        cw.isScrollEnabled = false
        cw.delegate = self
        cw.dataSource = self
        cw.register(cellType: UComicCCell.self)
        return cw
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension UGuessLikeTCell:UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UComicCCell.self)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        cgsize
    }
    
}
