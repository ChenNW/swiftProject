//
//  UBoutiqueListViewController.swift
//  SwiftProject
//
//  Created by Cnw on 2020/10/30.
//

import UIKit
import LLCycleScrollView

class UBoutiqueListViewController: UBaseViewController {

    private var sexType: Int = UserDefaults.standard.integer(forKey: String.sexTypeKey)
    lazy var dataArray: [ComicListsModel] = []
    
    
    ///头部轮播图
    private lazy var bannerView : LLCycleScrollView = {
        let bannerV = LLCycleScrollView()
        bannerV.backgroundColor = UIColor.customBackgroudColor
        bannerV.autoScrollTimeInterval = 2
        bannerV.placeHolderImage = UIImage(named: "normal_placeholder_h")
        bannerV.coverImage = bannerV.placeHolderImage
        bannerV.pageControlPosition = .center
        bannerV.pageControlBottom = 20
        bannerV.titleBackgroundColor = .clear
        bannerV.lldidSelectItemAtIndex = bannerImageClick(index:)
        
        return bannerV
    }()
    ///sexButton
   private lazy var sexButton:UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(sexButtonChanged), for: .touchUpInside)
        button.setImage(UIImage(named: "gender_male"), for: .normal)
        return button
    }()
    
    ///collectionView
    private lazy var HomeCollectionView : UICollectionView = {
        let flowLayout = UCollectionViewSectionBackgroundLayout ()
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 5
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.customBackgroudColor
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets(top: screenWidth * 0.467, left: 0, bottom: 0, right: 0)
        ///滚动条位置跟collectionview 一致
        collectionView.scrollIndicatorInsets = collectionView.contentInset
        collectionView.refreshHeader = URefreshHeader{
            self.loadData(changeSex: false)
        }
        collectionView.refreshFooter = URefreshDiscoverFooter()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellType: UComicCCell.self)
        collectionView.register(cellType: UBoardCCell.self)
        return collectionView
    }()
    
    
    ///banner图点击
   private func bannerImageClick (index: NSInteger) {
        
        
    }
    ///性别按钮的点击
    @objc private func sexButtonChanged (){
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData(changeSex: false)
    }
    
    ///请求数据
    private func loadData(changeSex: Bool) {
        if changeSex {
            sexType = 3 - sexType
            UserDefaults.standard.setValue(sexType, forKey: String.sexTypeKey)
            UserDefaults.standard.synchronize()
        }
        ApiLoadingProvider.request(UApi.boutiqueList(sexType: sexType), model: BoutiqueListModel.self) { [self] (returnData) in
            
            self.HomeCollectionView.refreshHeader.endRefreshing()
            self.dataArray = returnData?.comicLists ?? []
            self.HomeCollectionView.reloadData()
        }
        
    }
    
    
    ///重写父类
    override func configUI() {
        
        ///collection
        view.addSubview(HomeCollectionView)
        HomeCollectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
        
        ///banner图
        view.addSubview(bannerView)
        bannerView.snp.makeConstraints{
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(200)
        }
        ///sexButton
        view.addSubview(sexButton)
        sexButton.snp.makeConstraints{
            $0.width.height.equalTo(60)
            $0.bottom.equalToSuperview().offset(-20)
            $0.right.equalToSuperview()
        }
    }

}

extension UBoutiqueListViewController: UICollectionViewDataSource,UCollectionViewSectionBackgroundLayoutDelegateLayout
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let seconModel = dataArray[section]
        return seconModel.comics?.prefix(4).count ?? 0
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        return UIColor.white
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let modelArray = self.dataArray[indexPath.section];
        if modelArray.comicType == .billboard {
            let  cell  = collectionView.dequeueReusableCell(for: indexPath, cellType: UBoardCCell.self)
            cell.model = modelArray.comics?[indexPath.item]
            return cell
        }else{
         
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UComicCCell.self)
            cell.model = modelArray.comics?[indexPath.item]
            return cell
        }
    }
    ///size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let comicList = dataArray[indexPath.section]
        if comicList.comicType == .billboard {
            let width = floor((screenWidth - 15.0) / 4.0)
            return CGSize(width: width, height: 80)
        }else {
            if comicList.comicType == .thematic {
                let width = floor((screenWidth - 5.0) / 2.0)
                return CGSize(width: width, height: 120)
            } else {
                let count = comicList.comics?.takeMax(4).count ?? 0
                let warp = count % 2 + 2
                let width = floor((screenWidth - CGFloat(warp - 1) * 5) / CGFloat(warp))
                return CGSize(width: width, height: CGFloat(warp * 80))
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == HomeCollectionView {
            bannerView.snp.updateConstraints{
//                print(scrollView.contentOffset.y,scrollView.contentInset.top)
                $0.top.equalToSuperview().offset(min(0, -(scrollView.contentOffset.y + scrollView.contentInset.top)))
            }
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if scrollView == HomeCollectionView {
            UIView.animate(withDuration: 0.5) {
                self.sexButton.transform = CGAffineTransform(translationX: 50, y: 0)
            }
        }
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == HomeCollectionView {
            UIView.animate(withDuration: 0.5) {
                self.sexButton.transform = CGAffineTransform.identity
            }
        }
    }
    
}
