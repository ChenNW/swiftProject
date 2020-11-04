//
//  CategoryController.swift
//  SwiftProject
//
//  Created by Cnw on 2020/10/29.
//

import UIKit

class CategoryController: UBaseViewController {

    private var dataArray:[RankingModel] = []
    
    private lazy var searchButton: UIButton = {
        let btn = UIButton()
        btn.frame = CGRect(x: 0, y: 0, width: screenWidth - 20, height: 30)
        btn.backgroundColor = UIColor.black.withAlphaComponent(0.1)
        btn.layer.cornerRadius = 15
        btn.clipsToBounds = true
        btn.setTitleColor(.white, for: .normal)
        btn.setImage(UIImage(named: "nav_search")?.withRenderingMode(.alwaysOriginal), for: .normal)
        btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        btn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        btn.addTarget(self, action: #selector(searchButtonClick), for: .touchUpInside)
        btn.titleLabel?.font = .systemFont(ofSize: 15)
        return btn
    }()
    
    @objc private func searchButtonClick() -> Void {
        
    }
    
    private lazy var collectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.minimumLineSpacing = 10
        flow.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow)
        collectionView.backgroundColor = .white
        collectionView.uempty = UEmptyView(tapClosure: {
            [weak self] in
            self?.loadData()
        })
        collectionView.refreshHeader = URefreshHeader{
            [weak self] in
            self?.loadData()
        }
        collectionView.register(cellType: URankCCell.self)
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private func loadData() -> Void {
        ApiLoadingProvider.request(UApi.cateList, model: CategoryModel.self) { [weak self](result) in
            
            self?.collectionView.refreshHeader.endRefreshing()
            self?.dataArray = result?.rankingList ?? []
            self?.collectionView.uempty?.allowShow = true
            self?.searchButton.setTitle(result?.recommendSearch, for: .normal)
            self?.collectionView.reloadData()
            
        }
        
        
    }
    
    override func configUI() {
        navigationItem.titleView = searchButton
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
    }

}

extension CategoryController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (screenWidth - 40)/3
        return CGSize(width: width, height: (width*0.75 + 30))
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: URankCCell.self)
        cell.model = dataArray[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = dataArray[indexPath.item]
        let vc = UComicListViewController(argCon: model.argCon, argName: model.argName, argValue: model.argValue)
        vc.title = model.sortName
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
}
