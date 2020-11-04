//
//  UVIPListViewController.swift
//  SwiftProject
//
//  Created by Cnw on 2020/10/30.
//

import UIKit

enum ControllerType {
    case VipType
    case SubsicType
}

class UVIPListViewController: UBaseViewController {
    
    var controllertype:ControllerType = .VipType
    
    private lazy var dataArray: [ComicListsModel] = []
    lazy var collectionView: UICollectionView = {
        let flow = UCollectionViewSectionBackgroundLayout()
        flow.minimumInteritemSpacing = 5
        flow.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor.customBackgroudColor
        collectionView.alwaysBounceVertical = true
        collectionView.register(supplementaryViewType: UComicCHead.self, ofKind: UICollectionView.elementKindSectionHeader)
        collectionView.register(supplementaryViewType: UComicFoot.self, ofKind: UICollectionView.elementKindSectionFooter)
        collectionView.refreshHeader = URefreshHeader{
            [weak self] in
            self?.loadData()
        }
        collectionView.register(cellType: UComicCCell.self)
        var bottomStr:String?
        if controllertype == .VipType{
            bottomStr =  "VIP用户专享\nVIP用户可以免费阅读全部漫画哦~"
        }else{
            bottomStr =  "使用妖气币可以购买订阅漫画\nVIP会员购买还有优惠哦~"
        }
        collectionView.refreshFooter = URefreshTipKissFooter(with:bottomStr!)
        collectionView.uempty = UEmptyView(tapClosure: {
            [weak self] in
            self?.loadData()
        })
        return collectionView
    }()
    
    convenience init( VCType:ControllerType = .VipType) {
        self.init()
        self.controllertype = VCType
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    override func configUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    func loadData(){
        
        if controllertype == .VipType {
            ApiLoadingProvider.request(UApi.vipList, model: VipListModel.self) { [weak self](result) in
                self?.collectionView.refreshHeader.endRefreshing()
                self?.dataArray = result?.newVipList ?? []
                self?.collectionView.uempty?.allowShow = true
                self?.collectionView.reloadData()
            }
        }else{
            ApiLoadingProvider.request(UApi.subscribeList, model:SubscribeListModel.self) { [weak self](result) in
                self?.collectionView.refreshHeader.endRefreshing()
                self?.dataArray = result?.newSubscribeList ?? []
                self?.collectionView.uempty?.allowShow = true
                self?.collectionView.reloadData()
            }
        }
    }
    
}

extension UVIPListViewController: UCollectionViewSectionBackgroundLayoutDelegateLayout,UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        dataArray.count
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        dataArray[section].comics?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, backgroundColorForSectionAt section: Int) -> UIColor {
        .white
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let comModel = dataArray[indexPath.section]
            let head = collectionView.dequeueReusableSupplementaryView(ofKind: kind, for: indexPath, viewType: UComicCHead.self)
            head.iconImage.setImageView(urlString: comModel.titleIconUrl!, placeHorderImage: nil)
            head.titleLabel.text = comModel.itemTitle
            head.moreButton.isHidden = comModel.canMore ? false :true
            head.callBlock = { [weak self]
                button in
                let vc = UComicListViewController(argCon: comModel.argCon, argName: comModel.argName, argValue: comModel.argValue)
                vc.title = comModel.itemTitle
                self?.navigationController?.pushViewController(vc, animated: true)
            }
            return head
            
        }else{
            let foot = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, for: indexPath, viewType: UComicFoot.self)
            return foot
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return dataArray[section].itemTitle?.count ?? 0 > 0 ? CGSize(width: screenWidth, height: 44) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return dataArray.count - 1 != section ? CGSize(width: screenWidth, height: 10) : CGSize.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: UComicCCell.self)
        cell.style = .withTitle
        let comicList = dataArray[indexPath.section]
        cell.model = comicList.comics?[indexPath.row]
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: (screenWidth - 10)/3, height: 240)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let comicList = dataArray[indexPath.section]
        guard let model = comicList.comics?[indexPath.row] else { return }
        //        let vc = UComicViewController(comicid: model.comicId)
        //        navigationController?.pushViewController(vc, animated: true)
    }
}
