//
//  HomeViewController.swift
//  SwiftProject
//
//  Created by Cnw on 2020/10/29.
//

import UIKit

class HomeViewController: UPageViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        isShowRightItem = true
        rightButton.setImage(UIImage(named: "nav_search"), for: .normal)
    }
    
    override func rightButtonClick() {
        navigationController?.pushViewController(USearchViewController(), animated: true)
    }
}
