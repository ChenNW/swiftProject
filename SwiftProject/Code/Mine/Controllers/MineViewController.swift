//
//  MineViewController.swift
//  SwiftProject
//
//  Created by Cnw on 2020/10/29.
//

import UIKit

class MineViewController: UBaseViewController {

    ///数据
    private lazy var dataArray: Array = {
        return [
            [["icon":"mine_vip", "title": "我的VIP"],["icon":"mine_coin", "title": "充值妖气币"]],
            [["icon":"mine_accout", "title": "消费记录"],["icon":"mine_subscript", "title": "我的订阅"],["icon":"mine_seal", "title": "我的封印图"]],
            [["icon":"mine_message", "title": "我的消息/优惠券"],["icon":"mine_cashew", "title": "妖果商城"],["icon":"mine_freed", "title": "在线阅读免流量"]],
            [["icon":"mine_feedBack", "title": "帮助中心"],["icon":"mine_mail", "title": "我要反馈"],["icon":"mine_judge", "title": "给我们评分"],["icon":"mine_author", "title": "成为作者"],["icon":"mine_setting", "title": "设置"]]
        ]
    }()
    ///头视图
    private lazy var headView: UMineHead = {
        return UMineHead(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 200))
    }()
    
    ///tableView
    private lazy var tableView: UITableView = {
        let tb = UITableView(frame: CGRect.zero, style: .grouped)
        tb.backgroundColor = UIColor.customBackgroudColor
        tb.delegate = self
        tb.dataSource = self
        tb.register(cellType: UBaseTableViewCell.self)
        return tb
    }()
    
    private lazy var navigationBayY: CGFloat = {
        return self.navigationController?.navigationBar.frame.maxY ?? 0.0
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        edgesForExtendedLayout = .top
    }
    override func configUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        tableView.parallaxHeader.view = headView
        tableView.parallaxHeader.height = 200
        tableView.parallaxHeader.minimumHeight = navigationBayY
        tableView.parallaxHeader.mode = .fill
    }
    override func configNavigationBar() {
        super.configNavigationBar()
        navigationController?.barStyle(.clear)
        tableView.contentOffset = CGPoint(x: 0, y: -tableView.parallaxHeader.height)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MineViewController:UITableViewDelegate,UITableViewDataSource{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= -(tableView.parallaxHeader.minimumHeight) {
            navigationController?.barStyle(.theme)
            navigationItem.title = "我的"
        }else{
            navigationController?.barStyle(.clear)
            navigationItem.title = ""
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        dataArray.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataArray[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        40
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: UBaseTableViewCell.self)
        cell.accessoryType = .disclosureIndicator
        cell.selectionStyle = .none
        let sectionArray = dataArray[indexPath.section]
        let dict = sectionArray[indexPath.row]
        
        cell.imageView?.image = UIImage(named: dict["icon"] ?? "")
        cell.textLabel?.text = dict["title"] ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        10
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        CGFloat.leastNormalMagnitude
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
}


