//
//  UGuessLikeTCell.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/6.
//

import UIKit

class UGuessLikeTCell: UBaseTableViewCell {

    
    private lazy var collectionView: UICollectionView = {
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
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "猜你喜欢"
        return label
    }()
    
    override func configUI() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{
            $0.top.left.right.equalToSuperview().inset(UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15))
            $0.height.equalTo(20)
        }
        
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(5)
            $0.left.bottom.right.equalToSuperview()
        }
    }
    
    var model:GuessYouLikeModel? {
        didSet{
            collectionView.reloadData()
        }
    }
    
    
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
        model?.comics?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UComicCCell.self)
        cell.style = .withTitle
        cell.model = model?.comics?[indexPath.item]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = floor((collectionView.frame.width - 50)/4)
        return CGSize(width: width, height: collectionView.frame.height - 10)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let signalModel = model?.comics?[indexPath.item]
        let vc = UComicViewController(detailId: signalModel!.comic_id)
        topVC?.navigationController?.pushViewController(vc, animated: true)
        
    }
}
