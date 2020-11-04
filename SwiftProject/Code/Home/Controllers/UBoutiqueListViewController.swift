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
    lazy var imagePathArray:[String] = [
        "https://image.mylife.u17t.com/2020/10/30/1604044030_O5lysl8k59oL.png",
        "https://image.mylife.u17t.com/2019/04/11/1554967452_7K2TbXK99RKx.png",
        "https://image.mylife.u17t.com/2019/08/21/1566385590_81novP118pon.jpg",
        "https://image.mylife.u17t.com/2020/10/30/1604052543_xqQpNXHpqWxQ.jpg",
        "https://image.mylife.u17t.com/2020/10/28/1603877427_2iZB22w4aGW4.png"
    ]
    
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
        bannerV.customPageControlStyle = .snake
        bannerV.customPageControlTintColor = .orange
        
        bannerV.lldidSelectItemAtIndex = bannerImageClick(index:)
        
        return bannerV
    }()
    ///sexButton
   private lazy var sexButton:UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(sexButtonChanged), for: .touchUpInside)
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
        collectionView.register(supplementaryViewType: UComicCHead.self, ofKind: UICollectionView.elementKindSectionHeader)
        collectionView.register(supplementaryViewType: UComicFoot.self, ofKind: UICollectionView.elementKindSectionFooter)
        collectionView.uempty = UEmptyView(verticalOffset: -(collectionView.contentInset.top), tapClosure: { [self] in
            self.loadData(changeSex: false)
        })
        return collectionView
    }()
    
    
    ///banner图点击
   private func bannerImageClick (index: NSInteger) {
        
        
    }
    ///性别按钮的点击
    @objc private func sexButtonChanged (){
        loadData(changeSex: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData(changeSex: false)
    }
    
    ///请求数据
    private func loadData(changeSex: Bool) {
        if changeSex {
//            print(sexType)
            sexType = 1 - sexType
            UserDefaults.standard.setValue(sexType, forKey: String.sexTypeKey)
            UserDefaults.standard.synchronize()
        }
        ApiLoadingProvider.request(UApi.boutiqueList(sexType: sexType), model: BoutiqueListModel.self) { [self] (returnData) in
            
            self.HomeCollectionView.refreshHeader.endRefreshing()
            self.dataArray = returnData?.comicLists ?? []
            self.HomeCollectionView.reloadData()
            self.sexButton.setImage(UIImage(named: self.sexType == 1 ? "gender_female": "gender_male"), for: .normal)
            self.bannerView.imagePaths = imagePathArray
            self.HomeCollectionView.uempty?.allowShow = true
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
    
    ///组头组尾
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            
            let head = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath, viewType: UComicCHead.self)
            let model = dataArray[indexPath.section]
            head.iconImage.setImageView(urlString: model.newTitleIconUrl!, placeHorderImage: nil)
            head.titleLabel.text = model.itemTitle
            head.callBlock = { button in
                
                switch model.comicType {
                case .thematic:
                    let vc = UPageViewController(titles: ["漫画","次元"], controllers: [USpecialViewController(argCon: 2),USpecialViewController(argCon: 4)], style: .navgationBarSegment)
                    self.navigationController?.pushViewController(vc, animated: true)
                case .animation:
                    let webVc = UWebViewController(url: "http://m.u17.com/wap/cartoon/list")
                    webVc.title = "动画"
                    self.navigationController?.pushViewController(webVc, animated: true)

                default:
                    let vc = UComicListViewController(argCon: model.argCon, argName: model.argName, argValue: model.argValue,controllerType: model.comicType)
                    vc.title = model.itemTitle
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
            }
            return head
            
        }else{
            
            let foot = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath, viewType: UComicFoot.self)
            
            return foot
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let comicList = dataArray[section]
        return comicList.itemTitle!.count > 0 ?CGSize(width: screenWidth, height: 44) :CGSize.zero
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return dataArray.count - 1 != section ? CGSize(width: screenWidth, height: 10) : CGSize.zero
    }
}
