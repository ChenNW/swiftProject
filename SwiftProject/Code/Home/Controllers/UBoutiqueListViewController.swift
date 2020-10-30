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
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 5
        flowLayout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = UIColor.customBackgroudColor
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets(top: screenWidth * 0.467, left: 0, bottom: 0, right: 0)
        ///滚动条位置跟collectionview 一致
        collectionView.scrollIndicatorInsets = collectionView.contentInset
        collectionView.refreshHeader = URefreshHeader{
            
        }
        collectionView.refreshFooter = URefreshDiscoverFooter()
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
        
        ApiLoadingProvider.request(UApi.boutiqueList(sexType: sexType)) { [weak self] (returnData) in
            
            print(returnData)
           
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
