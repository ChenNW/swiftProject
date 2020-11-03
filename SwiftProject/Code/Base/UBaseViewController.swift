//
//  BaseViewController.swift
//  SwiftProject
//
//  Created by Cnw on 2020/10/29.
//

import UIKit

class UBaseViewController: UIViewController {

    
    var isShowRightItem:Bool?{
        didSet{
            guard let isShow = isShowRightItem else {
                return
            }
            if isShow == true {
                navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightButton)
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.customBackgroudColor
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        configNavigationBar()
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        configNavigationBar()
    }
    
    func configUI(){}
    
    func configNavigationBar() {
        guard let nav = navigationController else { return }
        if nav.visibleViewController == self {
            nav.barStyle(.theme)
            nav.disablePopGesture = false
            nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white,NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 18)]
            nav.setNavigationBarHidden(false, animated: true)
            
             
            if nav.viewControllers.count > 1 {
                navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftButton)
            }
        }
    }
    
    @objc func leftButtonClick (){
        
        navigationController?.popViewController(animated: true)
        
    }
    
    lazy var leftButton:UIButton = {
       let button = UIButton()
        button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        button.setImage(UIImage(named: "nav_back_white")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.adjustsImageWhenHighlighted = false
        button.addTarget(self, action: #selector(leftButtonClick), for: .touchUpInside)
        return button
    }()
    
    lazy var rightButton:UIButton = {
        let button = UIButton()
         button.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
         button.setImage(UIImage(named: "nav_reload")?.withRenderingMode(.alwaysOriginal), for: .normal)
         button.adjustsImageWhenHighlighted = false
         button.addTarget(self, action: #selector(rightButtonClick), for: .touchUpInside)
         return button
    }()
    @objc func rightButtonClick (){
        
    }

}

extension UBaseViewController{
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
         .lightContent
    }
}
