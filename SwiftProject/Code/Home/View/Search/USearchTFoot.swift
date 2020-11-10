//
//  USearchTFoot.swift
//  SwiftProject
//
//  Created by Cnw on 2020/11/10.
//

import UIKit

class USearchCCell: UBaseCollectionViewCell {
    
    lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.textColor = .darkGray
        lb.font = .systemFont(ofSize: 14)
        return lb
    }()
    override func configUI() {
        layer.borderWidth = 1
        layer.borderColor = UIColor.customBackgroudColor.cgColor
        layer.cornerRadius = 20
        
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints{
            $0.edges.equalToSuperview().inset(UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20))
        }
    }
    
}

typealias USearchTFootDidSelectIndexClosure = (_ index: Int, _ model: SearchItemModel) -> Void
protocol USearchTFootDelegate: class {
    
    func searchTFoot(_ searchTFoot: USearchTFoot,didSelectedItemAt index: Int, _ model: SearchItemModel)
}

class USearchTFoot: UBaseTableViewHeaderFooterView {

    private var didSelectedIndexClosure: USearchTFootDidSelectIndexClosure?
    weak var delegate: USearchTFootDelegate?
    
    
    private lazy var collectionView: UICollectionView = {
        let flow = UCollectionViewAlignedLayout()
        flow.minimumLineSpacing = 10
        flow.minimumInteritemSpacing = 10
        flow.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flow.horizontalAlignment = .left
        flow.estimatedItemSize = CGSize(width: 100, height: 40)
        
        let cw = UICollectionView(frame: .zero, collectionViewLayout: flow)
        cw.register(cellType: USearchCCell.self)
        cw.backgroundColor = .white
        cw.delegate = self
        cw.dataSource = self
        return cw
    }()
  
    override func configUI() {
        
        contentView.backgroundColor = .white
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    var data:[SearchItemModel] = [] {
        didSet{
            collectionView.reloadData()
        }
    }
    
}

extension USearchTFoot: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: USearchCCell.self)
        cell.titleLabel.text = data[indexPath.item].name
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.searchTFoot(self, didSelectedItemAt: indexPath.item, data[indexPath.item])
        guard let closure = didSelectedIndexClosure else {
            return
        }
        closure(indexPath.item,data[indexPath.item])
    }
    
    func didSelectIndexClosure(_ closure: @escaping USearchTFootDidSelectIndexClosure){
        didSelectedIndexClosure = closure
    }
    
}
