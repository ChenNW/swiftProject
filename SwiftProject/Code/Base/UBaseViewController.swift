//
//  BaseViewController.swift
//  SwiftProject
//
//  Created by Cnw on 2020/10/29.
//

import UIKit

class UBaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.customBackgroudColor
        if #available(iOS 11.0, *) {
            UIScrollView.appearance().contentInsetAdjustmentBehavior = .never
        }else {
            automaticallyAdjustsScrollViewInsets = false
        }
        
        
        configUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configNavigationBar()
    }
    
    func configUI(){}
    
    func configNavigationBar() {
        guard let nav = navigationController else { return }
        if nav.visibleViewController == self {
            nav.setNavigationBarHidden(false, animated: true)
            nav.barStyle(.theme)
            nav.disablePopGesture = false
            
             
            if nav.viewControllers.count > 1 {
                nav.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: ""), style: .done, target: self, action: #selector(leftButtonClick))
            }
        }
    }
    
    @objc func leftButtonClick (){
        
        navigationController?.popViewController(animated: true)
        
    }

}

extension UBaseViewController{
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
         .lightContent
    }
}
