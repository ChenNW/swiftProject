//
//  URankListViewController.swift
//  SwiftProject
//
//  Created by Cnw on 2020/10/30.
//

import UIKit

class URankListViewController: UBaseViewController {

    private lazy var dataArray:[RankingModel] = []
    lazy var tableView: UITableView = {
        let tb = UITableView(frame: CGRect.zero, style: .plain)
        tb.rowHeight = screenWidth * 0.4
        tb.backgroundColor = UIColor.customBackgroudColor
        tb.separatorStyle = .none
        tb.tableFooterView = UIView()
        tb.refreshHeader = URefreshHeader {
            [weak self] in
            self?.loadData()
        }
        tb.uempty = UEmptyView(tapClosure: {
            [weak self] in
            self?.loadData()
        })
        tb.dataSource = self
        tb.register(cellType: URankTCell.self)
        return  tb
    }()
    
    func loadData (){
        ApiLoadingProvider.request(UApi.rankList, model: RankinglistModel.self) { [weak self](result) in
            
            self?.dataArray = result?.rankinglist ?? []
            self?.tableView.uempty?.allowShow = true
            self?.tableView.refreshHeader.endRefreshing()
            self?.tableView.reloadData()
            
        }
    }
    
    override func configUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        // Do any additional setup after loading the view.
    }
    

}


extension URankListViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(for: indexPath, cellType: URankTCell.self)
        cell.model = dataArray[indexPath.row]
        return cell
    }
}
