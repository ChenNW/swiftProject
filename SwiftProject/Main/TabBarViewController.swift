//
//  TabBarViewController.swift
//  SwiftProject
//
//  Created by Cnw on 2020/10/29.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVc = HomeViewController(
            titles: ["推荐","VIP","订阅","排行"],
            controllers: [
                UBoutiqueListViewController(),
                UVIPListViewController(VCType: .VipType),
                UVIPListViewController(VCType: .SubsicType),
                URankListViewController()
            ],
            style: .navgationBarSegment)
        addChild(title: "首页", normalImageStr: "tab_home", selectedImageStr: "tab_home_S", childController: homeVc)
        addChild(title: "分类", normalImageStr: "tab_class", selectedImageStr: "tab_class_S", childController: CategoryController())
        
        let bookVC = BookShelfViewController(
            titles: ["收藏","书单","下载"],
            controllers: [UCollectListViewController(),
                          UDocumentListViewController(),
                          UDownloadListViewController()],
            style:.navgationBarSegment)
        
        addChild(title: "书架", normalImageStr: "tab_book", selectedImageStr: "tab_book_S", childController: bookVC)
        addChild(title: "我的", normalImageStr: "tab_mine", selectedImageStr: "tab_mine_S", childController: MineViewController())
        
        
    }
    
    
    func addChild( title:String , normalImageStr:String , selectedImageStr:String ,childController: UIViewController) {
        
        tabBar.barTintColor = .white
        tabBar.isTranslucent = false
        let child = UNavigationViewController(rootViewController: childController)
        child.title = nil
        child.tabBarItem.image = UIImage.init(named: normalImageStr)?.withRenderingMode(.alwaysOriginal)
        child.tabBarItem.selectedImage = UIImage.init(named: selectedImageStr)?.withRenderingMode(.alwaysOriginal)
        child.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor:UIColor.green], for: .selected)
        if UIDevice.current.userInterfaceIdiom == .phone {
            child.tabBarItem.imageInsets = UIEdgeInsets.init(top: 6, left: 0, bottom: -6, right: 0)
        }
        addChild(child)
        
        
    }
    
    
    
}


extension UITabBarController {
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        
        guard let selected = selectedViewController else {
            return .lightContent
        }
        
        return selected.preferredStatusBarStyle
        
    }
}
